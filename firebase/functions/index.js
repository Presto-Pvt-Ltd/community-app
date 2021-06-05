// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.

// The Firebase Admin SDK to access Firestore.

const admin = require("firebase-admin");
const functions = require("firebase-functions");
admin.initializeApp();

// var payload = {
//   notification: {
//     title: "Assistance Required",
//     body: "Someone in your community requires your financial help!! Open the presto app to find out more.",
//   },
//   android: {
//     notification: {
//       sound: "default",
//       ttl: 21600000,
//     },
//     channel_id: "presto_borrowing_channel",
//     priority: "high",
//   },
//   apns: {
//     payload: {
//       aps: {
//         sound: "default",
//       },
//     },
//   },
// };
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
            // channel_id: "presto_borrowing_channel",
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
    // admin
    //   .messaging()
    //   .sendToDevice(data, payload)
    //   .then((response) => {
    //     console.log(response);
    //   })
    //   .catch((error) => {
    //     console.log(error.message);
    //   });
  } catch (error) {
    console.log(error);
  }
});

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
//
//exports.paymentButtonPressed = functions.https.onCall((transID, context) => {
//  var timerRun;
//  function myTimer(arg) {
//    console.log("arg was => ${arg}");
//    timerRun = setTimeout(function () {
//      console.log("Timer has finished");
//    }, 21600000);
//  }
//
//  function stopTimer() {
//    clearTimeout(timerRun);
//  }
//
//  var transData;
//
//  myTimer("myArg");
//
//  firestore
//    .collection("notifications")
//    .doc(transID)
//    .get()
//    .then((doc) => {
//      transData = doc.data;
//    });
//
//  if (transData.approvedStatus) {
//    stopTimer();
//  } else {
//    transData.completionDate = null;
//  }
//});
