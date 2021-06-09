import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/services/database/dataHandlers/profileDataHandler.dart';
import 'package:presto/services/database/dataProviders/transactions_data_provider.dart';
import 'package:presto/services/error/error.dart';

class CommunityTreeDataHandler {
  final log = getLogger("CommunityTreeDataHandler");

  final ErrorHandlingService _errorHandlingService =
      locator<ErrorHandlingService>();
  final ProfileDataHandler _profileDataHandler = locator<ProfileDataHandler>();

  Future<bool> createNewCommunity({
    required String managerReferralID,
    required String communityName,
    required String token,
  }) async {
    try {
      log.v("Creating community");
      Map<String, Map<String, List<String>>> tempMap = {
        "CM": {
          "GrandParent": [managerReferralID],
          "Parent": [managerReferralID],
          "Members": <String>[],
          "Token": [token].toList(),
        }
      };
      await FirebaseFirestore.instance
          .collection(communityName.trim())
          .doc('1')
          .set({
        managerReferralID: {
          "GrandParent": [managerReferralID],
          "Parent": [managerReferralID],
          "Members": [],
          "Token": [],
        }
      });
      await FirebaseFirestore.instance
          .collection(communityName.trim())
          .doc('Trusted')
          .set({
        "Members": [managerReferralID],
        "Token": [token],
      });
      return await FirebaseFirestore.instance
          .collection(communityName.trim())
          .doc('0')
          .set(tempMap)
          .then((value) async {
        return true;
      });
    } catch (e) {
      log.e("There was error here");
      _errorHandlingService.handleError(error: e);
      return false;
    }
  }

  Future<void> createNewUser({
    required String userReferralID,
    required String parentReferralID,
    required String communityName,
    required String token,
  }) async {
    int level = 0;
    List<String> list = [];
    List<String> tokens = [];
    try {
      log.v("Updating community. Adding new User.");
      log.v(
          "community name $communityName Parent $parentReferralID User $userReferralID");
      await FirebaseFirestore.instance
          .collection(communityName)
          .where("$parentReferralID.Parent", arrayContains: parentReferralID)
          .get()
          .then((value) async {
        if (value.docs.length != 0) {
          level = int.parse(value.docs.first.id);
          log.v('level- $level length-${value.docs.length}');
          await FirebaseFirestore.instance
              .collection(communityName)
              .doc((level).toString())
              .get()
              .then((snap) {
            if (snap.exists) {
              log.wtf(snap.data());
              list = snap
                  .data()![parentReferralID]['Members']
                  .map<String>((s) => s as String)
                  .toList();
              tokens = snap
                  .data()![parentReferralID]['Token']
                  .map<String>((s) => s as String)
                  .toList();
              list.add(userReferralID);
              tokens.add(token);
            } else {
              list.add(userReferralID);
              tokens.add(token);
            }
            FirebaseFirestore.instance
                .collection(communityName)
                .doc((level + 1).toString())
                .get()
                .then((value) {
              if (!value.exists) {
                FirebaseFirestore.instance
                    .collection(communityName)
                    .doc((level + 1).toString())
                    .set({
                  userReferralID: {
                    "GrandParent": [parentReferralID],
                    "Parent": [userReferralID],
                    "Members": [],
                    "Token": []
                  }
                });
              } else {
                FirebaseFirestore.instance
                    .collection(communityName)
                    .doc((level + 1).toString())
                    .update({
                  userReferralID: {
                    "GrandParent": [parentReferralID],
                    "Parent": [userReferralID],
                    "Members": [],
                    "Token": []
                  }
                });
              }
            });
            String grandParent = '';
            _profileDataHandler
                .getProfileData(
                    typeOfData: ProfileDocument.userPlatformData,
                    userId: parentReferralID,
                    fromLocalDatabase: false)
                .then((value) {
              grandParent = value['referredBy'].toString();
              FirebaseFirestore.instance
                  .collection(communityName)
                  .doc((level).toString())
                  .update({
                parentReferralID: {
                  "GrandParent": [grandParent],
                  "Parent": [parentReferralID],
                  "Members": list,
                  "Token": tokens
                }
              });
            });
          });
        }
      });
    } catch (e) {
      log.e("There was error here ");
      _errorHandlingService.handleError(error: e);
    }
  }

  /// [tokens] is the final result. Never Put downCounter more than 1. Only 1 and 0 acceptable.
  Future<void> getLenderNotificationTokens({
    required String currentReferralId,
    required String parentReferralID,
    required int levelCounter,
    required String communityName,
    required int downCounter,
  }) async {
    int level = 0;
    int levelDown = 0;
    List<String>? tokens = [];
    List<String>? lenders = [];
    log.v(
        "Getting Lender Notifications current-$currentReferralId parent- $parentReferralID");
    try {
      return await FirebaseFirestore.instance
          .collection(communityName)
          .where("$parentReferralID.Members", arrayContains: currentReferralId)
          .get()
          .then((value) async {
        if (value.docs.length != 0) {
          level = int.parse(value.docs.first.id);
          levelDown = level;
          for (int i = 0; i <= levelCounter; i++) {
            // log.wtf(
            //     "Level : $level + Run type : ${level.runtimeType} \n i = $i");
            if (level == -1) {
              locator<TransactionsDataProvider>().notificationTokens = tokens;
              locator<TransactionsDataProvider>().lenders = lenders;

              break;
            }
            await FirebaseFirestore.instance
                .collection(communityName)
                .doc(level.toString())
                .get()
                .then((snapshot) async {
              if (snapshot.exists) {
                // log.wtf("Data : " +
                //     snapshot.data().toString() +
                //     "\n" +
                //     DateTime.now().toString() +
                //     "\n$level");
                log.v(
                  snapshot.data()![parentReferralID]["Token"].runtimeType,
                );
                if (!snapshot.data()!.containsKey("CM")) {
                  tokens.addAll(snapshot
                      .data()![parentReferralID]['Token']
                      .map<String>((s) => s as String)
                      .toList());
                  lenders.addAll(snapshot
                      .data()![parentReferralID]['Members']
                      .map<String>((s) => s as String)
                      .toList());
                  // if (i == levelCounter)
                  //   parentReferralID = snapshot
                  //       .data()![parentReferralID]['Parent'][0]
                  //       .toString();
                  // else

                }
                parentReferralID = snapshot
                    .data()![parentReferralID]['GrandParent'][0]
                    .toString();
              }
              if (i == 0) {
                await FirebaseFirestore.instance
                    .collection(communityName)
                    .doc('Trusted')
                    .get()
                    .then((snapshot) {
                  if (snapshot.exists) {
                    if (snapshot.data()!.containsKey('Token'))
                      tokens.addAll(snapshot['Token']
                          .map<String>((s) => s as String)
                          .toList());
                    if (snapshot.data()!.containsKey('Members'))
                      lenders.addAll(snapshot['Members']
                          .map<String>((s) => s as String)
                          .toList());
                  }
                });
              }
              if (i == levelCounter) {
                String tempToken = "";
                await _profileDataHandler
                    .getProfileData(
                  typeOfData: ProfileDocument.userNotificationToken,
                  userId: parentReferralID,
                  fromLocalDatabase: false,
                )
                    .then((value) {
                  tempToken = value['notificationToken'];
                  lenders.add(parentReferralID);
                  tokens.add(tempToken);
                  locator<TransactionsDataProvider>().notificationTokens =
                      tokens;
                  locator<TransactionsDataProvider>().lenders = lenders;
                });
              }
            });
            level--;
          }
          for (int i = 0; i < downCounter; i++) {
            levelDown++;
            FirebaseFirestore.instance
                .collection(communityName)
                .doc(levelDown.toString())
                .get()
                .then((snapshot) {
              if (snapshot.exists) {
                tokens.addAll(snapshot
                    .data()![currentReferralId]['Token']
                    .map<String>((s) => s as String)
                    .toList());
                lenders.addAll(snapshot
                    .data()![currentReferralId]['Members']
                    .map<String>((s) => s as String)
                    .toList());
              }
            });
            if (i == downCounter - 1) {
              locator<TransactionsDataProvider>().notificationTokens = tokens;
              locator<TransactionsDataProvider>().lenders = lenders;
            }
          }
        }
      });
    } catch (e) {
      log.e("There was error here : ${e.runtimeType}");
      _errorHandlingService.handleError(error: e);
    }
  }

  Future<void> updateNotificationTokenInTree({
    required String currentReferralId,
    required String communityName,
    required String newToken,
    required String parentReferralId,
  }) async {
    log.v('Updating token in tree');
    int level = 0;
    int index = 0;
    String parent = '';
    String grandParent = '';
    List<String>? refId = [];
    List<String>? tokens = [];
    await FirebaseFirestore.instance
        .collection(communityName)
        .where("$parentReferralId.Members", arrayContains: currentReferralId)
        .get()
        .then((value) async {
      if (value.docs.length != 0) {
        log.wtf(value.docs.first.data());
        level = int.parse(value.docs.first.id);
        refId = value.docs.first
            .data()[parentReferralId]['Members']
            .map<String>((s) => s as String)
            .toList();
        tokens = value.docs.first
            .data()[parentReferralId]['Token']
            .map<String>((s) => s as String)
            .toList();
        index = refId!.indexOf(currentReferralId);
        tokens![index] = newToken;
        parent =
            value.docs.first.data()[parentReferralId]['Parent'][0].toString();
        grandParent = value.docs.first
            .data()[parentReferralId]['GrandParent'][0]
            .toString();
        FirebaseFirestore.instance
            .collection(communityName)
            .doc(level.toString())
            .update({
          parentReferralId: {
            'GrandParent': [grandParent],
            'Parent': [parent],
            'Members': refId,
            'Token': tokens
          }
        }).then((value) {
          log.v('token updated in Firestore tree');
        });
      }
    });
  }
}
