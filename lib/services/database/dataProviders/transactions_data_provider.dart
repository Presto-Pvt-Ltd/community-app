import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/main.dart';
import 'package:presto/models/transactions/borrower_data_model.dart';
import 'package:presto/models/transactions/generic_data_model.dart';
import 'package:presto/models/transactions/lender_data_model.dart';
import 'package:presto/models/transactions/transaction_status_data_model.dart';
import 'package:presto/services/database/dataHandlers/transactionsDataHandler.dart';
import 'package:presto/services/error/error.dart';

class TransactionsDataProvider {
  final log = getLogger("TransactionsDataProvider");

  final TransactionsDataHandler _transactionsDataHandler =
      locator<TransactionsDataHandler>();
  final ErrorHandlingService _errorHandlingService =
      locator<ErrorHandlingService>();

  /// Transactions Data
  List<CustomTransaction>? _userTransactions;

  /// Getters for transaction data
  List<CustomTransaction>? get userTransactions => _userTransactions;

  /// Setter for transaction list
  set userTransactions(List<CustomTransaction>? transactionList) {
    userTransactions = transactionList;
  }

  /// transaction id generator
  final Random _random = Random.secure();
  String createRandomString([int length = 12]) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));
    return base64Url.encode(values);
  }

  void loadData({required List<String> transactionIds}) async {
    try {
      log.v("Checking whether there are any transactions");

      gotTransactionsDataStreamController.add(false);
      if (transactionIds.length == 0) {
        log.v("transactions don't exist");
        _userTransactions = <CustomTransaction>[];
        gotTransactionsDataStreamController.add(true);
      } else {
        log.v("Trying to load data from local storage");

        /// Get CustomTransactionListFrom local storage
        List<CustomTransaction> transactionList =
            _transactionsDataHandler.getTransactionListFromHive();
        _userTransactions = transactionList;
        log.v("Got local transactions. no: ${transactionList.length}");

        /// Sync the local storage
        if (transactionList.length != transactionIds.length) {
          List<String> newTransactions = <String>[];
          log.v("There are new transactions on cloud storage");

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
          log.v(
            "New TransactionIDs are : $newTransactions",
          );

          /// for each [singlTransaction] wait for all of it's futures
          /// then add in new [CustomTrasaction] to [_userTransactions]
          futures.map((singleTransaction) {
            Future.wait(singleTransaction).then((transactionFetched) {
              log.v(
                "Waited for future to complete, got transaction : $transactionFetched",
              );
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
                  gotTransactionsDataStreamController.add(true);
                  log.v("Got final transactions from cloud storage");
                  _transactionsDataHandler.updateTransactionListInHive(
                    list: _userTransactions,
                  );
                }
              }
            });
          });
        } else {
          log.v("Got final transactions from local storage");
          _userTransactions = transactionList;
          gotTransactionsDataStreamController.add(true);
        }
      }
    } catch (e) {
      _errorHandlingService.handleError(error: e);
      Future.delayed(
        Duration(seconds: 2),
        () {
          loadData(transactionIds: transactionIds);
        },
      );
    }
  }

  void createTransaction({required CustomTransaction transaction}) async {
    List<CustomTransaction> tempList =
        _userTransactions ?? <CustomTransaction>[];
    tempList.add(transaction);
    _userTransactions = tempList;

    ///Hive update transaction list
    _transactionsDataHandler.updateTransactionListInHive(
        list: _userTransactions);

    ///Firebase create new transaction
    _transactionsDataHandler.createTransaction(
        data: transaction.borrowerInformation.toJson(),
        typeOfDocument: TransactionDocument.borrowerInformation,
        transactionId: transaction.genericInformation.transactionId,
        toLocalStorage: false);
    _transactionsDataHandler.createTransaction(
        data: transaction.genericInformation.toJson(),
        typeOfDocument: TransactionDocument.genericInformation,
        transactionId: transaction.genericInformation.transactionId,
        toLocalStorage: false);
    _transactionsDataHandler.createTransaction(
        data: transaction.transactionStatus.toJson(),
        typeOfDocument: TransactionDocument.transactionStatus,
        transactionId: transaction.genericInformation.transactionId,
        toLocalStorage: false);
    _transactionsDataHandler.createTransaction(
        data: transaction.lenderInformation!.toJson(),
        typeOfDocument: TransactionDocument.lenderInformation,
        transactionId: transaction.genericInformation.transactionId,
        toLocalStorage: false);
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
