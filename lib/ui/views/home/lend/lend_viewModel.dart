import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/models/notification/notification_data_model.dart';
import 'package:presto/services/authentication.dart';
import 'package:presto/services/database/dataHandlers/notificationDataHandler.dart';
import 'package:stacked/stacked.dart';

class LendViewModel extends StreamViewModel {
  final log = getLogger("LendViewModel");
  final NotificationDataHandler _notificationDataHandler =
      locator<NotificationDataHandler>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  List<CustomNotification> notifications = <CustomNotification>[];
  String title = "I am Lend Screen";
  late void Function(bool) callback;

  void onModelReady(void Function(bool) callback) {
    this.callback = callback;
  }

  @override
  void onData(data) {
    if (data is QuerySnapshot) {
      if (data.docs.isNotEmpty) {
        data.docs.forEach((particularDoc) {
          notifications.add(CustomNotification.fromJson(particularDoc.data()));
        });
        notifyListeners();
      }
    }
    super.onData(data);
  }

  @override
  Stream<QuerySnapshot> get stream => _notificationDataHandler.getStream(
      referralCode: _authenticationService.referralCode!);
}
