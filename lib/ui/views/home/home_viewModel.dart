import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/models/limits/transaction_limit_model.dart';
import 'package:presto/models/user/notification_data_model.dart';
import 'package:presto/models/user/transaction_data_model.dart';
import 'package:presto/services/database/dataHandlers/communityTreeDataHandler.dart';
import 'package:presto/services/database/dataHandlers/limitsDataHandler.dart';
import 'package:presto/services/database/dataHandlers/profileDataHandler.dart';
import 'package:presto/services/database/dataProviders/limits_data_provider.dart';
import 'package:presto/services/database/dataProviders/transactions_data_provider.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:presto/services/database/hiveDatabase.dart';
import 'package:presto/services/error/error.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/authentication.dart';

class HomeViewModel extends IndexTrackingViewModel {
  final log = getLogger("HomeViewModel");
  late String referralCode;
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final ErrorHandlingService _errorHandlingService =
      locator<ErrorHandlingService>();
  final NavigationService _navigationService = locator<NavigationService>();
  late bool isCM;

  /// Data providers
  final UserDataProvider _userDataProvider = locator<UserDataProvider>();
  final TransactionsDataProvider _transactionsDataProvider =
      locator<TransactionsDataProvider>();

  Future<void> refresh() async {
    locator<UserDataProvider>().dispose();
    locator<TransactionsDataProvider>().dispose();
    onModelReady(currentIndex);
  }

  Future<void> onModelReady(int index) async {
    setBusy(true);
    locator<HiveDatabaseService>()
        .openBox(uid: locator<AuthenticationService>().uid!)
        .then((value) {
      /// Getting initial data:

      setIndex(index);
      try {
        referralCode = _authenticationService.referralCode!;

        /// Trying to load data
        _userDataProvider
            .loadData(
          referralCode: referralCode,
          typeOfDocument: ProfileDocument.userPersonalData,
        )
            .then((value) {
          if (value) {
            _userDataProvider
                .loadData(
              referralCode: referralCode,
              typeOfDocument: ProfileDocument.userNotificationToken,
            )
                .then((value) {
              if (value) {
                _userDataProvider
                    .loadData(
                  referralCode: referralCode,
                  typeOfDocument: ProfileDocument.userTransactionsData,
                )
                    .then((value) {
                  if (value) {
                    _userDataProvider
                        .loadData(
                      referralCode: referralCode,
                      typeOfDocument: ProfileDocument.userPlatformData,
                    )
                        .then((value) {
                      locator<LimitsDataHandler>()
                          .getLimitsData(
                        typeOfLimit: LimitDocument.transactionLimits,
                        fromLocalDatabase: false,
                      )
                          .then((limitMap) {
                        locator<LimitsDataProvider>().transactionLimits =
                            TransactionLimits.fromJson(limitMap);
                        locator<CommunityTreeDataHandler>()
                            .getLenderNotificationTokens(
                          currentReferralId:
                              _userDataProvider.platformData!.referralCode,
                          levelCounter: locator<LimitsDataProvider>()
                              .transactionLimits!
                              .levelCounter,
                          communityName:
                              _userDataProvider.platformData!.community,
                          downCounter: locator<LimitsDataProvider>()
                              .transactionLimits!
                              .downCounter,
                          parentReferralID:
                              _userDataProvider.platformData!.referredBy,
                        );
                      });
                      if (value) {
                        FirebaseMessaging.instance.getToken().then((value) {
                          if (value !=
                                  _userDataProvider.token!.notificationToken &&
                              value != null) {
                            // locator<CommunityTreeDataHandler>()
                            //     .updateNotificationTokenInTree(
                            //   currentReferralId:
                            //       _userDataProvider.platformData!.referralCode,
                            //   communityName:
                            //       _userDataProvider.platformData!.community,
                            //   newToken: value,
                            // );
                            locator<ProfileDataHandler>().updateProfileData(
                              data: NotificationToken(notificationToken: value)
                                  .toJson(),
                              typeOfDocument:
                                  ProfileDocument.userNotificationToken,
                              userId:
                                  _userDataProvider.platformData!.referralCode,
                              toLocalDatabase: false,
                            );
                            locator<ProfileDataHandler>().updateProfileData(
                              data: NotificationToken(notificationToken: value)
                                  .toJson(),
                              typeOfDocument:
                                  ProfileDocument.userNotificationToken,
                              userId:
                                  _userDataProvider.platformData!.referralCode,
                              toLocalDatabase: true,
                            );
                            _userDataProvider.token =
                                NotificationToken(notificationToken: value);
                            log.v("Update Notification token in tree");
                          }
                        });
                        isCM =
                            _userDataProvider.platformData!.isCommunityManager;
                        _userDataProvider.loadData(
                          referralCode: referralCode,
                          typeOfDocument: ProfileDocument.userPlatformRatings,
                        );
                        if (_userDataProvider
                                .transactionData!.transactionIds.length !=
                            0) {
                          _transactionsDataProvider.loadData(
                            transactionIds: _userDataProvider
                                .transactionData!.transactionIds,
                            activeTransactions: _userDataProvider
                                .transactionData!.activeTransactions,
                          );
                        }
                        setBusy(false);
                      }
                    });
                  }
                });
              }
            });
          }
        });
      } catch (e) {
        log.e("There was error here");
        _errorHandlingService.handleError(error: e);
      }
    });
  }

  void slideChangeViews(bool isReverse) {
    if (isReverse == false) {
      // ignore: unnecessary_statements
      currentIndex != 0 ? setIndex(currentIndex - 1) : null;
      notifyListeners();
    } else {
      // ignore: unnecessary_statements
      currentIndex != 3 ? setIndex(currentIndex + 1) : null;
      notifyListeners();
    }
  }

  void goToLoginScreen() {
    _authenticationService.auth.signOut();
    _navigationService.clearStackAndShow(Routes.loginView);
  }
}
