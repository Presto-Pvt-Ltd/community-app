import 'dart:async';

import 'package:presto/app/app.locator.dart';
import 'package:presto/models/transactions/borrower_data_model.dart';
import 'package:presto/models/transactions/generic_data_model.dart';
import 'package:presto/models/transactions/lender_data_model.dart';
import 'package:presto/models/transactions/transaction_status_data_model.dart';
import 'package:presto/services/database/dataHandlers/transactionsDataHandler.dart';

class TransactionsDataProvider {
  final TransactionsDataHandler _transactionsDataHandler =
      locator<TransactionsDataHandler>();

  /// Transactions Data
  List<CustomTransaction>? _userTransactions;

  /// Getters for profile data
  List<CustomTransaction>? get userTransactions => _userTransactions;
  StreamController<bool> _gotData = StreamController<bool>();
  Stream<bool> get gotData => _gotData.stream;
  void loadData({required List<String> transactionIds}) async {
    try {
      _gotData.add(false);
      if (transactionIds.length == 0)
        _userTransactions = <CustomTransaction>[];
      else {
        /// Get CustomTransactionListFrom local storage
        List<CustomTransaction> transactionList =
            _transactionsDataHandler.getTransactionListFromHive();
        _userTransactions = transactionList;

        /// Sync the local storage
        if (transactionList.length != transactionIds.length) {
          List<String> newTransactions = <String>[];

          /// Get new transaction ID's separated
          transactionIds.forEach((element) {
            transactionList.forEach((existingListElement) {
              if (existingListElement.genericInformation.transactionId !=
                  element) {
                newTransactions.add(element);
              }
            });
          });

          /// Start downloading new transactions
          List<List<Future<Map<String, dynamic>>>> futures = [];

          /// for each transaction there are multiple subcollections
          /// store futures of those sub collections in a list
          /// which in itself is stored in list [futures] of all new transactions
          newTransactions.map((transactionId) {
            futures.add(TransactionDocument.values.map((typeOfDocument) {
              return _transactionsDataHandler.getTransactionData(
                typeOfDocument: typeOfDocument,
                transactionId: transactionId,
                fromLocalStorage: false,
              );
            }).toList());
          });

          /// for each [singlTransaction] wait for all of it's futures
          /// then add in new [CustomTrasaction] to [_userTransactions]
          futures.map((singleTransaction) {
            Future.wait(singleTransaction).then((transactionFetched) {
              if (_userTransactions == null)
                _userTransactions = [
                  CustomTransaction(
                    genericInformation:
                        GenericInformation.fromJson(transactionFetched[0]),
                    lenderInformation:
                        LenderInformation.fromJson(transactionFetched[1]),
                    borrowerInformation:
                        BorrowerInformation.fromJson(transactionFetched[2]),
                    transactionStatus:
                        TransactionStatus.fromJson(transactionFetched[3]),
                  ),
                ];
              else {
                _userTransactions!.add(
                  CustomTransaction(
                    genericInformation:
                        GenericInformation.fromJson(transactionFetched[0]),
                    lenderInformation:
                        LenderInformation.fromJson(transactionFetched[1]),
                    borrowerInformation:
                        BorrowerInformation.fromJson(transactionFetched[2]),
                    transactionStatus:
                        TransactionStatus.fromJson(transactionFetched[3]),
                  ),
                );
                if (_userTransactions!.length == transactionIds.length) {
                  _gotData.add(true);
                  _transactionsDataHandler.updateTransactionListInHive(
                    list: _userTransactions,
                  );
                }
              }
            });
          });
        }
      }
    } catch (e) {
      Future.delayed(
        Duration(seconds: 2),
        () {
          loadData(transactionIds: transactionIds);
        },
      );
    }
  }
}

class CustomTransaction {
  final GenericInformation genericInformation;
  final BorrowerInformation borrowerInformation;
  LenderInformation? lenderInformation;
  TransactionStatus transactionStatus;
  CustomTransaction({
    required this.genericInformation,
    required this.borrowerInformation,
    required this.transactionStatus,
    this.lenderInformation,
  });
}
