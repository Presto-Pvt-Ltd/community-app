import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/models/limits/reward_limit_model.dart';
import 'package:presto/models/notification/notification_data_model.dart';
import 'package:presto/models/transactions/borrower_data_model.dart';
import 'package:presto/models/transactions/custom_transaction_data_model.dart';
import 'package:presto/models/transactions/generic_data_model.dart';
import 'package:presto/models/transactions/lender_data_model.dart';
import 'package:presto/models/transactions/transaction_status_data_model.dart';
import 'package:presto/models/user/transaction_data_model.dart';
import 'package:presto/services/database/dataHandlers/limitsDataHandler.dart';
import 'package:presto/services/database/dataHandlers/profileDataHandler.dart';
import 'package:presto/services/database/dataHandlers/transactionsDataHandler.dart';
import 'package:presto/services/database/dataProviders/limits_data_provider.dart';
import 'package:presto/services/database/dataProviders/transactions_data_provider.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:presto/services/database/firestoreBase.dart';
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
    // TODO: make the razorpay function Future<bool> and the proceed with handshake
    await handshake(notification);
    // await locator<RazorpayService>().createOrderInServer(
    //   amount: notification.amount.toDouble(),
    // );
  }

  Future<void> handshake(CustomNotification notification) async {
    log.w("Executing handshake");

    /// Fetch transaction
    List<Future<Map<String, dynamic>>> futures =
        <Future<Map<String, dynamic>>>[];
    futures.addAll(TransactionDocument.values.map((typeOfDocument) {
      return locator<TransactionsDataHandler>().getTransactionData(
        typeOfDocument: typeOfDocument,
        transactionId: notification.transactionId,
        fromLocalStorage: false,
      );
    }).toList());
    Future.wait(futures).then((transactionFetched) {
      CustomTransaction newTransaction = CustomTransaction(
        genericInformation: GenericInformation.fromJson(transactionFetched[0]),
        lenderInformation: LenderInformation.fromJson(transactionFetched[1]),
        borrowerInformation:
            BorrowerInformation.fromJson(transactionFetched[2]),
        transactionStatus: TransactionStatus.fromJson(transactionFetched[3]),
      );

      /// add lender's info and update transaction status
      newTransaction.lenderInformation = LenderInformation(
        lenderReferralCode:
            locator<UserDataProvider>().platformData!.referralCode,
        lenderName: locator<UserDataProvider>().personalData!.name,
      );
      newTransaction.transactionStatus.approvedStatus = true;
      newTransaction.transactionStatus.lenderSentMoney = true;
      newTransaction.transactionStatus.lenderSentMoneyAt = DateTime.now();

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
        data: newTransaction.transactionStatus.toJson(),
        typeOfDocument: TransactionDocument.transactionStatus,
        transactionId: newTransaction.genericInformation.transactionId,
        toLocalStorage: false,
      );

      /// update lender's user info in firestore and hive
      locator<UserDataProvider>()
          .transactionData!
          .transactionIds
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
        if (locator<LimitsDataProvider>().rewardsLimit != null) {
          locator<UserDataProvider>().platformRatingsData!.prestoCoins +=
              locator<LimitsDataProvider>().rewardsLimit!.rewardPrestoCoins;
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
        } else {
          locator<LimitsDataHandler>()
              .getLimitsData(
            typeOfLimit: LimitDocument.rewardsLimits,
            fromLocalDatabase: false,
          )
              .then((value) {
            locator<LimitsDataProvider>().rewardsLimit =
                RewardsLimit.fromJson(value);
            locator<UserDataProvider>().platformRatingsData!.prestoCoins +=
                locator<LimitsDataProvider>().rewardsLimit!.rewardPrestoCoins;
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
        }
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
