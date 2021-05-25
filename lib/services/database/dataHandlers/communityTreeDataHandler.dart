import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/services/database/dataHandlers/profileDataHandler.dart';
import 'package:presto/services/error/error.dart';

class CommunityTreeDataHandler {
  final log = getLogger("CommunityTreeDataHandler");

  final ErrorHandlingService _errorHandlingService =
      locator<ErrorHandlingService>();
  final ProfileDataHandler _profileDataHandler = locator<ProfileDataHandler>();

  Future<bool> createNewCommunity(
      {required String managerReferralID,
      required String communityName}) async {
    try {
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

  Future<void> createNewUser(
      {required String userReferralID,
      required String parentReferralID}) async {
    String communityName = '';
    String level = '';
    List<String> list = [];
    try {
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
                          level = value.docs.first.id;
                          list = value.docs.first
                              .data()['Members']
                              .map<String>((s) => s as String)
                              .toList();
                          list.add(userReferralID);
                          await FirebaseFirestore.instance
                              .collection(communityName)
                              .doc(level)
                              .set({"Members": list});
                        });
              });
    } catch (e) {
      _errorHandlingService.handleError(error: e);
    }
  }
}
