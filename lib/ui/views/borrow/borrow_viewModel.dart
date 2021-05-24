import 'package:flutter/cupertino.dart';
import 'package:presto/app/app.logger.dart';
import 'package:stacked/stacked.dart';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:upi_pay/upi_pay.dart';

class BorrowViewModel extends BaseViewModel {
  final log = getLogger("BorrowViewModel");
  String title = "I am Borrow";
  TextEditingController amount = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController upi_id = TextEditingController();

  ///Payment code below
  // UpiPay _upiPay = UpiPay();
  // List<ApplicationMeta>? apps;
  late void Function(bool) callback;

  void onModelReady(void Function(bool) callback){
    this.callback = callback;
  }

  void initiatePayment() {
    // UpiPay.getInstalledUpiApplications().then((value) {
    //   apps = value;
    //   value.map((e) {
    //     print(e.upiApplication.getAppName());
    //   });
    // }).catchError((e) {
    //   log.d('error fetching apps ', e.toString());
    //   apps = [];
    // });
    // log.d('UPI app list-' + apps.toString());
    // UpiPay.initiateTransaction(
    //   app: UpiApplication.googlePay,
    //   transactionRef: "&hjkfwa9(*^UhjkGIufgliwoa7ieu",
    //   amount: "1.00",
    //   transactionNote: "Hello testing",
    //   receiverUpiAddress: "9695428701@paytm",
    //   receiverName: 'Shikkhar Uttam',
    // ).then((value) {
    //   print("Success");
    //   print(value.status);
    //   print(value.responseCode);
    //   print(value.approvalRefNo);
    //   print(value.txnRef);
    // }, onError: (error) {
    //   print(error.toString());
    // });
  }
}