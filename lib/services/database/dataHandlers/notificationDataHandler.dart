import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';

import '../firestoreBase.dart';

class NotificationDataHandler {
  final FirestoreService _firestoreService = FirestoreService();
  final log = getLogger("NotificationDataHandler");
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("notifications");

  /// Gets a stream of query snapshots of notifications
  /// Queries :-
  /// 1) referees array in notification doc must contain user's referral id
  /// 2) the notification document must not be updated before activeHoursLimit
  Stream<QuerySnapshot> getStream() {
    log.v(
      "Getting stream for notifications with referral code : ${locator<UserDataProvider>().platformData!.referralCode}",
    );
    return collectionReference
        .where(
          "lendersReferralCodes",
          arrayContains: locator<UserDataProvider>().platformData!.referralCode,
        )
        .snapshots();
  }

  Future<void> deleteNotificationDocument({required String docId}) async {
    log.v("Deleting notification document : $docId");
    _firestoreService.deleteData(document: collectionReference.doc(docId));
  }

  Future<void> setNotificationDocument({
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    log.v('Storing notification in Firestore : $docId');
    _firestoreService.setData(
        data: data, document: collectionReference.doc(docId));
  }
}
