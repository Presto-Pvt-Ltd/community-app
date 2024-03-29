import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/services/error/error.dart';

class FirestoreService {
  /// This is an initialisation class.
  /// It only performs input output operations and provides streams
  /// Tt must never perform data manipulation tasks
  final ErrorHandlingService _errorHandlingService =
      locator<ErrorHandlingService>();
  final log = getLogger("FirestoreService");

  /// Updates [data] to document provided
  Future<bool> updateData({
    required Map<String, dynamic> data,
    required DocumentReference document,
  }) async {
    try {
      return await document.update(data).then((value) => true);
    } catch (e) {
      log.e("There was error here");
      _errorHandlingService.handleError(error: e);
      return false;
    }
  }

  /// Sets [data] to document provided
  Future<bool> setData({
    required Map<String, dynamic> data,
    required DocumentReference document,
  }) async {
    try {
      return await document.set(data).then((value) => true);
    } catch (e) {
      log.e("There was error here");
      _errorHandlingService.handleError(error: e);
      return false;
    }
  }

  /// Gets [data] from document provided
  Future<Map<String, dynamic>> getData({
    required DocumentReference document,
  }) async {
    try {
      return document.get().then((snapshot) {
        if (snapshot.exists) {
          return snapshot.data()!;
        } else
          throw Exception("No Data Found");
      });
    } catch (e) {
      log.e("There was error here");
      _errorHandlingService.handleError(error: e);
      return {};
    }
  }

  /// Deletes document reference provided
  Future<bool> deleteData({required DocumentReference document}) async {
    try {
      return await document.delete().then((value) => true);
    } catch (e) {
      log.e("There was error here");
      _errorHandlingService.handleError(error: e);
      return false;
    }
  }

  Future<DocumentSnapshot> checkForUserDocumentExistence(
      {required String docId}) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .get();
  }

  Future<QuerySnapshot> checkForCollectionExistence({
    required String community,
  }) async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(community).get();
    return querySnapshot;
  }

  Future<QuerySnapshot?> getCollection({required String collection}) async {
    return await FirebaseFirestore.instance
        .collection(collection)
        .limit(1)
        .get();
  }
}
