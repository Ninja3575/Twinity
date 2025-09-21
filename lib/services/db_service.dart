import 'package:cloud_firestore/cloud_firestore.dart';

class DbService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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

  /// **THIS FUNCTION WAS MISSING**
  Future<bool> doesUserExist(String userId) async {
    final userRef = _db.collection('users').doc(userId);
    final doc = await userRef.get();
    return doc.exists;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchUserProfile(String userId) {
    return _db.collection('users').doc(userId).snapshots();
  }
}