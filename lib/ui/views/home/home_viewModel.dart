import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/models/limits/reward_limit_model.dart';
import 'package:presto/models/limits/transaction_limit_model.dart';
import 'package:presto/models/user/notification_data_model.dart';
import 'package:presto/models/user/platform_data_model.dart';
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

  void goToMyReferees() async {
    setBusy(true);
    var value = await locator<ProfileDataHandler>().getProfileData(
      typeOfData: ProfileDocument.userPlatformData,
      userId: locator<UserDataProvider>().platformData!.referralCode,
      fromLocalDatabase: false,
    );
    PlatformData platformData = PlatformData.fromJson(value);
    locator<UserDataProvider>().platformData = platformData;
    locator<ProfileDataHandler>().updateProfileData(
      data: platformData.toJson(),
      typeOfDocument: ProfileDocument.userPlatformData,
      userId: locator<UserDataProvider>().platformData!.referralCode,
      toLocalDatabase: true,
    );
    locator<UserDataProvider>().platformData = platformData;
    locator<NavigationService>().navigateTo(Routes.refereesView);
    setBusy(false);
  }

  void goToContactUs() {
    locator<NavigationService>().navigateTo(Routes.contactUsView);
  }

  void goToHelp() {
    locator<NavigationService>().navigateTo(Routes.introductionView,
        arguments: IntroductionViewArguments(
          isFromDrawer: true,
        ));
  }

  void goToProfileDetails() {
    locator<NavigationService>().navigateTo(Routes.profileDetailsView);
  }

  Future<void> refresh() async {
    locator<UserDataProvider>().dispose();
    locator<TransactionsDataProvider>().dispose();

    if (currentIndex != 2)
      onModelReady(currentIndex);
    else
      onModelReady(1);
  }

  Future<void> onModelReady(
    int index,
  ) async {
    setBusy(true);
    await locator<HiveDatabaseService>()
        .openBox(uid: locator<AuthenticationService>().uid!)
        .then((value) async {
      /// Getting initial data:
      setIndex(index);
      try {
        referralCode = _authenticationService.referralCode!;

        /// Trying to load data
        await locator<LimitsDataHandler>()
            .getLimitsData(
          typeOfLimit: LimitDocument.rewardsLimits,
          fromLocalDatabase: false,
        )
            .then((rewardsLimitsData) async {
          log.v("Rewards Limits Data:" + rewardsLimitsData.toString());
          locator<LimitsDataProvider>().rewardsLimit =
              RewardsLimit.fromJson(rewardsLimitsData);
          locator<LimitsDataHandler>()
              .getLimitsData(
            typeOfLimit: LimitDocument.transactionLimits,
            fromLocalDatabase: false,
          )
              .then((transactionLimits) async {
            log.v("Transaction Limits Data:" + transactionLimits.toString());
            locator<LimitsDataProvider>().transactionLimits =
                TransactionLimits.fromJson(transactionLimits);
            final gotUserPersonalData = await _userDataProvider.loadData(
              referralCode: referralCode,
              typeOfDocument: ProfileDocument.userPersonalData,
            );
            log.v("gotUserPersonalData:" + gotUserPersonalData.toString());

            if (gotUserPersonalData) {
              final gotUserNotification = await _userDataProvider.loadData(
                referralCode: referralCode,
                typeOfDocument: ProfileDocument.userNotificationToken,
              );
              log.v("gotUserNotification:" + gotUserNotification.toString());
              if (gotUserNotification) {
                final gotTransactionData = await _userDataProvider.loadData(
                  referralCode: referralCode,
                  typeOfDocument: ProfileDocument.userTransactionsData,
                );
                log.v("gotTransactionData:" + gotTransactionData.toString());

                if (gotTransactionData) {
                  final gotPlatformData = await _userDataProvider.loadData(
                    referralCode: referralCode,
                    typeOfDocument: ProfileDocument.userPlatformData,
                  );
                  log.v("gotPlatformData:" + gotPlatformData.toString());
                  if (gotPlatformData) {
                    FirebaseMessaging.instance.getToken().then((value) async {
                      if (value != _userDataProvider.token!.notificationToken &&
                          value != null) {
                        await locator<CommunityTreeDataHandler>()
                            .updateNotificationTokenInTree(
                          parentReferralId:
                              _userDataProvider.platformData!.referredBy,
                          currentReferralId:
                              _userDataProvider.platformData!.referralCode,
                          communityName:
                              _userDataProvider.platformData!.community,
                          newToken: value,
                        )
                            .then((value) async {
                          await locator<CommunityTreeDataHandler>()
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
                        await locator<ProfileDataHandler>().updateProfileData(
                          data: NotificationToken(notificationToken: value)
                              .toJson(),
                          typeOfDocument: ProfileDocument.userNotificationToken,
                          userId: _userDataProvider.platformData!.referralCode,
                          toLocalDatabase: false,
                        );
                        await locator<ProfileDataHandler>().updateProfileData(
                          data: NotificationToken(notificationToken: value)
                              .toJson(),
                          typeOfDocument: ProfileDocument.userNotificationToken,
                          userId: _userDataProvider.platformData!.referralCode,
                          toLocalDatabase: true,
                        );
                        _userDataProvider.token =
                            NotificationToken(notificationToken: value);
                        log.v("Update Notification token everywhere done");
                      } else {
                        await locator<CommunityTreeDataHandler>()
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
                      }
                    });
                    isCM = _userDataProvider.platformData!.isCommunityManager;
                    await _userDataProvider.loadData(
                      referralCode: referralCode,
                      typeOfDocument: ProfileDocument.userPlatformRatings,
                      dataIsLive: true,
                    );
                    if (_userDataProvider
                            .transactionData!.transactionIds.length !=
                        0) {
                      _transactionsDataProvider.loadData(
                        transactionIds:
                            _userDataProvider.transactionData!.transactionIds,
                        activeTransactions: _userDataProvider
                            .transactionData!.activeTransactions,
                      );
                    }
                    setBusy(false);
                  }
                }
              }
            }
          });
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
