const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.addPoints = functions.firestore
  .document("activities/{activityId}")
  .onCreate(async (snap, context) => {
    const data = snap.data();
    const coupleId = data.coupleId;
    const points = data.points;

    const coupleRef = admin.firestore().collection("couples").doc(coupleId);
    await coupleRef.update({
      score: admin.firestore.FieldValue.increment(points),
    });
  });

exports.hello = functions.https.onCall(async (data, context) => {
  const name = data && data.name ? data.name : 'World';
  return { message: `Hello, ${name}!` };
});
