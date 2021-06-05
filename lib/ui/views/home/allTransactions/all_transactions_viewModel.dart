import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/models/transactions/custom_transaction_data_model.dart';
import 'package:presto/services/database/dataProviders/transactions_data_provider.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../app/app.locator.dart';
import '../../../../app/app.router.dart';
import '../../../../app/app.router.dart';

class AllTransactionsViewModel extends BaseViewModel {
  final log = getLogger("TransactionsViewModel");
  String title = "I am Transactions";
  final NavigationService navigationService = locator<NavigationService>();
  List<CustomTransaction> transactions =
      locator<TransactionsDataProvider>().userTransactions ??
          <CustomTransaction>[];
  List<CustomTransaction> activeTransactions = <CustomTransaction>[];
  late void Function(bool) callback;
  bool gotData = false;
  void onModelReady(void Function(bool) callback) {
    this.callback = callback;
    List<String> active =
        locator<UserDataProvider>().transactionData!.activeTransactions;
    if (active.length > 0)
      transactions.forEach((element) {
        if (active.contains(element.genericInformation.transactionId)) {
          activeTransactions.add(element);
        }
      });
  }
}
