import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/services/database/firestoreBase.dart';
import 'package:presto/services/database/hiveDatabase.dart';
import 'package:presto/services/error/error.dart';

class RazorpayDataHandler {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final ErrorHandlingService _errorHandlingService =
      locator<ErrorHandlingService>();
  final log = getLogger("RazorpayDataHandler");
}
