import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/services/database/dataHandlers/limitsDataHandler.dart';
import 'package:presto/services/database/dataHandlers/profileDataHandler.dart';
import 'package:presto/services/error/error.dart';

class CommunityTreeDataHandler {
  final log = getLogger("CommunityTreeDataHandler");

  late bool nextLevelExits;

  final ErrorHandlingService _errorHandlingService =
      locator<ErrorHandlingService>();
  final ProfileDataHandler _profileDataHandler = locator<ProfileDataHandler>();
  final LimitsDataHandler _limitsDataHandler = locator<LimitsDataHandler>();

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
      });
    } catch (e) {
      _errorHandlingService.handleError(error: e);
    }
  }

  /// [tokens] is the final result stored in [finalTokenListForLenders].
  Future<List<String>> getLenderNotificationTokens(
      {required currentReferralId,
      required int levelCounter,
      required String communityName}) async {
    int level = 0;
    List<String>? tokens = [];
    log.v("Getting Lender Notifications");
    try {
      return await FirebaseFirestore.instance
          .collection(communityName)
          .where('Members', arrayContains: currentReferralId)
          .get()
          .then((value) async {
        level = int.parse(value.docs.first.id);
        value.docs.getRange(level - 1, level - levelCounter).forEach((element) {
          if (element.exists) {
            tokens.addAll(element
                .data()['Token']
                .map<String>((s) => s as String)
                .toList());
          }
        });
        return await FirebaseFirestore.instance
            .collection(communityName)
            .doc('Trusted')
            .get()
            .then((snapshot) {
          if (snapshot.exists) {
            tokens.addAll(
                snapshot['Token'].map<String>((s) => s as String).toList());
            return tokens;
          } else
            return <String>[];
        });
      });
    } catch (e) {
      _errorHandlingService.handleError(error: e);
      return <String>[];
    }
  }
}
