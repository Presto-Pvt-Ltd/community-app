import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/services/database/firestoreBase.dart';

import '../hiveDatabase.dart';

enum LimitDocument {
  transactionLimits,
  referralLimits,
  shareText,
  rewardsLimits,
}

class LimitsDataHandler {
  final FirestoreService _firestoreService = FirestoreService();
  final HiveDatabaseService hiveDatabaseService =
      locator<HiveDatabaseService>();
  final log = getLogger("LimitsDataHandler");

  /// Get's appropriate collection reference for [typeOfLimit].
  CollectionReference _getLimitReference(
    LimitDocument typeOfLimit,
    String docId,
  ) {
    log.v("Getting appropriate collection reference");
    return FirebaseFirestore.instance
        .collection("limits")
        .doc("limits")
        .collection(docId);
  }

  Future<Map<String, dynamic>> getLimitsData({
    required LimitDocument typeOfLimit,
    required bool fromLocalDatabase,
  }) async {
    if (fromLocalDatabase) {
      final String docId = _getDocId(typeOfLimit);
      return hiveDatabaseService.getMapDataFromHive(key: docId);
    } else {
      final String docId = _getDocId(typeOfLimit);
      return _firestoreService.getData(
          document: _getLimitReference(typeOfLimit, docId).doc(docId));
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
