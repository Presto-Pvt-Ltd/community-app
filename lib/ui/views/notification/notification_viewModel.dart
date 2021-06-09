import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NotificationViewModel extends BaseViewModel {
  final log = getLogger("NotificationViewModel");

  ///Paste your code here
  late final CustomNotification notification;
  void onModelReady(CustomNotification notification) {
    this.notification = notification;
  }

  Future<void> initiateTransaction() async {
    setBusy(true);
    RazorpayService _razorpayService =
        RazorpayService(callback: (String paymentId) async {
      await handshake(
        notification,
        razorpayTransactionId: paymentId,
      );
    });
    await _razorpayService.createOrderInServer(
      amount: notification.amount.toDouble(),
      transactionId: notification.transactionId,
    );
  }

  Future<void> handshake(
    CustomNotification notification, {
    required String razorpayTransactionId,
  }) async {
    log.w("Executing handshake");

    /// Fetch transaction
    List<Future<Map<String, dynamic>>> futures =
        <Future<Map<String, dynamic>>>[];
    futures.add(locator<TransactionsDataHandler>().getTransactionData(
      transactionId: notification.transactionId,
      fromLocalStorage: false,
    ));
    Future.wait(futures).then((transactionFetched) {
      CustomTransaction newTransaction =
          CustomTransaction.fromJson(transactionFetched[0]);

      /// add lender's info and update transaction status
      newTransaction.lenderInformation = LenderInformation(
        // TODO:  add the list fetched from bottom sheet
        upiId: "upi@a",
        lenderReferralCode:
            locator<UserDataProvider>().platformData!.referralCode,
        lenderName: locator<UserDataProvider>().personalData!.name,
      );
      newTransaction.transactionStatus.approvedStatus = true;
      newTransaction.transactionStatus.lenderSentMoney = true;
      newTransaction.transactionStatus.lenderSentMoneyAt = DateTime.now();
      newTransaction.razorpayInformation.lenderRazorpayPaymentId =
          razorpayTransactionId;

      /// Add transaction in provider
      locator<TransactionsDataProvider>().userTransactions == null
          ? locator<TransactionsDataProvider>().userTransactions = [
              newTransaction
            ]
          : locator<TransactionsDataProvider>()
              .userTransactions!
              .add(newTransaction);

      /// update transaction in firestore

      locator<TransactionsDataHandler>().updateTransaction(
        data: {
          "transactionStatus": newTransaction.transactionStatus.toJson(),
          "lenderInformation": newTransaction.lenderInformation!.toJson(),
          "razorpayInformation": newTransaction.razorpayInformation.toJson(),
        },
        transactionId: newTransaction.genericInformation.transactionId,
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
          .add(newTransaction.genericInformation.transactionId);
      locator<UserDataProvider>()
          .transactionData!
          .activeTransactions
          .add(newTransaction.genericInformation.transactionId);
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
        userId: newTransaction.borrowerInformation.borrowerReferralCode,
        fromLocalDatabase: false,
      )
          .then((value) {
        TransactionData transactionData = TransactionData.fromJson(value);
        transactionData.activeTransactions
            .add(newTransaction.genericInformation.transactionId);
        transactionData.borrowingRequestInProcess = false;
        locator<ProfileDataHandler>().updateProfileData(
          data: transactionData.toJson(),
          typeOfDocument: ProfileDocument.userTransactionsData,
          userId: newTransaction.borrowerInformation.borrowerReferralCode,
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
                      (newTransaction.genericInformation.amount / 100))
                  .toInt();
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
              .doc(newTransaction.borrowerInformation.borrowerReferralCode),
        );
        setBusy(false);
        locator<NavigationService>().back();
        locator<DialogService>().showDialog(
          title: "Success",
          description: "Lend Successful!!",
        );
        log.w("handshake finished");
      });
    });
  }
}
