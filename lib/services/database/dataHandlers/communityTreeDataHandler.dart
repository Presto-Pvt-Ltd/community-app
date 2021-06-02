import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/services/database/dataProviders/transactions_data_provider.dart';
import 'package:presto/services/error/error.dart';

class CommunityTreeDataHandler {
  final log = getLogger("CommunityTreeDataHandler");

  final ErrorHandlingService _errorHandlingService =
      locator<ErrorHandlingService>();

  Future<bool> createNewCommunity({
    required String managerReferralID,
    required String communityName,
    required String token,
  }) async {
    try {
      log.v("Creating community");
      Map<String, List<String>> tempMap = {
        "Members": [managerReferralID].toList(),
        "Token": [token].toList(),
      };
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
          .where('Members', arrayContains: parentReferralID)
          .get()
          .then((value) async {
        if (value.docs.length != 0) {
          level = int.parse(value.docs.first.id);
          log.v('level- $level');
          await FirebaseFirestore.instance
              .collection(communityName)
              .doc((level + 1).toString())
              .get()
              .then((snap) {
            if (snap.exists) {
              list = snap['Members'].map<String>((s) => s as String).toList();
              tokens = snap['Token'].map<String>((s) => s as String).toList();
              list.add(userReferralID);
              tokens.add(token);
            } else {
              list.add(userReferralID);
              tokens.add(token);
            }
            FirebaseFirestore.instance
                .collection(communityName)
                .doc((level + 1).toString())
                .set({"Members": list, "Token": tokens});
          });
        }
      });
    } catch (e) {
      log.e("There was error here ");
      _errorHandlingService.handleError(error: e);
    }
  }

  /// [tokens] is the final result stored in [finalTokenListForLenders].
  Future<void> getLenderNotificationTokens({
    required currentReferralId,
    required int levelCounter,
    required String communityName,
    required int downCounter,
  }) async {
    int level = 0;
    int levelDown = 0;
    List<String>? tokens = [];
    List<String>? lenders = [];
    log.v("Getting Lender Notifications");
    try {
      return await FirebaseFirestore.instance
          .collection(communityName)
          .where('Members', arrayContains: currentReferralId)
          .get()
          .then((value) async {
        if (value.docs.length != 0) {
          level = int.parse(value.docs.first.id);
          levelDown = level;
          for (int i = 0; i <= levelCounter - 1; i++) {
            if (level == -1) {
              locator<TransactionsDataProvider>().notificationTokens = tokens;
              locator<TransactionsDataProvider>().lenders = lenders;
              break;
            }
            FirebaseFirestore.instance
                .collection(communityName)
                .doc(level.toString())
                .get()
                .then((snapshot) {
              if (snapshot.exists) {
                if (snapshot.data()!.containsKey('Token'))
                  tokens.addAll(snapshot
                      .data()!['Token']
                      .map<String>((s) => s as String)
                      .toList());
                if (snapshot.data()!.containsKey('Members'))
                  lenders.addAll(snapshot
                      .data()!['Members']
                      .map<String>((s) => s as String)
                      .toList());
              }
              if (i == 0) {
                FirebaseFirestore.instance
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
            });
            level--;
            if (i == levelCounter) {
              locator<TransactionsDataProvider>().notificationTokens = tokens;
              locator<TransactionsDataProvider>().lenders = lenders;
            }
          }
          for (int i = 0; i < downCounter; i++) {
            levelDown++;
            FirebaseFirestore.instance
                .collection(communityName)
                .doc(levelDown.toString())
                .get()
                .then((snapshot) {
              if (snapshot.exists) {
                if (snapshot.data()!.containsKey('Token'))
                  tokens.addAll(snapshot
                      .data()!['Token']
                      .map<String>((s) => s as String)
                      .toList());
                if (snapshot.data()!.containsKey('Members'))
                  tokens.addAll(snapshot
                      .data()!['Members']
                      .map<String>((s) => s as String)
                      .toList());
              }
            });
            levelDown++;
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
}
