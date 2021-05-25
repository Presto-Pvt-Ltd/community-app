import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/services/database/firestoreBase.dart';

enum TransactionDocument {
  genericInformation,
  lenderInformation,
  borrowerInformation,
  transactionStatus,
}

class TransactionsDataHandler {
  final FirestoreService _firestoreService = FirestoreService();
  final log = getLogger("TransactionsDataHandler");

  /// Fetches TransactionData for transaction with [transactionId] and [typeOfDocument]
  Future<Map<String, dynamic>> getTransactionData({
    required TransactionDocument typeOfDocument,
    required String transactionId,
    required bool fromLocalStorage,
  }) async {
    if (fromLocalStorage) {
      log.v("Getting data from local database");
      // TODO: Implement Local Storage
      return throw Exception("Not Implemented");
    } else {
      log.v("Getting data from cloud database");
      final String docId = _getDocId(typeOfDocument);
      final CollectionReference collectionReference =
          _getTransactionReference(transactionId, docId);
      return await _firestoreService.getData(
        document: collectionReference.doc(docId),
      );
    }
  }

  /// Updates [data] for transaction with [transactionId] and [typeOfDocument]
  Future<bool> updateTransactionStatus({
    required Map<String, dynamic> data,
    required TransactionDocument typeOfDocument,
    required String transactionId,
    required bool toLocalStorage,
  }) async {
    if (toLocalStorage) {
      log.v("Updating data in local database");
      // TODO: Implement Local Storage
      return throw Exception("Not Implemented");
    } else {
      log.v("Updating data in cloud database");
      final String docId = _getDocId(typeOfDocument);
      final CollectionReference collectionReference =
          _getTransactionReference(transactionId, docId);
      return await _firestoreService.updateData(
        data: data,
        document: collectionReference.doc(docId),
      );
    }
  }

  /// Get's appropriate collection reference.
  /// [transactionId] denotes the document Id in [transaction] collection.
  /// [typeOfDocument] denotes the name of Sub-Collection you want to access.
  CollectionReference _getTransactionReference(
    String transactionId,
    String docId,
  ) {
    log.v(
        "Getting appropriate collection reference for $transactionId and $docId");
    return FirebaseFirestore.instance
        .collection("transactions")
        .doc(transactionId)
        .collection(docId);
  }

  /// Get's document Id for given [typeOfDocument]
  String _getDocId(TransactionDocument typeOfDocument) {
    switch (typeOfDocument) {
      case TransactionDocument.borrowerInformation:
        return "borrowerInformation";
      case TransactionDocument.genericInformation:
        return "genericInformation";
      case TransactionDocument.lenderInformation:
        return "lenderInformation";
      case TransactionDocument.transactionStatus:
        return "transactionStatus";
      default:
        throw Exception("Accessed some unknown reference string");
    }
  }
}
