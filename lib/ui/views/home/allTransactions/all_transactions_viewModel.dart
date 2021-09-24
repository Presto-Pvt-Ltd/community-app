import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/models/transactions/custom_transaction_data_model.dart';
import 'package:presto/models/user/platform_data_model.dart';
import 'package:presto/models/user/platform_ratings_data.dart';
import 'package:presto/services/database/dataHandlers/profileDataHandler.dart';
import 'package:presto/services/database/dataHandlers/transactionsDataHandler.dart';
import 'package:presto/services/database/dataProviders/limits_data_provider.dart';
import 'package:presto/services/database/dataProviders/transactions_data_provider.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:presto/ui/widgets/dialogBox.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../app/app.locator.dart';

class AllTransactionsViewModel extends BaseViewModel {
  final log = getLogger("TransactionsViewModel");
  final NavigationService navigationService = locator<NavigationService>();
  List<CustomTransaction> transactions =
      locator<TransactionsDataProvider>().userTransactions ??
          <CustomTransaction>[];
  List<CustomTransaction> activeTransactions = <CustomTransaction>[];
  late void Function(bool) callback;
  double amountBorrowed = 0.0;
  double amountLent = 0.0;

  bool gotData = false;
  void onModelReady(void Function(bool) callback) {
    setBusy(true);
    DateTime currentTime = DateTime.now();
    this.callback = callback;
    List<String> active =
        locator<UserDataProvider>().transactionData!.activeTransactions;
    int i = -1;
    if (active.length > 0)
      transactions.forEach((transaction) {
        log.wtf(jsonEncode(transaction));
        i++;
        if (transaction.transactionStatus.approvedStatus) {
          if (transaction.transactionStatus.lenderSentMoney &&
              !transaction.transactionStatus.borrowerSentMoney) {
            if (transaction.borrowerInformation.borrowerReferralCode ==
                locator<UserDataProvider>().platformData!.referralCode)
              amountBorrowed += transaction.genericInformation.amount;
            else
              amountLent += transaction.genericInformation.amount;
          }
        }

        /// Check if borrower have not sent money
        /// Borrower has not opted for emi
        /// Borrower is not penalised
        /// Lender has sent money
        if (!transaction.transactionStatus.borrowerSentMoney &&
            transaction.borrowerInformation.fullPayment &&
            transaction.transactionStatus.lenderSentMoney &&
            !transaction.transactionStatus.isBorrowerPenalised) {
          DateTime initiationTime = transaction.genericInformation.initiationAt;
          int differenceInHours =
              currentTime.difference(initiationTime).inHours;

          /// if hours exceeded limit hours
          if (differenceInHours >
              (locator<LimitsDataProvider>()
                      .transactionLimits!
                      .transactionDefaultsAfterDays *
                  24)) {
            /// Check if user is borrower himself
            if (locator<UserDataProvider>().platformData!.referralCode ==
                transaction.borrowerInformation.borrowerReferralCode) {
              double penaliseBy = locator<LimitsDataProvider>()
                  .rewardsLimit!
                  .penaliseCreditScore;
              locator<UserDataProvider>().platformRatingsData!.personalScore -=
                  penaliseBy;

              /// Check if personal score is negative,
              /// and disable if it is.
              if (locator<UserDataProvider>()
                      .platformRatingsData!
                      .personalScore <
                  0) {
                locator<UserDataProvider>().platformRatingsData!.personalScore =
                    0.0;
                locator<UserDataProvider>().platformData!.disabled = true;
                locator<ProfileDataHandler>().updateProfileData(
                  data: locator<UserDataProvider>().platformData!.toJson(),
                  typeOfDocument: ProfileDocument.userPlatformData,
                  userId:
                      locator<UserDataProvider>().platformData!.referralCode,
                  toLocalDatabase: false,
                );
                locator<ProfileDataHandler>().updateProfileData(
                  data: locator<UserDataProvider>().platformData!.toJson(),
                  typeOfDocument: ProfileDocument.userPlatformData,
                  userId:
                      locator<UserDataProvider>().platformData!.referralCode,
                  toLocalDatabase: true,
                );
                log.w("User Disabled");
                showCustomDialog(
                  title: "Have some dignity",
                  description:
                      "You have not completed your previous transaction within time limit. You have been disabled from this platform. Pay previous balances and contact Presto for more information.",
                );
              }
              locator<ProfileDataHandler>().updateProfileData(
                data: locator<UserDataProvider>().platformRatingsData!.toJson(),
                typeOfDocument: ProfileDocument.userPlatformRatings,
                userId: locator<UserDataProvider>().platformData!.referralCode,
                toLocalDatabase: false,
              );
              locator<ProfileDataHandler>().updateProfileData(
                data: locator<UserDataProvider>().platformRatingsData!.toJson(),
                typeOfDocument: ProfileDocument.userPlatformRatings,
                userId: locator<UserDataProvider>().platformData!.referralCode,
                toLocalDatabase: true,
              );

              /// Update transaction status to borrower penalised
              transactions[i].transactionStatus.isBorrowerPenalised = true;
              locator<TransactionsDataHandler>().updateTransaction(
                data: {"transactionStatus": transactions[i].transactionStatus},
                transactionId: transaction.genericInformation.transactionId,
                toLocalStorage: false,
              );
              locator<TransactionsDataHandler>()
                  .updateTransactionListInHive(transactions);

              /// 1) updateCommunityScores
              /// 2) updateCommunityScoresWithoutAsync
              /// argument: jsonEncode({ "isReward" : false, "changeInChild" : penaliseBy,  "parentId" :locator<UserDataProvider>().platformData!.referredBy})

              FirebaseFunctions functions = FirebaseFunctions.instance;
              Function updateCommunityScores =
                  functions.httpsCallable('updateCommunityScores');
              log.v(
                "Updating Community scores \n ${jsonEncode({
                      "isReward": false,
                      "changeInChild": penaliseBy,
                      "parentId":
                          locator<UserDataProvider>().platformData!.referredBy
                    })}",
              );
              updateCommunityScores(
                jsonEncode({
                  "isReward": false,
                  "changeInChild": penaliseBy,
                  "parentId":
                      locator<UserDataProvider>().platformData!.referredBy
                }),
              );
              setBusy(false);
            }

            /// If user is Lender
            else {
              double penaliseBy = locator<LimitsDataProvider>()
                  .rewardsLimit!
                  .penaliseCreditScore;
              locator<ProfileDataHandler>()
                  .getProfileData(
                typeOfData: ProfileDocument.userPlatformRatings,
                userId: transaction.borrowerInformation.borrowerReferralCode,
                fromLocalDatabase: false,
              )
                  .then((borrowerData) {
                PlatformRatings borrowerRatings =
                    PlatformRatings.fromJson(borrowerData);
                borrowerRatings.personalScore -= penaliseBy;
                if (borrowerRatings.personalScore < 0) {
                  borrowerRatings.personalScore = 0.0;
                  locator<ProfileDataHandler>()
                      .getProfileData(
                    typeOfData: ProfileDocument.userPlatformData,
                    userId:
                        locator<UserDataProvider>().platformData!.referralCode,
                    fromLocalDatabase: false,
                  )
                      .then((value) {
                    PlatformData borrowerPlatformData =
                        PlatformData.fromJson(value);
                    borrowerPlatformData.disabled = true;

                    /// Update borrower platform data
                    locator<ProfileDataHandler>().updateProfileData(
                      data: borrowerPlatformData.toJson(),
                      typeOfDocument: ProfileDocument.userPlatformData,
                      userId:
                          transaction.borrowerInformation.borrowerReferralCode,
                      toLocalDatabase: false,
                    );
                    log.w("User Disabled");
                  });
                }

                /// Update borrower ratings
                locator<ProfileDataHandler>().updateProfileData(
                  data: borrowerRatings.toJson(),
                  typeOfDocument: ProfileDocument.userPlatformRatings,
                  userId: transaction.borrowerInformation.borrowerReferralCode,
                  toLocalDatabase: false,
                );
                setBusy(false);
              });

              /// Update transaction status to borrower penalised
              transactions[i].transactionStatus.isBorrowerPenalised = true;
              locator<TransactionsDataHandler>().updateTransaction(
                data: {"transactionStatus": transactions[i].transactionStatus},
                transactionId: transaction.genericInformation.transactionId,
                toLocalStorage: false,
              );
              locator<TransactionsDataHandler>()
                  .updateTransactionListInHive(transactions);

              /// 1) updateCommunityScores
              /// 2) updateCommunityScoresWithoutAsync
              /// argument: jsonEncode({ "isReward" : false, "changeInChild" : penaliseBy,  "parentId" :locator<UserDataProvider>().platformData!.referredBy})

              FirebaseFunctions functions = FirebaseFunctions.instance;
              Function updateCommunityScores =
                  functions.httpsCallable('updateCommunityScores');
              log.v(
                "Updating Community scores \n ${jsonEncode({
                      "isReward": false,
                      "changeInChild": penaliseBy,
                      "parentId":
                          locator<UserDataProvider>().platformData!.referredBy
                    })}",
              );
              updateCommunityScores(
                jsonEncode({
                  "isReward": false,
                  "changeInChild": penaliseBy,
                  "parentId":
                      locator<UserDataProvider>().platformData!.referredBy
                }),
              );
              setBusy(false);
              showCustomDialog(
                title: "Default",
                description:
                    "Rest assured! Transaction with borrower: ${transaction.borrowerInformation.borrowerName} have exceeded time limit. The borrower has been penalised and you will be re-compensated",
              );
            }
          }

          /// Else Remind user of active transaction
          else {
            DateTime initiationTime =
                transaction.genericInformation.initiationAt;
            int differenceInHoursFromInitiation =
                currentTime.difference(initiationTime).inHours;
            differenceInHours = locator<LimitsDataProvider>()
                        .transactionLimits!
                        .transactionDefaultsAfterDays *
                    24 -
                differenceInHoursFromInitiation;
            if (transaction.borrowerInformation.borrowerReferralCode ==
                locator<UserDataProvider>().platformData!.referralCode) {
              showCustomDialog(
                title: "Gentle Reminder",
                description:
                    "You have borrowed money from lender: ${transaction.lenderInformation!.lenderName}. You still have ${(differenceInHours / 24).floor()} days ${differenceInHours % 24} hours to payback.",
              );
            }
            setBusy(false);
          }
        }
        if (active.contains(transaction.genericInformation.transactionId)) {
          activeTransactions.add(transaction);
          notifyListeners();
          setBusy(false);
        }
      });

    setBusy(false);
  }
}
