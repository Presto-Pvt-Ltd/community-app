import 'dart:async';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/app/app.router.dart';
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

  /// Getters for profile data
  NotificationToken? get token => _token;
  PersonalData? get personalData => _personalData;
  PlatformData? get platformData => _platformData;
  TransactionData? get transactionData => _transactionData;
  PlatformRatings? get platformRatingsData => _platformRatingsData;

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

  set platformRatingsData(PlatformRatings? platformRatings) {
    this._platformRatingsData = platformRatings;
  }

  void dispose() {
    _token = null;
    _personalData = null;
    _platformData = null;
    _transactionData = null;
    _platformRatingsData = null;
  }

  Future<bool> loadData({
    required String referralCode,
    required ProfileDocument typeOfDocument,
    bool dataIsLive = false,
  }) async {
    try {
      log.v("Trying to get data from local storage");
      if (dataIsLive) {
        return await _profileDataHandler
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
            log.v(
                "Retrieved from online storage: $onlineDataMap \n${onlineDataMap.runtimeType}");

            /// after fetching from online storage update local storage
            _profileDataHandler.updateProfileData(
              data: onlineDataMap,
              typeOfDocument: typeOfDocument,
              userId: referralCode,
              toLocalDatabase: true,
            );
            setData(
              dataMap: onlineDataMap,
              typeOfDocument: typeOfDocument,
            );
            return true;
          }
        });
      }

      /// Fetch data from local storage
      return await _profileDataHandler
          .getProfileData(
        typeOfData: typeOfDocument,
        userId: referralCode,
        fromLocalDatabase: true,
      )
          .then((dataMap) {
        log.v("Local Storage Response : $dataMap \n${dataMap.runtimeType}");

        /// Forcefully retrieve transactionData from firestore
        if (typeOfDocument == ProfileDocument.userTransactionsData) {
          dataMap = <String, dynamic>{};
        }
        if (dataMap == <String, dynamic>{} || dataMap.isEmpty) {
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
              log.v(
                  "Retrieved from online storage: $onlineDataMap \n${onlineDataMap.runtimeType}");

              /// after fetching from online storage update local storage
              _profileDataHandler.updateProfileData(
                data: onlineDataMap,
                typeOfDocument: typeOfDocument,
                userId: referralCode,
                toLocalDatabase: true,
              );
              setData(
                dataMap: onlineDataMap,
                typeOfDocument: typeOfDocument,
              );
              return true;
            }
          });
        } else {
          /// if [dataMap] is not empty fill the data
          log.v(
              "Local Storage is not empty : $dataMap \n${dataMap.runtimeType}");
          setData(
            dataMap: dataMap,
            typeOfDocument: typeOfDocument,
          );

          return true;
        }
      });
    } catch (e) {
      log.e("There was error here");
      _errorHandlingService.handleError(error: e);
      return Future.delayed(
        Duration(seconds: 2),
        () {
          if (e.toString() == "Reading from your storage")
            return loadData(
              referralCode: referralCode,
              typeOfDocument: typeOfDocument,
            );
          else {
            log.e(referralCode);
            log.e(typeOfDocument);
            return false;
          }
        },
      );
    }
  }

  void setData(
      {required ProfileDocument typeOfDocument,
      required Map<String, dynamic> dataMap}) {
    switch (typeOfDocument) {
      case ProfileDocument.userPersonalData:
        _personalData = PersonalData.fromJson(dataMap);
        break;
      case ProfileDocument.userTransactionsData:
        _transactionData = TransactionData.fromJson(dataMap);
        break;

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
}
