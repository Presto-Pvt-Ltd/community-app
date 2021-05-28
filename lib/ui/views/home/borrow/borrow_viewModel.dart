import 'package:presto/app/app.locator.dart';
import 'package:flutter/material.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/models/limits/transaction_limit_model.dart';
import 'package:presto/services/database/dataHandlers/limitsDataHandler.dart';
import 'package:stacked/stacked.dart';

class BorrowViewModel extends BaseViewModel {
  final log = getLogger("BorrowViewModel");
  String title = "I am Borrow";
  TextEditingController amount = TextEditingController();

  final LimitsDataHandler _limitsDataHandler = locator<LimitsDataHandler>();
  TransactionLimits? transactionLimits;

  late void Function(bool) callback;
  bool gotData = false;
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

  void initiatePayment() {}
}
