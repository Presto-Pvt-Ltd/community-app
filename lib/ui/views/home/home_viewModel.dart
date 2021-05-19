import 'package:presto/app/app.logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/authentication.dart';

class HomeViewModel extends IndexTrackingViewModel {
  final log = getLogger("HomeViewModel");
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  void onModelReady(int index) {
    Future.delayed(Duration(microseconds: 0), () {
      setIndex(index);
    });
  }

  void slideChangeViews(bool isReverse){
    if(isReverse == false){
      // ignore: unnecessary_statements
      currentIndex != 0 ? setIndex(currentIndex - 1) : null;
      notifyListeners();
    }else {
      // ignore: unnecessary_statements
      currentIndex != 3 ? setIndex(currentIndex + 1) : null;
      notifyListeners();
    }
  }

  void goToLoginScreen() {
    _authenticationService.auth.signOut();
    _navigationService.clearStackAndShow(Routes.loginView);
  }
}
