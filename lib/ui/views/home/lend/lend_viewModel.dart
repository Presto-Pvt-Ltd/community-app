import 'dart:convert';

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
import 'package:presto/services/authentication.dart';
import 'package:presto/services/database/dataHandlers/limitsDataHandler.dart';
import 'package:presto/services/database/dataHandlers/notificationDataHandler.dart';
import 'package:presto/services/database/dataHandlers/profileDataHandler.dart';
import 'package:presto/services/database/dataHandlers/transactionsDataHandler.dart';
import 'package:presto/services/database/dataProviders/limits_data_provider.dart';
import 'package:presto/services/database/dataProviders/transactions_data_provider.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:presto/services/database/firestoreBase.dart';
import 'package:presto/services/razorpay.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LendViewModel extends StreamViewModel {
  final log = getLogger("LendViewModel");
  final NotificationDataHandler _notificationDataHandler =
      locator<NotificationDataHandler>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  List<CustomNotification> notifications = <CustomNotification>[];
  final NavigationService navigationService = locator<NavigationService>();
  String title = "I am Lend Screen";
  late void Function(bool) callback;

  void onModelReady(void Function(bool) callback) {
    this.callback = callback;
  }

  @override
  void onData(data) {
    if (data is QuerySnapshot) {
      if (data.docs.isNotEmpty) {
        data.docs.forEach((particularDoc) {
          log.v("Notification :");
          DateTime currentTime = DateTime.now();
          log.v(particularDoc.data().toString());
          log.v("Current time: $currentTime");
          CustomNotification notification =
              CustomNotification.fromJson(particularDoc.data());
          log.v(notification.initiationTime);
          int limitMinutes = locator<LimitsDataProvider>()
                  .transactionLimits!
                  .keepTransactionActiveForHours *
              60;
          if (currentTime.difference(notification.initiationTime).inMinutes <
              limitMinutes) {
            log.d("Actual Notification");
            notifications
                .add(CustomNotification.fromJson(particularDoc.data()));
          }
        });
        notifyListeners();
      }
    }
    super.onData(data);
  }

  Future<void> initiateTransaction(CustomNotification notification) async {
    setBusy(true);
    // await locator<RazorpayService>().createOrderInServer(
    //   amount: notification.amount.toDouble(),
    // );
    await handshake(notification);
  }

  Future<void> handshake(CustomNotification notification) async {
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
        data: {
          "transactionStatus": newTransaction.transactionStatus.toJson(),
          "lenderInformation": newTransaction.lenderInformation!.toJson(),
        },
        transactionId: newTransaction.genericInformation.transactionId,
        toLocalStorage: false,
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
        log.w("handshake finished");
        FirestoreService().deleteData(
          document: FirebaseFirestore.instance
              .collection("notifications")
              .doc(newTransaction.borrowerInformation.borrowerReferralCode),
        );
        locator<DialogService>().showDialog(
          title: "Success",
          description: "Payback Successful!!",
        );
        setBusy(false);
      });
    });
  }

  @override
  Stream<QuerySnapshot> get stream => _notificationDataHandler.getStream();
}
