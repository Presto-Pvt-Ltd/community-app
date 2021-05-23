import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presto/services/database/firestore.dart';

enum ProfileDocument {
  userPersonalData,
  userTransactionsData,
  userNotificationToken,
  userPlatformRewardsData,
  userPlatformRatings,
}

class ProfileDataHandling extends FirestoreService {
  final CollectionReference _userPersonalData =
      FirebaseFirestore.instance.collection("personalData");
  final CollectionReference _userTransactionsData =
      FirebaseFirestore.instance.collection("userTransactionsData");
  final CollectionReference _userNotificationToken =
      FirebaseFirestore.instance.collection("userNotificationToken");
  final CollectionReference _userPlatformRewardsData =
      FirebaseFirestore.instance.collection("userPlatformRewardsData");
  final CollectionReference _userPlatformRatings =
      FirebaseFirestore.instance.collection("userPlatformRatings");
}
