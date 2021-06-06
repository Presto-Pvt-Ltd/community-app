import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/models/transactions/custom_transaction_data_model.dart';
import 'package:presto/services/database/dataHandlers/profileDataHandler.dart';
import 'package:presto/services/database/dataHandlers/transactionsDataHandler.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:presto/services/error/error.dart';

class TransactionsDataProvider {
  final log = getLogger("TransactionsDataProvider");

  final TransactionsDataHandler _transactionsDataHandler =
      locator<TransactionsDataHandler>();
  final ErrorHandlingService _errorHandlingService =
      locator<ErrorHandlingService>();

  /// Transactions Data
  List<CustomTransaction>? userTransactions;

  /// token list
  List<String>? notificationTokens;

  /// lender list
  List<String>? lenders;

  void dispose() {
    userTransactions = null;
    notificationTokens = null;
    lenders = null;
  }

  /// transaction id generator
  final Random _random = Random.secure();
  String createRandomString([int length = 12]) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));
    return base64Url.encode(values);
  }

  void loadData({
    required List<String> transactionIds,
    required List<String> activeTransactions,
  }) async {
    try {
      log.v("Checking whether there are any transactions");
      if (transactionIds.length == 0) {
        log.v("transactions don't exist");
        userTransactions = <CustomTransaction>[];
      } else {
        userTransactions = <CustomTransaction>[];
        log.v("There are new transactions on cloud storage");

        /// Start downloading new transactions
        List<Future<Map<String, dynamic>>> futures = [];

        /// for each transaction there are multiple subcollections
        /// store futures of those sub collections in a list
        /// which in itself is stored in list [futures] of all new transactions
        transactionIds.forEach((transactionId) {
          futures.add(_transactionsDataHandler.getTransactionData(
            transactionId: transactionId,
            fromLocalStorage: false,
          ));

          print(futures.toString());
        });
        log.v(
          "New TransactionIDs are : $transactionIds",
        );

        /// for each [singleTransaction] wait for all of it's futures
        /// then add in new [CustomTransaction] to [userTransactions]
        Future.wait(futures).then((transactionsFetched) {
          transactionsFetched.forEach((transactionFetched) {
            log.v(
              "Waited for future to complete, got transaction : $transactionFetched",
            );
            userTransactions!.add(
              CustomTransaction.fromJson(transactionFetched),
            );
          });
        });
      }
    } catch (e) {
      log.e("There was error here");
      _errorHandlingService.handleError(error: e);
      Future.delayed(
        Duration(seconds: 2),
        () {
          if (e.toString() == "Reading from your storage")
            loadData(
              transactionIds: transactionIds,
              activeTransactions: activeTransactions,
            );
        },
      );
    }
  }

  Future<void> createTransaction({
    required CustomTransaction transaction,
  }) async {
    userTransactions == null
        ? userTransactions = [transaction]
        : userTransactions!.add(transaction);
    log.v("Updated custom transactionList here");

    ///Firebase create new [transaction] in transactions Collection
    log.v("Creating transaction in firebase");
    await _transactionsDataHandler.createTransaction(
      data: transaction.toJson(),
      transactionId: transaction.genericInformation.transactionId,
      toLocalStorage: false,
    );

    log.v("Created transaction in firebase");

    /// Update User document
    /// Adds new [transactionId] in user Transaction Data
    locator<UserDataProvider>().transactionData!.transactionIds.add(
          transaction.genericInformation.transactionId,
        );

    /// Sets active [borrowingRequestInProcess] to [true]
    locator<UserDataProvider>().transactionData!.borrowingRequestInProcess =
        true;

    /// Sets [lastBorrowingRequestPlacesAt] to current timestamp
    locator<UserDataProvider>().transactionData!.lastBorrowingRequestPlacedAt =
        DateTime.now();
    log.v("Updated user transaction data in data provider");

    await locator<ProfileDataHandler>().updateProfileData(
      data: locator<UserDataProvider>().transactionData!.toJson(),
      typeOfDocument: ProfileDocument.userTransactionsData,
      userId: locator<UserDataProvider>().platformData!.referralCode,
      toLocalDatabase: true,
    );
    log.v("Updated user transaction data in hive");

    await locator<ProfileDataHandler>().updateProfileData(
      data: locator<UserDataProvider>().transactionData!.toJson(),
      typeOfDocument: ProfileDocument.userTransactionsData,
      userId: locator<UserDataProvider>().platformData!.referralCode,
      toLocalDatabase: false,
    );
    log.v("Updated user transaction data in firestore");
  }
}
