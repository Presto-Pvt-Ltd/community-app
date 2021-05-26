import 'dart:async';

import 'package:presto/app/app.locator.dart';
import 'package:presto/models/user/notification_data_model.dart';
import 'package:presto/models/user/personal_data_model.dart';
import 'package:presto/models/user/platform_data_model.dart';
import 'package:presto/models/user/platform_ratings_data.dart';
import 'package:presto/models/user/transaction_data_model.dart';
import 'package:presto/services/database/dataHandlers/profileDataHandler.dart';

class UserDataProvider {
  final ProfileDataHandler _profileDataHandler = locator<ProfileDataHandler>();

  /// Profile data
  NotificationToken? _token;
  PersonalData? _personalData;
  PlatformData? _platformData;
  TransactionData? _transactionData;
  PlatformRatings? _platformRatingsData;
  StreamController<List<String>> _transactionIdAsStream =
      StreamController<List<String>>();
  StreamController<bool> _gotData = StreamController<bool>();

  /// Getters for profile data
  NotificationToken? get token => _token;
  PersonalData? get personalData => _personalData;
  PlatformData? get platformData => _platformData;
  TransactionData? get transactionData => _transactionData;
  PlatformRatings? get platformRatingsData => _platformRatingsData;
  Stream<List<String>> get transactionIdAsStream =>
      _transactionIdAsStream.stream;
  Stream<bool> get gotData => _gotData.stream;

  void loadData({
    required String uid,
    required ProfileDocument typeOfDocument,
  }) async {
    try {
      _gotData.add(false);

      /// Fetch data from local storage
      await _profileDataHandler
          .getProfileData(
        typeOfData: typeOfDocument,
        userId: uid,
        fromLocalDatabase: true,
      )
          .then((dataMap) {
        if (dataMap == <String, dynamic>{}) {
          ///  if [dataMap] is empty i.e. local storage dont have data
          /// fetch from online storage
          _profileDataHandler
              .getProfileData(
            typeOfData: typeOfDocument,
            userId: uid,
            fromLocalDatabase: false,
          )
              .then((onlineDataMap) {
            /// after fetching from online storage update local storage
            _profileDataHandler.updateProfileData(
              data: onlineDataMap,
              typeOfDocument: typeOfDocument,
              userId: uid,
              toLocalDatabase: true,
            );
            switch (typeOfDocument) {
              case ProfileDocument.userPersonalData:
                _personalData = PersonalData.fromJson(onlineDataMap);
                break;
              case ProfileDocument.userTransactionsData:
                {
                  _transactionData = TransactionData.fromJson(onlineDataMap);
                  _transactionIdAsStream.add(_transactionData!.transactionIds);
                  break;
                }
              case ProfileDocument.userNotificationToken:
                _token = NotificationToken.fromJson(onlineDataMap);
                break;
              case ProfileDocument.userPlatformData:
                _platformData = PlatformData.fromJson(onlineDataMap);
                break;
              case ProfileDocument.userPlatformRatings:
                {
                  _platformRatingsData =
                      PlatformRatings.fromJson(onlineDataMap);
                  _gotData.add(true);
                  break;
                }
            }
          });
        } else {
          /// if [dataMap] is not empty fill the data
          switch (typeOfDocument) {
            case ProfileDocument.userPersonalData:
              _personalData = PersonalData.fromJson(dataMap);
              break;
            case ProfileDocument.userTransactionsData:
              {
                _transactionData = TransactionData.fromJson(dataMap);
                _transactionIdAsStream.add(_transactionData!.transactionIds);
                break;
              }
            case ProfileDocument.userNotificationToken:
              _token = NotificationToken.fromJson(dataMap);
              break;
            case ProfileDocument.userPlatformData:
              _platformData = PlatformData.fromJson(dataMap);
              break;
            case ProfileDocument.userPlatformRatings:
              {
                _platformRatingsData = PlatformRatings.fromJson(dataMap);
                _gotData.add(true);
                break;
              }
          }
        }
      });
    } catch (e) {
      Future.delayed(
        Duration(seconds: 2),
        () {
          loadData(uid: uid, typeOfDocument: typeOfDocument);
        },
      );
    }
  }
}
