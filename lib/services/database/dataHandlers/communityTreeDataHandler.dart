import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/services/database/dataHandlers/limitsDataHandler.dart';
import 'package:presto/services/database/dataHandlers/profileDataHandler.dart';
import 'package:presto/services/error/error.dart';

class CommunityTreeDataHandler {
  final log = getLogger("CommunityTreeDataHandler");

  final ErrorHandlingService _errorHandlingService =
      locator<ErrorHandlingService>();
  final ProfileDataHandler _profileDataHandler = locator<ProfileDataHandler>();
  final LimitsDataHandler _limitsDataHandler = locator<LimitsDataHandler>();
  List<String>? finalTokenListForLenders = [];

  Future<bool> createNewCommunity({
    required String managerReferralID,
    required String communityName,
  }) async {
    try {
      log.v("Creating community");
      Map<String, List<String>> tempMap = {
        "Members": [managerReferralID]
      };
      return await FirebaseFirestore.instance
          .collection(communityName.trim())
          .doc('0')
          .set(tempMap)
          .then((value) => true);
    } catch (e) {
      _errorHandlingService.handleError(error: e);
      return false;
    }
  }

  Future<void> createNewUser({
    required String userReferralID,
    required String parentReferralID,
  }) async {
    String communityName = '';
    int level = 0;
    List<String> list = [];
    try {
      log.v("Updating community. Adding new User.");
      await _profileDataHandler
          .getProfileData(
              typeOfData: ProfileDocument.userPersonalData,
              userId: parentReferralID,
              fromLocalDatabase: false)
          .then((value) => () async {
                communityName = value['community'].toString();
                await FirebaseFirestore.instance
                    .collection(communityName)
                    .where('Members', arrayContains: parentReferralID)
                    .get()
                    .then((value) => () async {
                          level = int.parse(value.docs.first.id);
                          value.docs
                              .getRange(level + 1, level + 1)
                              .forEach((element) async {
                            if (element.exists) {
                              list = element
                                  .data()['Members']
                                  .map<String>((s) => s as String)
                                  .toList();
                              list.add(userReferralID);
                              await FirebaseFirestore.instance
                                  .collection(communityName)
                                  .doc((level + 1).toString())
                                  .set({"Members": list});
                            }
                          });
                        });
              });
    } catch (e) {
      _errorHandlingService.handleError(error: e);
    }
  }

  /// [tokens] is the final result stored in [finalTokenListForLenders].
  Future<void> getLenderNotificationTokens({required currentReferralId}) async {
    String communityName = '';
    int level = 0;
    List<String>? list = [];
    List<String>? tokens = [];
    int levelCounter = 0;
    try {
      log.v("Getting Lender Notifications");
      await _limitsDataHandler
          .getLimitsData(
              typeOfLimit: LimitDocument.transactionLimits,
              fromLocalDatabase: false)
          .then((value) => () async {
                levelCounter = int.parse(value['levelCounter'].toString());
                await _profileDataHandler
                    .getProfileData(
                        typeOfData: ProfileDocument.userPersonalData,
                        userId: currentReferralId,
                        fromLocalDatabase: false)
                    .then((value) => () async {
                          communityName = value['community'].toString();
                          await FirebaseFirestore.instance
                              .collection(communityName)
                              .where('Members',
                                  arrayContains: currentReferralId)
                              .get()
                              .then((value) => () {
                                    level = int.parse(value.docs.first.id);
                                    value.docs
                                        .getRange(level, level - levelCounter)
                                        .forEach((element) {
                                      if (element.exists) {
                                        list = element
                                            .data()['Members']
                                            .map<String>((s) => s as String)
                                            .toList();
                                        list!.forEach((refId) {
                                          _profileDataHandler
                                              .getProfileData(
                                                  typeOfData: ProfileDocument
                                                      .userNotificationToken,
                                                  userId: refId,
                                                  fromLocalDatabase: false)
                                              .then((tokenMap) => () {
                                                    tokens.add(tokenMap[
                                                        'notificationToken']);
                                                  });
                                        });
                                      }
                                    });
                                    FirebaseFirestore.instance
                                        .collection(communityName)
                                        .doc('Trusted')
                                        .get()
                                        .then((snapshot) => () {
                                              if (snapshot.exists) {
                                                list = snapshot
                                                    .data()!['Members']
                                                    .map<String>(
                                                        (s) => s as String)
                                                    .toList();
                                                list!.forEach((refId) {
                                                  _profileDataHandler
                                                      .getProfileData(
                                                          typeOfData:
                                                              ProfileDocument
                                                                  .userNotificationToken,
                                                          userId: refId,
                                                          fromLocalDatabase:
                                                              false)
                                                      .then((tokenMap) => () {
                                                            tokens.add(tokenMap[
                                                                'notificationToken']);
                                                          });
                                                });
                                              }
                                            });
                                  });
                        });
              })
          .whenComplete(() => () {
                log.v('Notification token list created');
                finalTokenListForLenders = tokens;
              });
    } catch (e) {
      _errorHandlingService.handleError(error: e);
    }
  }
}
