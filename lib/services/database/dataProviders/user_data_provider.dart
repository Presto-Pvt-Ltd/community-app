import 'dart:async';

import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/models/user/notification_data_model.dart';
import 'package:presto/models/user/personal_data_model.dart';
import 'package:presto/models/user/platform_data_model.dart';
import 'package:presto/models/user/platform_ratings_data.dart';
import 'package:presto/models/user/transaction_data_model.dart';
import 'package:presto/services/database/dataHandlers/profileDataHandler.dart';
import 'package:presto/services/error/error.dart';

class UserDataProvider {
  final log = getLogger("UserDataProvider");

  final ProfileDataHandler _profileDataHandler = locator<ProfileDataHandler>();
  final ErrorHandlingService _errorHandlingService =
      locator<ErrorHandlingService>();

  /// Profile data
  NotificationToken? _token;
  PersonalData? _personalData;
  PlatformData? _platformData;
  TransactionData? _transactionData;
  PlatformRatings? _platformRatingsData;
  StreamController<List<String>> _transactionIdAsStream =
      StreamController<List<String>>();
  StreamController<bool> _gotData = StreamController<bool>.broadcast();

  /// Getters for profile data
  NotificationToken? get token => _token;
  PersonalData? get personalData => _personalData;
  PlatformData? get platformData => _platformData;
  TransactionData? get transactionData => _transactionData;
  PlatformRatings? get platformRatingsData => _platformRatingsData;
  Stream<List<String>> get transactionIdAsStream =>
      _transactionIdAsStream.stream;
  Stream<bool> get gotData => _gotData.stream;

  void disposeStreams() {
    _gotData.close();
  }

  void loadData({
    required String uid,
    required ProfileDocument typeOfDocument,
  }) async {
    try {
      _gotData.add(false);
      log.v("Trying to get data from local storage");

      /// Fetch data from local storage
      await _profileDataHandler
          .getProfileData(
        typeOfData: typeOfDocument,
        userId: uid,
        fromLocalDatabase: true,
      )
          .then((dataMap) {
        if (dataMap == <String, dynamic>{}) {
          log.v("Local Storage is empty");

          ///  if [dataMap] is empty i.e. local storage dont have data
          /// fetch from online storage
          _profileDataHandler
              .getProfileData(
            typeOfData: typeOfDocument,
            userId: uid,
            fromLocalDatabase: false,
          )
              .then((onlineDataMap) {
            log.v("Retrieved from online storage: $onlineDataMap");

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
          log.v("Local Storage is not empty : $dataMap");

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
              _platformRatingsData = PlatformRatings.fromJson(dataMap);
              break;
          }
        }
        if (_personalData != null &&
            _platformData != null &&
            _token != null &&
            _platformRatingsData != null &&
            _transactionData != null) {
          _gotData.add(true);
        }
      });
    } catch (e) {
      _errorHandlingService.handleError(error: e);
      Future.delayed(
        Duration(seconds: 2),
        () {
          loadData(uid: uid, typeOfDocument: typeOfDocument);
        },
      );
    }
  }
}
