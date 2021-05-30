import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/main.dart';
import 'package:presto/models/user/personal_data_model.dart';
import 'package:presto/models/user/platform_data_model.dart';
import 'package:presto/models/user/platform_ratings_data.dart';
import 'package:presto/models/user/transaction_data_model.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:stacked/stacked.dart';

class ProfileViewModel extends StreamViewModel {
  final log = getLogger("ProfileViewModel");
  String title = "I am Profile";
  late void Function(bool) callback;
  UserDataProvider _userDataProvider = locator<UserDataProvider>();
  UserDataProvider get userData => _userDataProvider;
  late PersonalData personalData;
  late PlatformData platformData;
  late PlatformRatings platformRatings;
  late TransactionData transactionData;
  bool gotData = false;
  void onModelReady(void Function(bool) callback) {
    this.callback = callback;
  }

  @override
  bool get dataReady => gotData;

  @override
  void onData(event) {
    super.onData(event);
    log.w("There are updates in User Stream : $event");
    if (event) {
      personalData = _userDataProvider.personalData!;
      platformData = _userDataProvider.platformData!;
      platformRatings = _userDataProvider.platformRatingsData!;
      transactionData = _userDataProvider.transactionData!;
      gotData = true;
      log.w("Data in User Stream : ${personalData.toJson()}");
    }
  }

  @override
  Stream<bool> get stream => gotUserDataStreamController.stream;
}
