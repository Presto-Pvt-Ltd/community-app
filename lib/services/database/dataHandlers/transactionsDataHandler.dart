import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/models/transactions/custom_transaction_data_model.dart';
import 'package:presto/services/database/firestoreBase.dart';
import 'package:presto/services/error/error.dart';

import '../hiveDatabase.dart';

enum TransactionDocument {
  genericInformation,
  lenderInformation,
  borrowerInformation,
  transactionStatus,
  razorpayInformation,
}

class TransactionsDataHandler {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final HiveDatabaseService _hiveDatabaseService =
      locator<HiveDatabaseService>();
  final ErrorHandlingService _errorHandlingService =
      locator<ErrorHandlingService>();
  final log = getLogger("TransactionsDataHandler");

  /// Fetches TransactionData for transaction with [transactionId] and [typeOfDocument]
  Future<Map<String, dynamic>> getTransactionData({
    required String transactionId,
    required bool fromLocalStorage,
  }) async {
    try {
      if (fromLocalStorage) {
        log.v("Getting data from local database");
        return throw Exception("NOt Applicable");
      } else {
        log.v("Getting data from cloud database");
        return await _firestoreService.getData(
          document: FirebaseFirestore.instance
              .collection("transactions")
              .doc(transactionId),
        );
      }
    } catch (e) {
      log.e("There was error here");
      _errorHandlingService.handleError(error: e);
      return <String, dynamic>{};
    }
  }

  /// Updates [data] for transaction with [transactionId] and [typeOfDocument]
  Future<bool> updateTransaction({
    required Map<String, dynamic> data,
    required String transactionId,
    required bool toLocalStorage,
  }) async {
    try {
      if (toLocalStorage) {
        log.v("Updating data in local database");
        return throw Exception("NOt Applicable");
      } else {
        log.v("Updating data in cloud database");
        return await _firestoreService.updateData(
          data: data,
          document: FirebaseFirestore.instance
              .collection("transactions")
              .doc(transactionId),
        );
      }
    } catch (e) {
      log.e("There was error here");
      _errorHandlingService.handleError(error: e);
      return false;
    }
  }

  /// Sets [data] for transaction with [transactionId] and [typeOfDocument]
  Future<bool> createTransaction({
    required Map<String, dynamic> data,
    required String transactionId,
    required bool toLocalStorage,
  }) async {
    try {
      if (toLocalStorage) {
        log.v("Creating data in local database");
        return throw Exception("NOt Applicable");
      } else {
        log.v("Creating data in cloud database");
        return await _firestoreService.setData(
          data: data,
          document: FirebaseFirestore.instance
              .collection("transactions")
              .doc(transactionId),
        );
      }
    } catch (e) {
      log.e("There was error here");
      _errorHandlingService.handleError(error: e);
      return false;
    }
  }

  Future<bool> updateTransactionListInHive(
      List<CustomTransaction> transactionList) async {
    return _hiveDatabaseService.setDataInHive(
      data: jsonEncode(transactionList),
      key: "transactions",
    );
  }

  Future<List<CustomTransaction>> getTransactionListInHive() async {
    var tempList = _hiveDatabaseService.getTransactionListFromHive(
      key: "transactions",
    );
    if (tempList.runtimeType != List) {
      tempList = [];
    }
    if (tempList.length != 0) {
      List<Map<String, dynamic>> list = tempList.map((element) {
        return Map<String, dynamic>.from(element);
      }).toList();
      print(list);

      return list.map((e) => CustomTransaction.fromJson(e)).toList();
    } else {
      return <CustomTransaction>[];
    }
  }

  // /// Get's appropriate collection reference.
  // /// [transactionId] denotes the document Id in [transaction] collection.
  // /// [typeOfDocument] denotes the name of Sub-Collection you want to access.
  // CollectionReference _getTransactionReference(
  //   String transactionId,
  //   String docId,
  // ) {
  //   log.v(
  //       "Getting appropriate collection reference for $transactionId and $docId");
  //   return FirebaseFirestore.instance
  //       .collection("transactions")
  //       .doc(transactionId)
  //       .collection(docId);
  // }

  /// Get's document Id for given [typeOfDocument]
  String getTransactionDocEnumToString(TransactionDocument typeOfDocument) {
    switch (typeOfDocument) {
      case TransactionDocument.borrowerInformation:
        return "borrowerInformation";
      case TransactionDocument.genericInformation:
        return "genericInformation";
      case TransactionDocument.lenderInformation:
        return "lenderInformation";
      case TransactionDocument.transactionStatus:
        return "transactionStatus";
      case TransactionDocument.razorpayInformation:
        return "razorpayInformation";
      default:
        throw Exception("Accessed some unknown reference string");
    }
  }
}
