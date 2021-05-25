import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presto/services/database/firestoreBase.dart';

enum LimitDocument {
  transactionLimits,
  referralLimits,
  shareText,
  rewardsLimits,
}

class LimitsDataHandler {
  final FirestoreService _firestoreService = FirestoreService();

  /// Get's appropriate collection reference for [typeOfLimit].
  CollectionReference _getLimitReference(
    LimitDocument typeOfLimit,
    String docId,
  ) {
    return FirebaseFirestore.instance.collection(docId);
  }

  Future<Map<String, dynamic>> getTransactionsData({
    required LimitDocument typeOfLimit,
    required bool fromLocalDatabase,
  }) async {
    if (fromLocalDatabase) {
      // TODO: Implement Local Storage
      return throw Exception("Not Implemented");
    } else {
      final String docId = _getDocId(typeOfLimit);
      return await _firestoreService.getData(
          document:
              _getLimitReference(typeOfLimit, docId).doc("transactionLimits"));
    }
  }

  /// Get's document Id for given [typeOfDocument]
  String _getDocId(LimitDocument typeOfDocument) {
    switch (typeOfDocument) {
      case LimitDocument.transactionLimits:
        return "transactionLimits";
      case LimitDocument.referralLimits:
        return "referralLimits";
      case LimitDocument.shareText:
        return "shareText";
      case LimitDocument.rewardsLimits:
        return "rewardsLimits";
    }
  }
}
