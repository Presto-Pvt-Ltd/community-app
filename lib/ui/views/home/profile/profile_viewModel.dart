import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/models/limits/share_text.dart';

import 'package:presto/services/database/dataHandlers/limitsDataHandler.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:presto/services/database/firestoreBase.dart';
import 'package:presto/ui/widgets/dialogBox.dart';
import 'package:stacked/stacked.dart';

class ProfileViewModel extends BaseViewModel {
  final log = getLogger("ProfileViewModel");
  String title = "I am Profile";
  late void Function(bool) callback;
  void onModelReady(void Function(bool) callback) {
    this.callback = callback;
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

  void redeemCode(double height, double width) {
    try {
      FirebaseAnalytics().logEvent(name: "Tried Redeeming Presto coins");
      if (locator<UserDataProvider>().platformRatingsData!.prestoCoins >=
          1000) {
        showCustomConfirmationDialog(
          title: "Confirmation",
          description: "Are you sure you want to redeem coins.",
          confirmTitle: "YES",
          cancelTitle: "NO",
          confirmCallback: () async {
            setBusy(true);
            QuerySnapshot? querySnapshot =
                await locator<FirestoreService>().getCollection(
              collection: "redeemCode",
            );
            if (querySnapshot == null || querySnapshot.docs.length == 0) {
              showCustomDialog(
                title: "Error",
                description:
                    "Sorry ! :(\nCurrently there are no redeemable codes present. Please try again later.",
              );
              setBusy(false);
            } else {
              await locator<FirestoreService>().deleteData(
                document: FirebaseFirestore.instance
                    .collection("redeemCode")
                    .doc(querySnapshot.docs[0].id),
              );
              showCustomDialog(
                title: "Code Redeemed",
                description:
                    "Your Code is : ${querySnapshot.docs[0].id}\n Please Take a screenshot and show the code to vendor",
              );
              setBusy(false);
            }

            /// do redeem
          },
          cancelCallback: () {},
        );
      } else {
        return showCustomDialog(
          title: "Not Enough Coins",
          description: "You do not have enough Presto Coins to redeem",
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
