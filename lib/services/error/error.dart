import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:presto/app/app.logger.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:presto/services/error/firebaseAuthErrors.dart';

class ErrorHandlingService {
  final log = getLogger('ErrorHandlingService');
  void handleError({
    required var error,
  }) {
    late String message;
    if (error is TypeError) {
      message = error.toString();
    } else if (error is FlutterError) {
      message = error.message.toString();
    } else if (error is FirebaseAuthException) {
      if (authErrors.containsKey(error.code))
        message = authErrors[error.code]!;
      else
        message = "Code: " + error.code + " Message: " + "${error.message}";
    } else if (error is UnimplementedError) {
      message = "${error.message}";
    } else if (error is Exception) {
      message = e.toString();
    } else
      message = error.toString();
    log.e(message);
    BuildContext context = StackedService.navigatorKey!.currentContext!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          softWrap: true,
          style: TextStyle(
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }
}
