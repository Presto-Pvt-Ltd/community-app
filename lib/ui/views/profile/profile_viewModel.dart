import 'package:presto/app/app.logger.dart';
import 'package:stacked/stacked.dart';

class ProfileViewModel extends BaseViewModel {
  final log = getLogger("ProfileViewModel");
  String title = "I am Profile";
  late void Function(bool) callback;

  void onModelReady(void Function(bool) callback) {
    this.callback = callback;
  }
}
