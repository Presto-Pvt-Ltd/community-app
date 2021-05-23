import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presto/services/database/firestoreBase.dart';

enum LimitDocument {
  transactionLimits,
  referralLimits,
  rewardData,
  shareText,
}

class LimitDataHandling extends FirestoreService {
  final CollectionReference _transactionLimits =
      FirebaseFirestore.instance.collection("transactionLimits");
  final CollectionReference _referralLimits =
      FirebaseFirestore.instance.collection("referralLimits");
  final CollectionReference _rewardData =
      FirebaseFirestore.instance.collection("rewardData");
  final CollectionReference _shareText =
      FirebaseFirestore.instance.collection("shareText");

  /// Get's appropriate collection reference.
  /// [transactionId] denotes the document Id in [transaction] collection.
  /// [typeOfDocument] denotes the name of Sub-Collection you want to access.
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
  }) async {
    return await getData(
        document: _getLimitReference(typeOfLimit).doc("transactionLimits"));
  }
}
