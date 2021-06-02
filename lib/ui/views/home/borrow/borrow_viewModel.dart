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
import 'package:presto/models/transactions/transaction_status_data_model.dart';
import 'package:presto/services/database/dataHandlers/limitsDataHandler.dart';
import 'package:presto/services/database/dataHandlers/notificationDataHandler.dart';
import 'package:presto/services/database/dataProviders/transactions_data_provider.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BorrowViewModel extends BaseViewModel {
  final log = getLogger("BorrowViewModel");
  String title = "I am Borrow";
  TextEditingController amountController = TextEditingController();

  final LimitsDataHandler _limitsDataHandler = locator<LimitsDataHandler>();
  TransactionLimits? transactionLimits;

  late void Function(bool) callback;
  bool gotData = false;

  double amount = 0;

  void onModelReady(void Function(bool) callback) {
    log.v("Borrow View Model initiated");
    this.callback = callback;

    _limitsDataHandler
        .getLimitsData(
      typeOfLimit: LimitDocument.transactionLimits,
      fromLocalDatabase: false,
    )
        .then((mapData) {
      transactionLimits = TransactionLimits.fromJson(mapData);
      gotData = true;
      notifyListeners();
      setBusy(false);
    });
  }

  void initiatePayment() {
    /// Confirm transaction intent
    /// initiate transaction
    /// ask for user preference in payment method
    /// then create new transaction document in firebase and hive
    /// update provider
    /// send notifications and display some sort of timer
    if (amount != 0)
      locator<DialogService>()
          .showConfirmationDialog(
              title: "Confirmation",
              description:
                  "Are you sure you want to borrow and amount of \u20B9 $amount")
          .then((value) {
        if (value!.confirmed) {
          /// initiate the process
          // TODO: ask for user preference in payment method
          // TODO: Timer
          // TODO: Create lending request and send notifications
          ///create transaction and update databases
          var transactionId =
              locator<TransactionsDataProvider>().createRandomString();
          locator<TransactionsDataProvider>().lenders!.remove(
                locator<UserDataProvider>().platformData!.referralCode,
              );
          locator<TransactionsDataProvider>().notificationTokens!.remove(
                locator<UserDataProvider>().token!.notificationToken,
              );
          locator<TransactionsDataProvider>()
              .createTransaction(
            transaction: CustomTransaction(
              genericInformation: GenericInformation(
                transactionId: transactionId,
                amount: amount.toInt(),
                transactionMethods: [PaymentMethods.payTm],
                interestRate: 0,
                initiationAt: DateTime.now(),
              ),
              borrowerInformation: BorrowerInformation(
                borrowerReferralCode:
                    locator<UserDataProvider>().platformData!.referralCode,
                borrowerSentMoneyAt: null,
              ),
              transactionStatus: TransactionStatus(
                approvedStatus: false,
                lenderSentMoney: false,
                borrowerSentMoney: false,
                isBorrowerPenalised: false,
                isLenderPenalised: false,
              ),
              lenderInformation: LenderInformation(
                lenderReferralCode: null,
                lenderSentMoneyAt: null,
              ),
            ),
          )
              .then((value) {
            locator<NotificationDataHandler>().setNotificationDocument(
              docId: locator<UserDataProvider>().platformData!.referralCode,
              data: CustomNotification(
                borrowerRating: (locator<UserDataProvider>()
                            .platformRatingsData!
                            .personalScore +
                        locator<UserDataProvider>()
                            .platformRatingsData!
                            .communityScore) /
                    2,
                amount: amount.ceil(),
                transactionId: transactionId,
                paymentMethods: [PaymentMethods.googlePay],
                borrowerReferralCode:
                    locator<UserDataProvider>().platformData!.referralCode,
                lendersReferralCodes:
                    locator<TransactionsDataProvider>().lenders!,
              ).toJson(),
            );
          });
        }
      });
  }
}
