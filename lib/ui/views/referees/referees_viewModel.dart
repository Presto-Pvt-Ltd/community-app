import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/models/user/platform_ratings_data.dart';
import 'package:presto/services/database/dataHandlers/profileDataHandler.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RefereesViewModel extends BaseViewModel {
  final log = getLogger("RefereesViewModel");
  List<Referee> refereeList = [];
  void onModelReady() {
    setBusy(true);
    List<String> referees =
        locator<UserDataProvider>().platformData!.referredTo;
    List<Future> futures = [];
    referees.forEach((element) {
      futures.add(locator<ProfileDataHandler>()
          .getProfileData(
        typeOfData: ProfileDocument.userPersonalData,
        userId: element,
        fromLocalDatabase: false,
      )
          .then((data) async {
        var value = await locator<ProfileDataHandler>().getProfileData(
          typeOfData: ProfileDocument.userPlatformRatings,
          userId: element,
          fromLocalDatabase: false,
        );
        PlatformRatings rating = PlatformRatings.fromJson(value);
        refereeList.add(Referee(
            referralCode: element,
            contact: data['contact'].toString(),
            email: data['email'].toString(),
            name: data['name'].toString(),
            score: (rating.communityScore + rating.personalScore) / 2));
      }));
    });
    Future.wait(futures).whenComplete(() {
      setBusy(false);
      notifyListeners();
    });
  }

  void pop() {
    locator<NavigationService>().back();
  }
}

class Referee {
  String? email = '';
  String? contact = '';
  String? referralCode = '';
  String? name = '';
  double? score;
  Referee(
      {required this.referralCode,
      required this.contact,
      required this.email,
      required this.name,
      required this.score});
}
