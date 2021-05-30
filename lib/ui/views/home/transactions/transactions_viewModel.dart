import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/main.dart';
import 'package:presto/services/database/dataProviders/transactions_data_provider.dart';
import 'package:stacked/stacked.dart';

class TransactionsViewModel extends StreamViewModel {
  final log = getLogger("TransactionsViewModel");
  String title = "I am Transactions";
  late List<CustomTransaction> transactions;
  final TransactionsDataProvider _transactionsDataProvider =
      locator<TransactionsDataProvider>();
  late void Function(bool) callback;
  bool gotData = false;
  void onModelReady(void Function(bool) callback) {
    this.callback = callback;
  }

  @override
  void onData(event) {
    log.w("There are updates in Transaction List Stream : $event");
    if (event) {
      transactions = _transactionsDataProvider.userTransactions!;
      gotData = true;
      notifyListeners();
      setBusy(false);
    }
    super.onData(event);
  }

  @override
  Stream<bool> get stream => gotTransactionsDataStreamController.stream;
}
