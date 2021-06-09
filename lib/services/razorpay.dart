import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart' as http;
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/models/notification/notification_data_model.dart';
import 'package:presto/services/database/dataProviders/limits_data_provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:stacked_services/stacked_services.dart';

class RazorpayService {
  final log = getLogger('RazorpayService');

  final _razorpay = Razorpay();
  late final Function paymentSuccessCallback;

  RazorpayService({required Function callback}) {
    paymentSuccessCallback = callback;
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    try {
      FirebaseFunctions functions = FirebaseFunctions.instance;
      Function sendPushNotification =
          functions.httpsCallable('sendPushNotification');
      print(
          "\n\nSending Push Notification to ${locator<LimitsDataProvider>().transactionLimits!.mediatorTokens}\n\n");
      sendPushNotification(
        locator<LimitsDataProvider>()
            .transactionLimits!
            .mediatorTokens!
            .toSet()
            .toList(),
      );
      paymentSuccessCallback(response.paymentId);
    } on FirebaseFunctionsException catch (e) {
      log.e("${e.toString()} \n ${e.runtimeType}");
    } catch (e) {
      log.e("${e.toString()} \n ${e.runtimeType}");
    }
    log.wtf(response.toString());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    locator<DialogService>().showDialog(
        title: "Payment Failed",
        description: "Please Try Again ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  void clearInstance() {
    _razorpay.clear(); // Removes all listeners
  }

  /// [amount] must be in rupees
  Future<void> createOrderInServer(
      {required double amount, required String transactionId}) async {
    amount = amount * 100.0;
    var uname = 'rzp_live_czsnnKwmX3ZSff';
    var pword = 'L0naRRqpYhrtlyxjple9E3Bo';
    var authn = 'Basic ' + base64Encode(utf8.encode('$uname:$pword'));
    var headers = {
      'content-type': 'application/json',
      'Authorization': authn,
    };

    var data = jsonEncode({
      "amount": amount.toInt(),
      "currency": "INR",
      "receipt": transactionId
    });
    log.wtf(data);
    await http
        .post(Uri.parse('https://api.razorpay.com/v1/orders'),
            headers: headers, body: data)
        .then((res) {
      if (res.statusCode != 200)
        throw Exception(
            'http.post error: statusCode= ${res.statusCode} \n ${res.body}');
      var map = jsonDecode(res.body);
      log.wtf(map);
      var options = {
        'key': 'rzp_live_czsnnKwmX3ZSff',
        'amount':
            amount.toInt().toString(), //in the smallest currency sub-unit.
        'name': 'Presto Private Ltd',
        'order_id': map['id'].toString(), // Generate order_id using Orders API
        'description': '',
        'timeout': 60, // in seconds
        'prefill': {
          'contact': '9887445671',
          'email': 'prestoprivatelimited@gmail.com'
        }
      };
      _razorpay.open(options);
    });
  }
}
