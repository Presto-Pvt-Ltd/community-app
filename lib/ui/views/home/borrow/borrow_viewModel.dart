import 'package:presto/app/app.locator.dart';
import 'package:flutter/material.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/models/limits/transaction_limit_model.dart';
import 'package:presto/services/database/dataHandlers/limitsDataHandler.dart';
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
                  "Are you sure you want to borrow and amount of \u2B09 $amount")
          .then((value) {
        if (value!.confirmed) {
          /// initiate the process

        }
      });
  }
}
