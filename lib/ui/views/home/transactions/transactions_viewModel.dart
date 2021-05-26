import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/services/database/dataProviders/transactions_data_provider.dart';
import 'package:stacked/stacked.dart';

class TransactionsViewModel extends BaseViewModel {
  final log = getLogger("TransactionsViewModel");
  String title = "I am Transactions";
  List<CustomTransaction>? transactions;
  final TransactionsDataProvider _transactionsDataProvider =
      locator<TransactionsDataProvider>();
  late void Function(bool) callback;

  void onModelReady(void Function(bool) callback) {
    this.callback = callback;
    setBusy(true);
    _transactionsDataProvider.gotData.listen((event) {
      if (event) {
        transactions = _transactionsDataProvider.userTransactions;
        notifyListeners();
        setBusy(false);
      }
    });
  }
}
