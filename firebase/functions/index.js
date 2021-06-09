// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.

// The Firebase Admin SDK to access Firestore.

const admin = require("firebase-admin");
const functions = require("firebase-functions");
admin.initializeApp();
const db = admin.firestore();

var timeOut = 21600000;

exports.sendPushNotification = functions.https.onCall((data, context) => {
  try {
    for (var i = 0; i < data.length; i++) {
      console.log("Sending notification to" + data[i]);
      admin
        .messaging()
        .send({
          notification: {
            title: "Assistance Required",
            body: "Someone in your community requires your financial help!! Open the presto app to find out more.",
          },

          android: {
            ttl: timeOut,
            priority: "high",
          },
          apns: {
            payload: {
              aps: {
                badge: 42,
              },
            },
          },
          token: data[i],
        })
        .then((response) => {
          // Response is a message ID string.
          console.log("Successfully sent message:", response);
        })
        .catch((error) => {
          console.log("Error sending message:", error);
        });
    }
  } catch (error) {
    console.log(error);
  }
});

exports.sendCompletionNotification = functions.https.onCall((data, context) => {
  try {
    var object = JSON.parse(data);
    console.log("Sending notification to token: " + object.token);
    console.log("Sending notification to title: " + object.title);
    console.log("Sending notification to body: " + object.body);
    admin
      .messaging()
      .send({
        notification: {
          title: object.title,
          body: object.body,
        },
        android: {
          ttl: timeOut,
          priority: "high",
        },
        apns: {
          payload: {
            aps: {
              badge: 42,
            },
          },
        },
        token: object.token,
      })
      .then((response) => {
        // Response is a message ID string.
        console.log("Successfully sent message:", response);
      })
      .catch((error) => {
        console.log("Error sending message:", error);
      });
  } catch (error) {
    console.log(error);
  }
});

exports.updateCommunityScores = functions.https.onCall((data, context) => {
  try {
    var object = JSON.parse(data);
    var isReward = object.isReward;
    var changeInChild = object.changeInChild;
    var parentId = object.parentId;
    updateParentData(parentId, changeInChild, isReward);
  } catch (error) {
    console.log(error);
  }
});
exports.updateCommunityScoresWithoutAsync = functions.https.onCall(
  (data, context) => {
    try {
      var object = JSON.parse(data);
      var isReward = object.isReward;
      var changeInChild = object.changeInChild;
      var parentId = object.parentId;
      updateParentDataWithoutAsync(parentId, changeInChild, isReward);
    } catch (error) {
      console.log(error);
    }
  }
);

async function updateParentData(parentId, changeInChild, isReward) {
  try {
    // get parent's platform data
    var parentPlatformDataSnapshot = await db
      .collection("users")
      .doc(parentId)
      .collection("userPlatformData")
      .doc("userPlatformData")
      .get();
    // get parent's platform ratings data

    var parentPlatformRatingsDataSnapshot = await db
      .collection("users")
      .doc(parentId)
      .collection("userPlatformRatings")
      .doc("userPlatformRatings")
      .get();
    var parentPlatformData = parentPlatformDataSnapshot.data();
    var parentPlatformRatingsData = parentPlatformRatingsDataSnapshot.data();
    var totalReferees = parentPlatformData.referredTo.length * 2;
    // Update community score
    console.log("Objects for platform Data: " + parentPlatformData);
    console.log(
      "Objects for platform Ratings Data: " + parentPlatformRatingsData
    );
    var newChangeInChild;
    if (isReward) {
      parentPlatformRatingsData.communityScore =
        parentPlatformRatingsData.communityScore +
        changeInChild / totalReferees;
      newChangeInChild = changeInChild / totalReferees;
    } else {
      parentPlatformRatingsData.communityScore =
        parentPlatformRatingsData.communityScore -
        changeInChild / totalReferees;
      newChangeInChild = changeInChild / totalReferees;
    }
    console.log("Doc changed: " + parentId);
    console.log("Changed By value: " + newChangeInChild);
    var grandParentId = parentPlatformData.referredBy;
    // Update parent data
    db.collection("users")
      .doc(parentId)
      .collection("userPlatformRatings")
      .doc("userPlatformRatings")
      .update({
        communityScore: parentPlatformRatingsData.communityScore,
      });
    if (grandParentId != "CM") {
      updateParentData(grandParentId, newChangeInChild, isReward);
    }
  } catch (e) {
    console.log(e);
  }
}
function updateParentDataWithoutAsync(parentId, changeInChild, isReward) {
  try {
    // get parent's platform data
    db.collection("users")
      .doc(parentId)
      .collection("userPlatformData")
      .doc("userPlatformData")
      .get()
      .then((parentPlatformDataSnapshot) => {
        // get parent's platform ratings data
        var parentPlatformData = parentPlatformDataSnapshot.data();
        db.collection("users")
          .doc(parentId)
          .collection("userPlatformRatings")
          .doc("userPlatformRatings")
          .get()
          .then((parentPlatformRatingsDataSnapshot) => {
            var parentPlatformRatingsData =
              parentPlatformRatingsDataSnapshot.data();
            var totalReferees = parentPlatformData.referredTo.length * 2;
            console.log("Objects for platform Data: " + parentPlatformData);
            console.log(
              "Objects for platform Ratings Data: " + parentPlatformRatingsData
            );
            // Update community score.
            var newChangeInChild;
            if (isReward) {
              parentPlatformRatingsData.communityScore =
                parentPlatformRatingsData.communityScore +
                changeInChild / totalReferees;
              newChangeInChild = changeInChild / totalReferees;
            } else {
              parentPlatformRatingsData.communityScore =
                parentPlatformRatingsData.communityScore -
                changeInChild / totalReferees;
              newChangeInChild = changeInChild / totalReferees;
            }
            console.log("Doc changed: " + parentId);
            console.log("Changed By value: " + newChangeInChild);
            // updating grandparent
            var grandParentId = parentPlatformData.referredBy;
            // Update parent data
            db.collection("users")
              .doc(parentId)
              .collection("userPlatformRatings")
              .doc("userPlatformRatings")
              .update({
                communityScore: parentPlatformRatingsData.communityScore,
              });
            if (grandParentId != "CM") {
              updateParentData(grandParentId, newChangeInChild, isReward);
            }
          });
      });
  } catch (e) {
    console.log(e);
  }
}

//exports.banUser = functions.https.onCall((uid, context) => {
//  admin
//    .auth()
//    .updateUser(uid, {
//      disabled: true,
//    })
//    .catch((error) => {
//      console.log("Error updating user:", error);
//    });
//});
