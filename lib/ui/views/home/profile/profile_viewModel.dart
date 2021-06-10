import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/app/app.router.dart';
import 'package:presto/models/limits/share_text.dart';
import 'package:presto/models/user/personal_data_model.dart';
import 'package:presto/models/user/platform_data_model.dart';
import 'package:presto/models/user/platform_ratings_data.dart';
import 'package:presto/models/user/transaction_data_model.dart';
import 'package:presto/services/authentication.dart';
import 'package:presto/services/database/dataHandlers/limitsDataHandler.dart';
import 'package:presto/services/database/dataHandlers/profileDataHandler.dart';
import 'package:presto/services/database/dataProviders/transactions_data_provider.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:presto/services/database/hiveDatabase.dart';
import 'package:share/share.dart';
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
      );
  PlatformData platformData = locator<UserDataProvider>().platformData ??
      PlatformData(
        disabled: false,
        referralCode: "...",
        referredBy: "...",
        referredTo: <String>[],
        community: "....",
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
    locator<HiveDatabaseService>()
        .deleteBox(uid: locator<AuthenticationService>().uid!)
        .then((value) {
      locator<UserDataProvider>().dispose();
      locator<TransactionsDataProvider>().dispose();
      if (value) {
        locator<AuthenticationService>().auth.signOut();
        locator<NavigationService>().clearStackAndShow(Routes.loginView);
      } else {
        log.wtf("What just happened");
      }
    });
  }

  Future<String> getShareText() async {
    return await locator<LimitsDataHandler>()
        .getLimitsData(
          typeOfLimit: LimitDocument.shareText,
          fromLocalDatabase: false,
        )
        .then(
          (value) => ShareText.fromJson(value).text,
        );
  }

  void goToMyReferees() {
    setBusy(true);
    locator<ProfileDataHandler>()
        .getProfileData(
      typeOfData: ProfileDocument.userPlatformData,
      userId: locator<UserDataProvider>().platformData!.referralCode,
      fromLocalDatabase: false,
    )
        .then((value) {
      PlatformData platformData = PlatformData.fromJson(value);
      locator<UserDataProvider>().platformData = platformData;
      locator<ProfileDataHandler>().updateProfileData(
        data: platformData.toJson(),
        typeOfDocument: ProfileDocument.userPlatformData,
        userId: locator<UserDataProvider>().platformData!.referralCode,
        toLocalDatabase: true,
      );
    }).whenComplete(() {
      locator<NavigationService>().navigateTo(Routes.refereesView);
      setBusy(false);
    });
  }
}
