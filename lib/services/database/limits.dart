import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presto/services/database/firestore.dart';

enum LimitDocument {
  transactionLimits,
  referralLimits,
  rewardData,
  shareText,
}

class LimitDataHandling extends FirestoreService {
  LimitDataHandling() : super();
  final CollectionReference _transactionLimits =
      FirebaseFirestore.instance.collection("transactionLimits");
  final CollectionReference _referralLimits =
      FirebaseFirestore.instance.collection("referralLimits");
  final CollectionReference _rewardData =
      FirebaseFirestore.instance.collection("rewardData");
  final CollectionReference _shareText =
      FirebaseFirestore.instance.collection("shareText");
}
