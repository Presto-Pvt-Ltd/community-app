import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/models/limits/reward_limit_model.dart';
import 'package:presto/models/transactions/custom_transaction_data_model.dart';
import 'package:presto/models/user/transaction_data_model.dart';
import 'package:presto/services/database/dataHandlers/limitsDataHandler.dart';
import 'package:presto/services/database/dataHandlers/profileDataHandler.dart';
import 'package:presto/services/database/dataHandlers/transactionsDataHandler.dart';
import 'package:presto/services/database/dataProviders/limits_data_provider.dart';
import 'package:presto/services/database/dataProviders/transactions_data_provider.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TransactionViewModel extends BaseViewModel {
  final log = getLogger("TransactionViewModel");

  late final CustomTransaction transaction;
  void onModelReady(CustomTransaction transaction) {
    this.transaction = transaction;
  }

  Future<void> initiateTransaction() async {
    setBusy(true);
    // TODO: make the razorpay function Future<bool> and the proceed with handshake
    await payBackComplete(
      transaction,
      borrowerRazorpayPaymentId: "the",
    );
    // await locator<RazorpayService>().createOrderInServer(
    //   amount: notification.amount.toDouble(),
    // );
  }

  Future<void> payBackComplete(
    CustomTransaction transaction, {
    required String borrowerRazorpayPaymentId,
  }) async {
    var userTransactionsFromProvider =
        locator<TransactionsDataProvider>().userTransactions!;
    log.w("Executing payBackComplete ");
    log.w(locator<UserDataProvider>().transactionData!.activeTransactions);

    /// update user profile
    locator<UserDataProvider>()
        .transactionData!
        .activeTransactions
        .remove(transaction.genericInformation.transactionId);
    log.w(locator<UserDataProvider>().transactionData!.activeTransactions);
    // TODO: add reward
    for (int i = 0; i < userTransactionsFromProvider.length; i++) {
      if (userTransactionsFromProvider[i].genericInformation.transactionId ==
          transaction.genericInformation.transactionId) {
        /// update the transaction here
        userTransactionsFromProvider[i].transactionStatus.borrowerSentMoney =
            true;
        DateTime current = DateTime.now();
        userTransactionsFromProvider[i].transactionStatus.borrowerSentMoneyAt =
            current;
        userTransactionsFromProvider[i]
            .razorpayInformation
            .borrowerRazorpayPaymentId = borrowerRazorpayPaymentId;

        /// update transaction in firestore
        locator<TransactionsDataHandler>().updateTransaction(
          data: {
            "transactionStatus":
                userTransactionsFromProvider[i].transactionStatus.toJson(),
            "razorpayInformation":
                userTransactionsFromProvider[i].razorpayInformation.toJson(),
          },
          transactionId: transaction.genericInformation.transactionId,
          toLocalStorage: false,
        );

        /// update borrower's user info in firestore and hive
        locator<ProfileDataHandler>().updateProfileData(
          data: locator<UserDataProvider>().transactionData!.toJson(),
          typeOfDocument: ProfileDocument.userTransactionsData,
          userId: locator<UserDataProvider>().platformData!.referralCode,
          toLocalDatabase: true,
        );

        locator<ProfileDataHandler>()
            .updateProfileData(
          data: locator<UserDataProvider>().transactionData!.toJson(),
          typeOfDocument: ProfileDocument.userTransactionsData,
          userId: locator<UserDataProvider>().platformData!.referralCode,
          toLocalDatabase: false,
        )
            .then((value) {
          locator<ProfileDataHandler>()
              .getProfileData(
            typeOfData: ProfileDocument.userTransactionsData,
            userId: transaction.lenderInformation!.lenderReferralCode!,
            fromLocalDatabase: false,
          )
              .then((value) {
            TransactionData data = TransactionData.fromJson(value);
            data.activeTransactions
                .remove(transaction.genericInformation.transactionId);
            locator<ProfileDataHandler>().updateProfileData(
              data: locator<UserDataProvider>().transactionData!.toJson(),
              typeOfDocument: ProfileDocument.userTransactionsData,
              userId: transaction.lenderInformation!.lenderReferralCode!,
              toLocalDatabase: false,
            );
          });
          if (locator<UserDataProvider>().platformRatingsData!.personalScore <
              5) {
            /// Reward borrower
            locator<LimitsDataHandler>()
                .getLimitsData(
              typeOfLimit: LimitDocument.rewardsLimits,
              fromLocalDatabase: false,
            )
                .then((value) {
              locator<LimitsDataProvider>().rewardsLimit =
                  RewardsLimit.fromJson(value);
              locator<UserDataProvider>().platformRatingsData!.personalScore +=
                  locator<LimitsDataProvider>().rewardsLimit!.rewardCreditScore;
              if (locator<UserDataProvider>()
                      .platformRatingsData!
                      .personalScore >
                  5) {
                locator<UserDataProvider>().platformRatingsData!.personalScore =
                    5;
              }
              locator<ProfileDataHandler>().updateProfileData(
                data: locator<UserDataProvider>().platformRatingsData!.toJson(),
                typeOfDocument: ProfileDocument.userPlatformRatings,
                userId: locator<UserDataProvider>().platformData!.referralCode,
                toLocalDatabase: true,
              );
              locator<ProfileDataHandler>().updateProfileData(
                data: locator<UserDataProvider>().platformRatingsData!.toJson(),
                typeOfDocument: ProfileDocument.userPlatformRatings,
                userId: locator<UserDataProvider>().platformData!.referralCode,
                toLocalDatabase: false,
              );
              setBusy(false);
              locator<NavigationService>().back();
              locator<DialogService>().showDialog(
                title: "Success",
                description: "Payback Successful!!",
              );
              log.w("Borrower paid back");
            });

            /// 1) updateCommunityScores
            /// 2) updateCommunityScoresWithoutAsync
            /// argument: jsonEncode({ "isReward" : true, "changeInChild" : locator<LimitsDataProvider>().rewardsLimit!.rewardCreditScore,  "parentId" :locator<UserDataProvider>().platformData!.referredBy})

            FirebaseFunctions functions = FirebaseFunctions.instance;
            Function updateCommunityScores =
                functions.httpsCallable('updateCommunityScores');
            log.v("Updating Community scores");
            updateCommunityScores(
              jsonEncode({
                "isReward": true,
                "changeInChild": locator<LimitsDataProvider>()
                    .rewardsLimit!
                    .rewardCreditScore,
                "parentId": locator<UserDataProvider>().platformData!.referredBy
              }),
            );
          } else {
            log.v("Didn't update personal score");
            setBusy(false);
            locator<NavigationService>().back();
            locator<DialogService>().showDialog(
              title: "Success",
              description: "Payback Successful!!",
            );
          }
        });
        break;
      }
    }
  }
}
