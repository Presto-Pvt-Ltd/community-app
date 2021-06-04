import 'package:presto/models/notification/notification_data_model.dart';
import 'package:stacked/stacked.dart';

class NotificationViewModel extends BaseViewModel {
  ///Paste your code here
  late final CustomNotification notification;
  void onModelReady(CustomNotification notification) {
    this.notification = notification;
  }
}
