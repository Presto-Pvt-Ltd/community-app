import 'package:presto/app/app.logger.dart';
import 'package:stacked/stacked.dart';

class NotificationsViewModel extends BaseViewModel {
  final log = getLogger("NotificationsViewModel");
  String title = "I am Notifications";
  late void Function(bool) callback;

  void onModelReady(void Function(bool) callback) {
    this.callback = callback;
  }
}
