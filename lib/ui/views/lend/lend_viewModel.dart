import 'package:presto/app/app.logger.dart';
import 'package:stacked/stacked.dart';

class LendViewModel extends BaseViewModel {
  final log = getLogger("LendViewModel");
  String title = "I am Lend Screen";
  late void Function(bool) callback;

  void onModelReady(void Function(bool) callback) {
    this.callback = callback;
  }
}
