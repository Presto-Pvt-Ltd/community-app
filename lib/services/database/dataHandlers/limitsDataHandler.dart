import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presto/services/database/firestoreBase.dart';

enum LimitDocument {
  transactionLimits,
  referralLimits,
  rewardData,
  shareText,
}

class LimitsDataHandler {
  final FirestoreService _firestoreService = FirestoreService();

  /// Get's appropriate collection reference for [typeOfLimit].
  CollectionReference _getLimitReference(
    LimitDocument typeOfLimit,
  ) {
    switch (typeOfLimit) {
      case LimitDocument.transactionLimits:
        return FirebaseFirestore.instance.collection("transactionLimits");
      case LimitDocument.referralLimits:
        return FirebaseFirestore.instance.collection("referralLimits");
      case LimitDocument.rewardData:
        return FirebaseFirestore.instance.collection("rewardData");
      case LimitDocument.shareText:
        return FirebaseFirestore.instance.collection("shareText");
    }
  }

  Future<Map<String, dynamic>> getTransactionsData({
    required LimitDocument typeOfLimit,
    required bool fromLocalDatabase,
  }) async {
    if (fromLocalDatabase) {
      return throw Exception("Not Implemented");
    } else {
      return await _firestoreService.getData(
          document: _getLimitReference(typeOfLimit).doc("transactionLimits"));
    }
  }
}
