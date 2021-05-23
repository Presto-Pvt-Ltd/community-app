import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presto/services/database/firestore.dart';

enum TransactionDocument {
  genericInformation,
  lenderInformation,
  borrowerInformation,
  transactionStatus,
}

class TransactionsDataHandling extends FirestoreService {
  final CollectionReference _genericInformation =
      FirebaseFirestore.instance.collection("genericInformation");
  final CollectionReference _lenderInformation =
      FirebaseFirestore.instance.collection("lenderInformation");
  final CollectionReference _borrowerInformation =
      FirebaseFirestore.instance.collection("borrowerInformation");
  final CollectionReference _transactionStatus =
      FirebaseFirestore.instance.collection("transactionStatus");
}
