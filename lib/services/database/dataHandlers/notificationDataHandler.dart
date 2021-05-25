import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presto/app/app.logger.dart';


import '../firestoreBase.dart';

class NotificationDataHandler {
  final FirestoreService _firestoreService = FirestoreService();
  final log = getLogger("NotificationDataHandler");
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("notifications");

  Stream getStream({required String referralCode}) {
    log.v(
      "Getting stream for notifications with referral code : $referralCode",
    );
    return collectionReference
        .where("referees", arrayContains: referralCode)
        .snapshots();
  }

  Future<void> deleteNotificationDocument({required String docId}) async {
    log.v("Deleting notification document : $docId");
    _firestoreService.deleteData(document: collectionReference.doc(docId));
  }

  Future<void> setNotificationDocument({required String docId, required Map<String, dynamic> data,})
  async {
    log.v('Storing notification in Firestore : $docId');
    _firestoreService.setData(data: data,document: collectionReference.doc(docId));
  }
}
