import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/app/app.router.dart';
import 'package:presto/models/user/personal_data_model.dart';
import 'package:presto/models/user/platform_data_model.dart';
import 'package:presto/models/user/platform_ratings_data.dart';
import 'package:presto/models/user/transaction_data_model.dart';
import 'package:presto/services/authentication.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfileViewModel extends BaseViewModel {
  final log = getLogger("ProfileViewModel");
  String title = "I am Profile";
  late void Function(bool) callback;
  UserDataProvider _userDataProvider = locator<UserDataProvider>();
  UserDataProvider get userData => _userDataProvider;
  PersonalData personalData = locator<UserDataProvider>().personalData ??
      PersonalData(
        name: "...",
        email: "...",
        contact: "...",
        password: "...",
        deviceId: "...",
        referralId: "...",
        community: "...",
      );
  PlatformData platformData = locator<UserDataProvider>().platformData ??
      PlatformData(
        referralCode: "...",
        referredBy: "...",
        referredTo: <String>[],
        isCommunityManager: false,
      );
  PlatformRatings platformRatings =
      locator<UserDataProvider>().platformRatingsData ??
          PlatformRatings(
            communityScore: 0.0,
            personalScore: 0.0,
            prestoCoins: 0,
          );
  TransactionData transactionData =
      locator<UserDataProvider>().transactionData ??
          TransactionData(
            paymentMethodsUsed: <String, dynamic>{},
            transactionIds: <String>[],
            totalBorrowed: 0,
            totalLent: 0,
            activeTransactions: <String>[],
          );
  bool gotData = false;
  void onModelReady(void Function(bool) callback) {
    this.callback = callback;
  }

  void signOut() {
    locator<AuthenticationService>().auth.signOut();
    locator<NavigationService>().clearStackAndShow(Routes.loginView);
  }
}
