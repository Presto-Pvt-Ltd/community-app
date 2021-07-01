import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/app/app.router.dart';
import 'package:presto/services/authentication.dart';
import 'package:presto/services/database/dataProviders/transactions_data_provider.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:presto/services/database/hiveDatabase.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfileDetailsViewModel extends BaseViewModel {
  final log = getLogger("ProfileDetailsViewModel");
  String title = "I am ProfileDetailsViewModel";

  void pop() {
    locator<NavigationService>().back();
  }

  void signOut() {
    setBusy(true);
    log.wtf("Hello there mujhe dabaya gaya hai log out hun mai");
    locator<HiveDatabaseService>()
        .deleteBox(uid: locator<AuthenticationService>().uid!)
        .then((value) {
      setBusy(false);

      print("Hello");
      locator<UserDataProvider>().dispose();
      locator<TransactionsDataProvider>().dispose();
      if (value) {
        log.wtf("Signed Out");
        locator<AuthenticationService>().auth.signOut();
        locator<NavigationService>().clearStackAndShow(Routes.loginView);
      } else {
        log.wtf("What just happened");
      }
    });
  }
}
