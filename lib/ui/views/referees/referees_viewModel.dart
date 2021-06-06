import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/services/database/dataHandlers/profileDataHandler.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:stacked/stacked.dart';

class RefereesViewModel extends BaseViewModel {
  final log = getLogger("RefereesViewModel");
  List<Referee> refereeList = [];
  void onModelReady() {
    setBusy(true);
    List<String> referees = [];
    locator<ProfileDataHandler>()
        .getProfileData(
            typeOfData: ProfileDocument.userPlatformData,
            userId: locator<UserDataProvider>().platformData!.referralCode,
            fromLocalDatabase: false)
        .then((value) {
      referees = value['referredTo'].map<String>((s) => s as String).toList();

      List<Future> futures = [];
      referees.forEach((element) {
        futures.add(locator<ProfileDataHandler>()
            .getProfileData(
                typeOfData: ProfileDocument.userPersonalData,
                userId: element,
                fromLocalDatabase: false)
            .then((data) {
          refereeList.add(Referee(
              referralCode: element,
              contact: data['contact'].toString(),
              email: data['email'].toString(),
              name: data['name'].toString()));
        }));
      });
      Future.wait(futures).whenComplete(() {
        setBusy(false);
        notifyListeners();
      });
    });
  }
}

class Referee {
  String? email = '';
  String? contact = '';
  String? referralCode = '';
  String? name = '';
  Referee({
    required this.referralCode,
    required this.contact,
    required this.email,
    required this.name,
  });
}
