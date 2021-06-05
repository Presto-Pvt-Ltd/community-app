import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:presto/app/app.logger.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  final log = getLogger('RazorpayService');

  final _razorpay = Razorpay();

  RazorpayService() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    log.wtf(response.toString());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  void clearInstance() {
    _razorpay.clear(); // Removes all listeners
  }

  /// [amount] must be in rupees
  Future<void> createOrderInServer({required double amount}) async {
    amount = amount * 100;
    var uname = 'rzp_live_czsnnKwmX3ZSff';
    var pword = 'L0naRRqpYhrtlyxjple9E3Bo';
    var authn = 'Basic ' + base64Encode(utf8.encode('$uname:$pword'));
    var headers = {
      'content-type': 'application/json',
      'Authorization': authn,
    };

    var data =
        '{ "amount": $amount, "currency": "INR", "receipt": "rcptid_11" }';

    await http
        .post(Uri.parse('https://api.razorpay.com/v1/orders'),
            headers: headers, body: data)
        .then((res) {
      if (res.statusCode != 200)
        throw Exception(
            'http.post error: statusCode= ${res.statusCode} \n ${res.body}');
      var map = jsonDecode(res.body);
      var options = {
        'key': 'rzp_live_czsnnKwmX3ZSff',
        'amount': amount, //in the smallest currency sub-unit.
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
