import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
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
import 'package:presto/services/database/firestoreBase.dart';
import 'package:presto/services/database/hiveDatabase.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/widgets/dialogBox.dart';
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



  void redeemCode(double height, double width) {
    try {
      FirebaseAnalytics().logEvent(name: "Tried Redeeming Presto coins");
      if (locator<UserDataProvider>().platformRatingsData!.prestoCoins >=
          1000) {
        showDialog(
          barrierDismissible: false,
          context: StackedService.navigatorKey!.currentContext!,
          builder: (context) {
            return AlertDialog(
              title: Text("Confirmation"),
              content: Text(
                "Are you sure you want to redeem coins.",
              ),
              actions: [
                Container(
                  height: height * 0.05,
                  width: width * 0.22,
                  color: Colors.white24,
                  child: MaterialButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Container(
                  height: height * 0.05,
                  width: width * 0.22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: MaterialButton(
                    color: primaryLightSwatch[900],
                    child: Text(
                      "Proceed",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      setBusy(true);
                      Navigator.of(context).pop();
                      QuerySnapshot? querySnapshot =
                          await locator<FirestoreService>().getCollection(
                        collection: "redeemCode",
                      );
                      if (querySnapshot == null ||
                          querySnapshot.docs.length == 0) {
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
                  ),
                ),
              ],
            );
          },
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
