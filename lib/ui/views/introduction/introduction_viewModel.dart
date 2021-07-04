import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class IntroductionViewModel extends BaseViewModel {
  final log = getLogger("IntroductionViewModel");
  void gotToHomePage(bool isFromDrawer) {
    log.wtf("IS this from drawer : $isFromDrawer");
    isFromDrawer
        ? locator<NavigationService>().back()
        : locator<NavigationService>().clearStackAndShow(Routes.homeView);
  }
}
