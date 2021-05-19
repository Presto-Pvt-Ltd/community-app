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
      Future.delayed(
        Duration(milliseconds: 0),
        () {
          _authenticationService.uid == null
              ? _navigationService.replaceWith(Routes.loginView)
              : _navigationService.replaceWith(Routes.homeView);
        },
      );
    } catch (error) {
      log.e("Some error while checking active user");
      _errorHandlingService.handleError(error: error);
    }
  }
}
