import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/app/app.router.dart';
import 'package:presto/services/authentication.dart';
import 'package:presto/services/error/error.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../main.dart';

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
      Future.delayed(Duration(seconds: 0), () {
        _authenticationService.uid == null
            ? _navigationService.replaceWith(Routes.loginView)
            : _navigationService.replaceWith(Routes.homeView,
                arguments: HomeViewArguments(index: fromBackground ? 3 : 1));
        if (fromBackground) fromBackground = false;
      });
    } catch (error) {
      log.e("Some error while checking active user");
      _errorHandlingService.handleError(error: error);
    }
  }
}
