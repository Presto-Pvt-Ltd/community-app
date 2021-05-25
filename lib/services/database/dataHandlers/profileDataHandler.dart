import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presto/services/database/firestoreBase.dart';

enum ProfileDocument {
  userPersonalData,
  userTransactionsData,
  userNotificationToken,
  userPlatformData,
  userPlatformRatings,
}

class ProfileDataHandler {
  final FirestoreService _firestoreService = FirestoreService();

  /// Fetches Profile data for [userId] and [typeOfData]
  Future<Map<String, dynamic>> getTransactionData({
    required ProfileDocument typeOfData,
    required String userId,
    required bool fromLocalDatabase,
  }) async {
    if (fromLocalDatabase) {
      // TODO: Implement Local Storage
      return throw Exception("Not Implemented");
    } else {
      final String docId = _getDocId(typeOfData);
      final CollectionReference collectionReference =
          _getTransactionReference(userId, docId);
      return await _firestoreService.getData(
        document: collectionReference.doc(docId),
      );
    }
  }

  /// Updates [data] for [userId]  and [typeOfDocument]
  Future<bool> updateTransactionStatus({
    required Map<String, dynamic> data,
    required ProfileDocument typeOfDocument,
    required String userId,
    required bool toLocalDatabase,
  }) async {
    if (toLocalDatabase) {
      // TODO: Implement Local Storage
      return throw Exception("Not Implemented");
    } else {
      final String docId = _getDocId(typeOfDocument);
      final CollectionReference collectionReference =
          _getTransactionReference(userId, docId);
      return await _firestoreService.updateData(
        data: data,
        document: collectionReference.doc(docId),
      );
    }
  }

  /// Get's appropriate collection reference.
  /// [userId] denotes the document Id in [transaction] collection.
  /// [typeOfDocument] denotes the name of Sub-Collection you want to access.
  CollectionReference _getTransactionReference(
    String userId,
    String docId,
  ) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection(docId);
  }

  /// Get's document Id for given [typeOfDocument]
  String _getDocId(ProfileDocument typeOfDocument) {
    switch (typeOfDocument) {
      case ProfileDocument.userPersonalData:
        return "userPersonalData";
      case ProfileDocument.userTransactionsData:
        return "userTransactionsData";
      case ProfileDocument.userNotificationToken:
        return "userNotificationToken";
      case ProfileDocument.userPlatformData:
        return "userPlatformData";
      case ProfileDocument.userPlatformRatings:
        return "userPlatformRatings";
    }
  }
}
