import 'package:flutter/cupertino.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/models/limits/transaction_limit_model.dart';
import 'package:presto/services/database/dataHandlers/limitsDataHandler.dart';
import 'package:stacked/stacked.dart';

class BorrowViewModel extends BaseViewModel {
  final log = getLogger("BorrowViewModel");
  String title = "I am Borrow";
  TextEditingController amount = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController upi_id = TextEditingController();
  final LimitsDataHandler _limitsDataHandler = locator<LimitsDataHandler>();
  TransactionLimits? transactionLimits;

  ///Payment code below
  // UpiPay _upiPay = UpiPay();
  // List<ApplicationMeta>? apps;
  late void Function(bool) callback;

  void onModelReady(void Function(bool) callback) {
    log.v("Borrow View Model initiated");
    this.callback = callback;
    setBusy(true);
    _limitsDataHandler
        .getLimitsData(
      typeOfLimit: LimitDocument.transactionLimits,
      fromLocalDatabase: false,
    )
        .then((mapData) {
      transactionLimits = TransactionLimits.fromJson(mapData);
      notifyListeners();
      setBusy(false);
    });
  }

  void initiatePayment() {}
}
