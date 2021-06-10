import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:presto/app/app.locator.dart';
import 'package:flutter/material.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/models/enums.dart';
import 'package:presto/models/limits/transaction_limit_model.dart';
import 'package:presto/models/notification/notification_data_model.dart';
import 'package:presto/models/transactions/borrower_data_model.dart';
import 'package:presto/models/transactions/custom_transaction_data_model.dart';
import 'package:presto/models/transactions/generic_data_model.dart';
import 'package:presto/models/transactions/lender_data_model.dart';
import 'package:presto/models/transactions/razorpay_data_model.dart';
import 'package:presto/models/transactions/transaction_status_data_model.dart';
import 'package:presto/services/database/dataHandlers/notificationDataHandler.dart';
import 'package:presto/services/database/dataHandlers/profileDataHandler.dart';
import 'package:presto/services/database/dataProviders/limits_data_provider.dart';
import 'package:presto/services/database/dataProviders/transactions_data_provider.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/widgets/paymentSheet.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BorrowViewModel extends BaseViewModel {
  final log = getLogger("BorrowViewModel");
  String title = "I am Borrow";
  TextEditingController amountController = TextEditingController();

  // final LimitsDataHandler _limitsDataHandler = locator<LimitsDataHandler>();
  TransactionLimits? transactionLimits =
      locator<LimitsDataProvider>().transactionLimits;

  late void Function(bool) callback;

  double amount = 100;

  String? finalUPI;

  void setAmount(double value) {
    amount = value.ceilToDouble();
    notifyListeners();
  }

  void increaseAmount(double value) {
    if (amount + value <= (transactionLimits?.borrowUpperLimit ?? 1000)) {
      amount = amount + value;
      notifyListeners();
    }
  }

  void decreaseAmount(double value) {
    if (amount - value >= (transactionLimits?.borrowLowerLimit ?? 1)) {
      amount = amount - value;
      notifyListeners();
    }
  }

  void onModelReady(void Function(bool) callback) {
    log.v("Borrow View Model initiated");
    this.callback = callback;
  }

  bool inProcess = false;

  TextEditingController upiController = TextEditingController();

  void checkCurrentStatus({required double height, required double width}) {
    inProcess = true;
    notifyListeners();

    /// Check if data is ready
    if (locator<TransactionsDataProvider>().lenders == null ||
        locator<TransactionsDataProvider>().notificationTokens == null) {
      log.w("data not ready");
      locator<DialogService>().showDialog(
        buttonTitle: "Proceed",
        buttonTitleColor: Colors.black,
        title: "Wait a moment ",
        description: "Fetching information. Please try again in few seconds",
      );
      inProcess = false;
      notifyListeners();
      return;
    }

    /// Check if user is disabled
    if (locator<UserDataProvider>().platformData!.disabled) {
      log.w("User Disabled");
      locator<DialogService>().showDialog(
        buttonTitle: "Proceed",
        buttonTitleColor: Colors.black,
        title: "Have some dignity",
        description:
            "You have not completed your previous transaction within time limit. Pay previous balances and contact Presto for more information.",
      );
      inProcess = false;
      notifyListeners();
      return;
    }

    /// Confirm transaction intent
    if (locator<UserDataProvider>()
            .transactionData!
            .activeTransactions
            .length ==
        locator<LimitsDataProvider>()
            .transactionLimits!
            .maxActiveTransactionsPerBorrowerForFreeVersion) {
      log.w("already in a borrowing request placed and accepted");
      locator<DialogService>().showDialog(
        buttonTitle: "Proceed",
        buttonTitleColor: Colors.black,
        title: "Limit Exceeded",
        description:
            "One can keep up-to ${locator<LimitsDataProvider>().transactionLimits!.maxActiveTransactionsPerBorrowerForFreeVersion} pending transactions. Please pay-back before borrowing previous requests first.",
      );
      inProcess = false;
      notifyListeners();
      return;
    }

    DateTime currentTime = DateTime.now();
    log.v("Current time: $currentTime");
    log.v(
        "borrowingRequestInProcess: ${locator<UserDataProvider>().transactionData!.borrowingRequestInProcess}");
    log.v(
        "last borrowing request placed at: ${locator<UserDataProvider>().transactionData!.lastBorrowingRequestPlacedAt}");
    if (locator<UserDataProvider>()
        .transactionData!
        .borrowingRequestInProcess) {
      DateTime? lastRequestTime = locator<UserDataProvider>()
          .transactionData!
          .lastBorrowingRequestPlacedAt;
      int? differenceInMinutes = lastRequestTime != null
          ? currentTime.difference(lastRequestTime).inMinutes
          : null;
      // log.v("Last Request time: $lastRequestTime");
      // log.v("Current Time: $currentTime");
      // log.v(
      //     "Valid or not: ${differenceInMinutes! < locator<LimitsDataProvider>().transactionLimits!.keepTransactionActiveForHours}");
      // log.v(
      //     "Transaction Alive time: ${locator<LimitsDataProvider>().transactionLimits!.keepTransactionActiveForHours}");
      if (lastRequestTime != null &&
          differenceInMinutes != null &&
          differenceInMinutes <
              (locator<LimitsDataProvider>()
                      .transactionLimits!
                      .keepTransactionActiveForHours *
                  60)) {
        // log.wtf(locator<LimitsDataProvider>()
        //     .transactionLimits!
        //     .keepTransactionActiveForHours
        //     .toString());
        DateTime completionTime = lastRequestTime.add(
          Duration(
            hours: locator<LimitsDataProvider>()
                .transactionLimits!
                .keepTransactionActiveForHours,
            minutes: locator<LimitsDataProvider>()
                .transactionLimits!
                .keepTransactionActiveForMinutes,
          ),
        );
        int remainingMinutes = completionTime.difference(currentTime).inMinutes;
        int remainingHours = completionTime.difference(currentTime).inHours;
        log.v("Last request completes at $completionTime");
        log.v("Remaining hours ${(remainingMinutes / 60).floor()}");
        log.v("Remaining minutes $remainingMinutes");
        locator<DialogService>().showDialog(
          buttonTitle: "Proceed",
          buttonTitleColor: Colors.black,
          title: "Warning",
          description:
              "Your previous borrowing request is in process. Please wait for $remainingHours hrs ${(remainingMinutes % 60)} min",
        );
        inProcess = false;
        notifyListeners();
        return;
      } else {
        /// Updates local data base to inform last transaction is dead
        locator<UserDataProvider>()
            .transactionData!
            .lastBorrowingRequestPlacedAt = currentTime;
        locator<UserDataProvider>().transactionData!.borrowingRequestInProcess =
            false;
        locator<ProfileDataHandler>().updateProfileData(
          data: locator<UserDataProvider>().transactionData!.toJson(),
          typeOfDocument: ProfileDocument.userTransactionsData,
          userId: locator<UserDataProvider>().platformData!.referralCode,
          toLocalDatabase: true,
        );
      }
    }
    log.wtf("Sheet please");
    if (amount != 0)
      showDialog(
        barrierDismissible: false,
        context: StackedService.navigatorKey!.currentContext!,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirmation"),
            content: Text(
                "Are you sure you want to borrow and amount of \u20B9 $amount"),
            actions: [
              Container(
                height: height * 0.05,
                width: width * 0.22,
                color: Colors.white24,
                child: MaterialButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    inProcess = false;
                    notifyListeners();
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Container(
                height: height * 0.05,
                width: width * 0.22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.hardEdge,
                child: MaterialButton(
                  color: primaryColor,
                  child: Text(
                    "Proceed",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();

                    /// ask for upi ID
                    showModalBottomSheet(
                      isDismissible: false,
                      context: StackedService.navigatorKey!.currentContext!,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => paymentSheet(
                        height: height,
                        width: width,
                        upiController: upiController,
                        onCompleteCallBack: startTransaction,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      );
  }

  void startTransaction() {
    DateTime currentTime = DateTime.now();

    /// initiate the process
    // TODO: ask for user preference in payment method
    ///create transaction and update databases
    var transactionId =
        locator<TransactionsDataProvider>().createRandomString();

    if (locator<TransactionsDataProvider>().lenders != null)
      locator<TransactionsDataProvider>().lenders!.remove(
            locator<UserDataProvider>().platformData!.referralCode,
          );
    if (locator<TransactionsDataProvider>().notificationTokens != null)
      locator<TransactionsDataProvider>().notificationTokens!.remove(
            locator<UserDataProvider>().token!.notificationToken,
          );
    locator<TransactionsDataProvider>()
        .createTransaction(
      transaction: CustomTransaction(
        razorpayInformation: RazorpayInformation(
          borrowerRazorpayPaymentId: null,
          lenderRazorpayPaymentId: null,
          sentMoneyToLender: false,
          sentMoneyToBorrower: false,
        ),
        genericInformation: GenericInformation(
          transactionId: transactionId,
          amount: amount.toInt(),
          interestRate: 0,
          initiationAt: currentTime,
        ),
        // TODO:  add the list fetched from bottom sheet
        borrowerInformation: BorrowerInformation(
          upiId: upiController.text.trim(),
          borrowerCreditScore:
              (locator<UserDataProvider>().platformRatingsData!.communityScore +
                      locator<UserDataProvider>()
                          .platformRatingsData!
                          .personalScore) /
                  2,
          borrowerReferralCode:
              locator<UserDataProvider>().platformData!.referralCode,
          borrowerName: locator<UserDataProvider>().personalData!.name,
        ),
        transactionStatus: TransactionStatus(
          borrowerSentMoneyAt: null,
          lenderSentMoneyAt: null,
          approvedStatus: false,
          lenderSentMoney: false,
          borrowerSentMoney: false,
          isBorrowerPenalised: false,
          isLenderPenalised: false,
        ),
        lenderInformation: LenderInformation(
          lenderReferralCode: null,
          lenderName: null,
          upiId: null,
        ),
      ),
    )
        .then((value) {
      if (locator<TransactionsDataProvider>().lenders != null) {
        locator<TransactionsDataProvider>().lenders =
            locator<TransactionsDataProvider>().lenders!.toSet().toList();
        locator<TransactionsDataProvider>()
            .lenders!
            .remove(locator<UserDataProvider>().platformData!.referralCode);
      }
      if (locator<TransactionsDataProvider>().notificationTokens != null) {
        locator<TransactionsDataProvider>().notificationTokens =
            locator<TransactionsDataProvider>()
                .notificationTokens!
                .toSet()
                .toList();
        locator<TransactionsDataProvider>()
            .notificationTokens!
            .remove(locator<UserDataProvider>().token!.notificationToken);
      }
      locator<NotificationDataHandler>()
          .setNotificationDocument(
        docId: locator<UserDataProvider>().platformData!.referralCode,
        data: CustomNotification(
          community: locator<UserDataProvider>().platformData!.community,
          borrowerRating:
              (locator<UserDataProvider>().platformRatingsData!.personalScore +
                      locator<UserDataProvider>()
                          .platformRatingsData!
                          .communityScore) /
                  2,
          amount: amount.ceil(),
          transactionId: transactionId,
          paymentMethods: [PaymentMethods.googlePay],
          borrowerReferralCode:
              locator<UserDataProvider>().platformData!.referralCode,
          lendersReferralCodes: locator<TransactionsDataProvider>().lenders!,
          initiationTime: currentTime,
        ).toJson(),
      )
          .then((value) {
        try {
          FirebaseFunctions functions = FirebaseFunctions.instance;
          Function sendPushNotification =
              functions.httpsCallable('sendPushNotification');
          print(
              "\n\nSending Push Notification to ${locator<TransactionsDataProvider>().notificationTokens}\n\n");
          sendPushNotification(
            locator<TransactionsDataProvider>()
                .notificationTokens!
                .toSet()
                .toList(),
          );
          inProcess = false;
          notifyListeners();
        } on FirebaseFunctionsException catch (e) {
          log.e("${e.toString()} \n ${e.runtimeType}");
        } catch (e) {
          log.e("${e.toString()} \n ${e.runtimeType}");
        }
      });
    });
  }
}
