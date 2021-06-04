import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/models/transactions/custom_transaction_data_model.dart';
import 'package:presto/services/database/dataProviders/transactions_data_provider.dart';
import 'package:stacked/stacked.dart';

class AllTransactionsViewModel extends BaseViewModel {
  final log = getLogger("TransactionsViewModel");
  String title = "I am Transactions";
  List<CustomTransaction> transactions =
      locator<TransactionsDataProvider>().userTransactions ??
          <CustomTransaction>[];

  late void Function(bool) callback;
  bool gotData = false;
  void onModelReady(void Function(bool) callback) {
    this.callback = callback;
  }
}
