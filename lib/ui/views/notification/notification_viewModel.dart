import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/models/enums.dart';
import 'package:presto/models/limits/reward_limit_model.dart';
import 'package:presto/models/notification/notification_data_model.dart';
import 'package:presto/models/transactions/custom_transaction_data_model.dart';
import 'package:presto/models/transactions/lender_data_model.dart';
import 'package:presto/models/user/transaction_data_model.dart';
import 'package:presto/services/database/dataHandlers/limitsDataHandler.dart';
import 'package:presto/services/database/dataHandlers/profileDataHandler.dart';
import 'package:presto/services/database/dataHandlers/transactionsDataHandler.dart';
import 'package:presto/services/database/dataProviders/limits_data_provider.dart';
import 'package:presto/services/database/dataProviders/transactions_data_provider.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:presto/services/database/firestoreBase.dart';
import 'package:presto/services/razorpay.dart';
import 'package:presto/ui/widgets/dialogBox.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NotificationViewModel extends BaseViewModel {
  final log = getLogger("NotificationViewModel");
  TextEditingController upiController = TextEditingController();
  var deleteNotificationCallBack;

  ///Paste your code here
  late final CustomNotification notification;
  void onModelReady(
      CustomNotification notification, var deleteNotificationCallBack) {
    this.notification = notification;
    this.deleteNotificationCallBack = deleteNotificationCallBack;
  }

  Future<void> initiateTransaction(List<PaymentMethods> paymentMethods) async {
    setBusy(true);
    var map = await locator<TransactionsDataHandler>().getTransactionData(
      transactionId: notification.transactionId,
      fromLocalStorage: false,
    );
    CustomTransaction transaction = CustomTransaction.fromJson(map);
    if (transaction.transactionStatus.lenderSentMoney) {
      setBusy(false);
      showCustomDialog(
        title: "Request Satisfied already",
        description: "Someone in you community have already lent money",
      );
      return;
    }

    await handshake(
      notification,
      razorpayTransactionId: transaction.genericInformation.transactionId,
      paymentMethods: paymentMethods,
      transaction: transaction,
    );
  }

  Future<void> handshake(
    CustomNotification notification, {
    required String razorpayTransactionId,
    required List<PaymentMethods> paymentMethods,
    required CustomTransaction transaction,
  }) async {
    log.w("Executing handshake");

    CustomTransaction currentTransaction =
        await locator<TransactionsDataHandler>()
            .getTransactionData(
              transactionId: transaction.genericInformation.transactionId,
              fromLocalStorage: false,
            )
            .then((value) => CustomTransaction.fromJson(value));
    if (currentTransaction.lenderInformation != null &&
        currentTransaction.razorpayInformation.lenderRazorpayPaymentId !=
            null) {
      RazorpayService _razorpay = RazorpayService(callback: () {});
      _razorpay.createRefundRequest(transactionId: razorpayTransactionId);
      showCustomDialog(
        title: "Sorry",
        description:
            "Someone has already serviced the request. Refund will be initiated. in case you dont recieve your refund within 2-4 business days please contact customer care..",
      );
      setBusy(false);
      return;
    }

    /// add lender's info and update transaction status
    transaction.lenderInformation = LenderInformation(
      contact: locator<UserDataProvider>().personalData!.contact.trim(),
      lenderReferralCode:
          locator<UserDataProvider>().platformData!.referralCode,
      lenderName: locator<UserDataProvider>().personalData!.name,
      paymentMethods: paymentMethods,
    );
    transaction.transactionStatus.approvedStatus = true;
    transaction.transactionStatus.lenderSentMoney = true;
    transaction.transactionStatus.lenderSentMoneyAt = DateTime.now();
    transaction.razorpayInformation.lenderRazorpayPaymentId =
        razorpayTransactionId;
    locator<UserDataProvider>().transactionData!.totalLent +=
        transaction.genericInformation.amount;

    /// Add transaction in provider
    locator<TransactionsDataProvider>().userTransactions == null
        ? locator<TransactionsDataProvider>().userTransactions = [transaction]
        : locator<TransactionsDataProvider>()
            .userTransactions!
            .add(transaction);

    /// update transaction in firestore
    paymentMethods.forEach((method) {
      if (locator<UserDataProvider>()
              .transactionData!
              .paymentMethodsUsed[PaymentMethodsMap[method]] ==
          null) {
        locator<UserDataProvider>()
            .transactionData!
            .paymentMethodsUsed[PaymentMethodsMap[method]!] = 1;
      } else
        locator<UserDataProvider>()
            .transactionData!
            .paymentMethodsUsed[PaymentMethodsMap[method]!] += 1;
    });
    locator<TransactionsDataHandler>().updateTransaction(
      data: {
        "transactionStatus": transaction.transactionStatus.toJson(),
        "lenderInformation": transaction.lenderInformation!.toJson(),
        "razorpayInformation": transaction.razorpayInformation.toJson(),
      },
      transactionId: transaction.genericInformation.transactionId,
      toLocalStorage: false,
    );

    /// update custom transaction list in hive
    locator<TransactionsDataHandler>().updateTransactionListInHive(
      locator<TransactionsDataProvider>().userTransactions!,
    );

    /// update lender's user info in firestore and hive
    locator<UserDataProvider>()
        .transactionData!
        .transactionIds
        .add(transaction.genericInformation.transactionId);
    locator<UserDataProvider>()
        .transactionData!
        .activeTransactions
        .add(transaction.genericInformation.transactionId);
    locator<ProfileDataHandler>().updateProfileData(
      data: locator<UserDataProvider>().transactionData!.toJson(),
      typeOfDocument: ProfileDocument.userTransactionsData,
      userId: locator<UserDataProvider>().platformData!.referralCode,
      toLocalDatabase: true,
    );
    locator<ProfileDataHandler>().updateProfileData(
      data: locator<UserDataProvider>().transactionData!.toJson(),
      typeOfDocument: ProfileDocument.userTransactionsData,
      userId: locator<UserDataProvider>().platformData!.referralCode,
      toLocalDatabase: false,
    );

    /// update borrower's data on firestore
    locator<ProfileDataHandler>()
        .getProfileData(
      typeOfData: ProfileDocument.userTransactionsData,
      userId: transaction.borrowerInformation.borrowerReferralCode,
      fromLocalDatabase: false,
    )
        .then((value) {
      TransactionData transactionData = TransactionData.fromJson(value);
      transactionData.activeTransactions
          .add(transaction.genericInformation.transactionId);
      transactionData.totalBorrowed += transaction.genericInformation.amount;
      transactionData.borrowingRequestInProcess = false;
      locator<ProfileDataHandler>().updateProfileData(
        data: transactionData.toJson(),
        typeOfDocument: ProfileDocument.userTransactionsData,
        userId: transaction.borrowerInformation.borrowerReferralCode,
        toLocalDatabase: false,
      );

      /// Reward lender
      locator<LimitsDataHandler>()
          .getLimitsData(
        typeOfLimit: LimitDocument.rewardsLimits,
        fromLocalDatabase: false,
      )
          .then((value) {
        locator<LimitsDataProvider>().rewardsLimit =
            RewardsLimit.fromJson(value);
        locator<UserDataProvider>().platformRatingsData!.prestoCoins +=
            (locator<LimitsDataProvider>()
                        .rewardsLimit!
                        .rewardPrestoCoinsPercent *
                    (transaction.genericInformation.amount / 100))
                .ceil();
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
      });

      FirestoreService().deleteData(
        document: FirebaseFirestore.instance
            .collection("notifications")
            .doc(transaction.borrowerInformation.borrowerReferralCode),
      );
      setBusy(false);
      locator<NavigationService>().back();
      showCustomDialog(
        title: "Success",
        description:
            "Payment is successful! You have been awarded Presto Coins for successful Payment",
      );
      log.w("handshake finished");
      if (deleteNotificationCallBack != null)
        deleteNotificationCallBack(notification.transactionId);
    });
  }

  void cancel() {}
}
