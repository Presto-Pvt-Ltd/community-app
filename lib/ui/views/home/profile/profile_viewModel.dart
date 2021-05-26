import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/models/user/personal_data_model.dart';
import 'package:presto/models/user/platform_data_model.dart';
import 'package:presto/models/user/platform_ratings_data.dart';
import 'package:presto/models/user/transaction_data_model.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:stacked/stacked.dart';

class ProfileViewModel extends BaseViewModel {
  final log = getLogger("ProfileViewModel");
  String title = "I am Profile";
  late void Function(bool) callback;
  UserDataProvider _userDataProvider = locator<UserDataProvider>();
  UserDataProvider get userData => _userDataProvider;
  PersonalData? personalData;
  PlatformData? platformData;
  PlatformRatings? platformRatings;
  TransactionData? transactionData;
  void onModelReady(void Function(bool) callback) {
    setBusy(true);
    this.callback = callback;
    _userDataProvider.gotData.listen((event) {
      if (event) {
        personalData = _userDataProvider.personalData;
        platformData = _userDataProvider.platformData;
        platformRatings = _userDataProvider.platformRatingsData;
        transactionData = _userDataProvider.transactionData;
        notifyListeners();
        setBusy(false);
      }
    });
  }
}
