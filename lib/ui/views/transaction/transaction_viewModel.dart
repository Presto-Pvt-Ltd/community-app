import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
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
import 'package:presto/services/razorpay.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/widgets/dialogBox.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TransactionViewModel extends BaseViewModel {
  final log = getLogger("TransactionViewModel");
  late final bool isBorrowed;
  late bool isTransactionIncomplete;
  late String buttonText;
  late String transactionStatus;
  late Color buttonColor;
  late final CustomTransaction transaction;
  late String lenderOrBorrower;
  late String lenderOrBorrowerName;
  late Color textColor;
  void pop() {
    locator<NavigationService>().back();
  }

  void onModelReady(CustomTransaction transaction) {
    this.transaction = transaction;
    this.isBorrowed = transaction.borrowerInformation.borrowerReferralCode ==
        locator<UserDataProvider>().platformData!.referralCode;
    this.isTransactionIncomplete =
        transaction.razorpayInformation.sentMoneyToBorrower &&
            transaction.razorpayInformation.sentMoneyToLender;
    this.buttonColor = primaryLightColor.withOpacity(0.4);
    this.buttonText = "In Process";
    this.transactionStatus = "Searching for Lenders";
    int hours = locator<LimitsDataProvider>()
        .transactionLimits!
        .keepTransactionActiveForHours;
    int minutes = locator<LimitsDataProvider>()
        .transactionLimits!
        .keepTransactionActiveForMinutes;
    int minutesPassed = DateTime.now()
        .difference(transaction.genericInformation.initiationAt)
        .inMinutes;
    textColor = primaryLightColor;
    if (this.isBorrowed) {
      lenderOrBorrower = transaction.lenderInformation!.lenderName == null
          ? "Searching for lenders"
          : "Lender";
      lenderOrBorrowerName = transaction.lenderInformation!.lenderName ?? "";
      log.v("Borrowed");
      if (transaction.lenderInformation!.lenderName == null) {
        this.textColor = Colors.orangeAccent;
      }
      if (minutesPassed >= (minutes + (hours * 60))) {
        if (!transaction.transactionStatus.lenderSentMoney) {
          log.v("Failed");
          this.buttonText = "No Lenders Found";
          this.transactionStatus = "Failed";
          this.textColor = Colors.red;
          return;
        }
      }
      if (!transaction.razorpayInformation.sentMoneyToBorrower &&
          transaction.transactionStatus.lenderSentMoney) {
        log.v("In Process");
        this.transactionStatus = "Processing money";
      } else if (transaction.lenderInformation == null ||
          transaction.lenderInformation!.lenderName == null) {
        this.transactionStatus = "Pending";
      } else if (transaction.razorpayInformation.sentMoneyToBorrower &&
          !transaction.transactionStatus.borrowerSentMoney) {
        log.v("Pay Back");
        this.transactionStatus = "Your turn to pay back";
        this.buttonText = "Pay Back";
        this.buttonColor = primaryLightColor;
      } else if (transaction.transactionStatus.borrowerSentMoney &&
          !transaction.razorpayInformation.sentMoneyToLender) {
        log.v("In Process");
        this.transactionStatus = "Processing money";
      } else {
        log.v("Success");
        this.transactionStatus = "Success";
        this.buttonText = "Paid Back";
        this.textColor = neonGreen;
      }
    } else {
      lenderOrBorrower = "Borrower";
      lenderOrBorrowerName = transaction.borrowerInformation.borrowerName;
      if (transaction.transactionStatus.lenderSentMoney &&
          !transaction.razorpayInformation.sentMoneyToBorrower) {
        this.transactionStatus = "Processing money";
        this.buttonText = "In Process";
      } else if (transaction.razorpayInformation.sentMoneyToLender) {
        this.buttonText = "Transaction Complete";
        this.transactionStatus = "Success";
        this.textColor = neonGreen;
      } else if (transaction.transactionStatus.borrowerSentMoney &&
          !transaction.razorpayInformation.sentMoneyToLender) {
        this.transactionStatus = "Processing money";
      } else {
        this.buttonText = "Wait for Pay Back";
        this.transactionStatus = "Wait for Pay Back";
      }
    }
  }

  Future<void> initiateTransaction() async {
    print("Hello");
    setBusy(true);
    RazorpayService _razorpayService =
        RazorpayService(callback: (String paymentId) async {
      await payBackComplete(
        transaction,
        borrowerRazorpayPaymentId: paymentId,
      );
    });
    await _razorpayService.createOrderInServer(
      amount: transaction.genericInformation.amount.toDouble(),
      transactionId: transaction.genericInformation.transactionId,
    );
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
              showCustomDialog(
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
            showCustomDialog(
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
