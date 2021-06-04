import 'package:presto/models/transactions/custom_transaction_data_model.dart';
import 'package:stacked/stacked.dart';

class TransactionViewModel extends BaseViewModel {
  late final CustomTransaction transaction;
  void onModelReady(CustomTransaction transaction) {
    this.transaction = transaction;
  }
}
