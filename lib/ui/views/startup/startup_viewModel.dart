import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/app/app.router.dart';
import 'package:presto/services/authentication.dart';
import 'package:presto/services/error/error.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StartUpViewModel extends BaseViewModel {
  final log = getLogger("StartUpViewModel");
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final ErrorHandlingService _errorHandlingService =
      locator<ErrorHandlingService>();
  final NavigationService _navigationService = locator<NavigationService>();

  void onModelReady() {
    try {
      log.d("Checking for active user");
      // MethodChannel _channel = MethodChannel("com.presto.org");
      // var result = _channel
      //     .invokeMethod<String>('checkNotificationPermissions')
      //     .whenComplete(() {
      //   log.wtf("Helo");
      // });
      // log.wtf(result.toString());
      // print("\n\n\n\n");
      // result.then((value) {
      //   log.wtf("Value: $value");
      //   if (value != "ALL_CLEAR") {
      //     locator<DialogService>()
      //         .showDialog(
      //       title: "Please enable Notification",
      //       description:
      //           "Please Enable Notification sound and floating Notifications for great experience",
      //       buttonTitle: "Proceed",
      //       buttonTitleColor: Colors.black,
      //     )
      //         .then((value) {
      //       _channel.invokeMapMethod('checkAndGetNotificationPermissions');
      //     });
      //   }
      //
      // });
      Future.delayed(Duration(seconds: 0), () {
        // flutterLocalNotificationsPlugin.show(
        //   12,
        //   "vweaefwa",
        //   "fwefawef ",
        //   NotificationDetails(
        //     android: AndroidNotificationDetails(
        //       "presto_borrowing_channel_test_1",
        //       "Presto Custom Notification Test 2",
        //       "Desiogniealnvelkvs",
        //       importance: Importance.high,
        //       priority: Priority.high,
        //       enableLights: true,
        //       playSound: true,
        //       enableVibration: true,
        //     ),
        //   ),
        // );
        _authenticationService.uid == null
            ? _navigationService.replaceWith(Routes.loginView)
            : _navigationService.replaceWith(Routes.homeView);
      });
    } catch (error) {
      log.e("Some error while checking active user");
      _errorHandlingService.handleError(error: error);
    }
  }
}
