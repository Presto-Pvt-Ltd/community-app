import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/services/authentication.dart';
import 'package:presto/services/database/dataHandlers/notificationDataHandler.dart';
import 'package:stacked/stacked.dart';

class LendViewModel extends StreamViewModel {
  final log = getLogger("LendViewModel");
  final NotificationDataHandler _notificationDataHandler =
      locator<NotificationDataHandler>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  String title = "I am Lend Screen";
  late void Function(bool) callback;

  void onModelReady(void Function(bool) callback) {
    this.callback = callback;
  }

  @override
  Stream get stream => _notificationDataHandler.getStream(
      referralCode: _authenticationService.uid!);
}
