import 'package:presto/app/app.logger.dart';
import 'package:stacked/stacked.dart';

class TransactionsViewModel extends BaseViewModel {
  final log = getLogger("TransactionsViewModel");
  String title = "I am Transactions";

  late void Function(bool) callback;

  void onModelReady(void Function(bool) callback){
    this.callback = callback;
  }
}
