import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presto/services/database/firestoreBase.dart';

enum TransactionDocument {
  genericInformation,
  lenderInformation,
  borrowerInformation,
  transactionStatus,
}

class TransactionsDataHandling extends FirestoreService {
  /// Fetches TransactionData for transaction with [transactionId] and [typeOfDocument]
  Future<Map<String, dynamic>> getTransactionData({
    required TransactionDocument typeOfDocument,
    required String transactionId,
  }) async {
    final String docId = _getDocId(typeOfDocument);
    final CollectionReference collectionReference =
        _getTransactionReference(transactionId, typeOfDocument);
    return await getData(
      document: collectionReference.doc(docId),
    );
  }

  /// Updates [data] for transaction with [transactionId] and [typeOfDocument]
  Future<bool> updateTransactionStatus({
    required Map<String, dynamic> data,
    required TransactionDocument typeOfDocument,
    required String transactionId,
  }) async {
    final String docId = _getDocId(typeOfDocument);
    final CollectionReference collectionReference =
        _getTransactionReference(transactionId, typeOfDocument);
    return await updateData(
      data: data,
      document: collectionReference.doc(docId),
    );
  }

  /// Get's appropriate collection reference.
  /// [transactionId] denotes the document Id in [transaction] collection.
  /// [typeOfDocument] denotes the name of Sub-Collection you want to access.
  CollectionReference _getTransactionReference(
    String transactionId,
    TransactionDocument typeOfDocument,
  ) {
    switch (typeOfDocument) {
      case TransactionDocument.borrowerInformation:
        return FirebaseFirestore.instance
            .collection("transactions")
            .doc(transactionId)
            .collection("borrowerInformation");
      case TransactionDocument.genericInformation:
        return FirebaseFirestore.instance
            .collection("transactions")
            .doc(transactionId)
            .collection("genericInformation");
      case TransactionDocument.lenderInformation:
        return FirebaseFirestore.instance
            .collection("transactions")
            .doc(transactionId)
            .collection("lenderInformation");
      case TransactionDocument.transactionStatus:
        return FirebaseFirestore.instance
            .collection("transactions")
            .doc(transactionId)
            .collection("transactionStatus");
      default:
        throw Exception("Accessed some unknown reference");
    }
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
