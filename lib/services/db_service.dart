import 'package:cloud_firestore/cloud_firestore.dart';

class DbService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // This function now handles creating a user with default points
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    final userRef = _db.collection('users').doc(userId);
    final doc = await userRef.get();

    if (!doc.exists) {
      // If user is new, create document with default points and partner code
      await userRef.set({
        ...data,
        'points': 0,
        'partnerCode': userId.substring(0, 6).toUpperCase(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      // If user exists, just update their info
      await userRef.update(data);
    }
  }

  // This function remains for general updates
  Future<void> setUserProfile(String userId, Map<String, dynamic> data) async {
    await _db.collection('users').doc(userId).set(data, SetOptions(merge: true));
  }


  Stream<DocumentSnapshot<Map<String, dynamic>>> watchUserProfile(String userId) {
    return _db.collection('users').doc(userId).snapshots();
  }
}