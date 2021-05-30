import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/app/app.router.dart';
import 'package:presto/main.dart';
import 'package:presto/models/user/notification_data_model.dart';
import 'package:presto/models/user/personal_data_model.dart';
import 'package:presto/models/user/platform_data_model.dart';
import 'package:presto/models/user/platform_ratings_data.dart';
import 'package:presto/models/user/transaction_data_model.dart';
import 'package:presto/services/authentication.dart';
import 'package:presto/services/database/dataHandlers/profileDataHandler.dart';
import 'package:presto/services/database/hiveDatabase.dart';
import 'package:presto/services/error/error.dart';
import 'package:stacked_services/stacked_services.dart';

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

  /// Getters for profile data
  NotificationToken? get token => _token;
  PersonalData? get personalData => _personalData;
  PlatformData? get platformData => _platformData;
  TransactionData? get transactionData => _transactionData;
  PlatformRatings? get platformRatingsData => _platformRatingsData;
  Stream<List<String>> get transactionIdAsStream =>
      _transactionIdAsStream.stream;

  /// Setters for profile Data
  set token(NotificationToken? token) {
    this._token = token!;
  }

  set personalData(PersonalData? personalData) {
    this._personalData = personalData!;
  }

  set platformData(PlatformData? platformData) {
    this._platformData = platformData!;
  }

  set transactionData(TransactionData? transactionData) {
    this._transactionData = transactionData!;
  }

  set platformRatings(PlatformRatings platformRatings) {
    this._platformRatingsData = platformRatings;
  }

  Future<bool> loadData({
    required String referralCode,
    required ProfileDocument typeOfDocument,
  }) async {
    try {
      gotUserDataStreamController.add(false);
      log.v("Trying to get data from local storage");

      /// Fetch data from local storage
      return await _profileDataHandler
          .getProfileData(
        typeOfData: typeOfDocument,
        userId: referralCode,
        fromLocalDatabase: true,
      )
          .then((dataMap) {
        if (dataMap == {} || dataMap.isEmpty) {
          log.v("Local Storage is empty");

          ///  if [dataMap] is empty i.e. local storage dont have data
          /// fetch from online storage
          return _profileDataHandler
              .getProfileData(
            typeOfData: typeOfDocument,
            userId: referralCode,
            fromLocalDatabase: false,
          )
              .then((onlineDataMap) {
            if (onlineDataMap == {} ||
                onlineDataMap.isEmpty ||
                onlineDataMap == <String, dynamic>{}) {
              return locator<HiveDatabaseService>()
                  .deleteBox(uid: locator<AuthenticationService>().uid!)
                  .then((value) {
                return locator<AuthenticationService>()
                    .deleteUser()
                    .then((value) {
                  locator<NavigationService>()
                      .clearStackAndShow(Routes.startUpView);
                  return false;
                });
              });
            } else {
              log.v("Retrieved from online storage: $onlineDataMap");

              /// after fetching from online storage update local storage
              _profileDataHandler.updateProfileData(
                data: onlineDataMap,
                typeOfDocument: typeOfDocument,
                userId: referralCode,
                toLocalDatabase: true,
              );
              switch (typeOfDocument) {
                case ProfileDocument.userPersonalData:
                  _personalData = PersonalData.fromJson(onlineDataMap);
                  break;
                case ProfileDocument.userTransactionsData:
                  {
                    _transactionData = TransactionData.fromJson(onlineDataMap);
                    _transactionIdAsStream
                        .add(_transactionData!.transactionIds);
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
                    log.log(Level.warning, "Fetched data stream updated");
                    gotUserDataStreamController.add(true);
                    break;
                  }
              }
              return true;
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
          return true;
        }
      });
    } catch (e) {
      _errorHandlingService.handleError(error: e);
      return Future.delayed(
        Duration(seconds: 2),
        () {
          if (e.toString() == "Reading from your storage")
            return loadData(
                referralCode: referralCode, typeOfDocument: typeOfDocument);
          else
            return false;
        },
      );
      return false;
    }
  }
}
