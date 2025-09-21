import 'package:cloud_firestore/cloud_firestore.dart';

class DbService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// This function now correctly creates a user profile if one doesn't exist.
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    final userRef = _db.collection('users').doc(userId);
    final doc = await userRef.get();

    if (!doc.exists) {
      // If the user is new, create their document with default values.
      await userRef.set({
        ...data,
        'points': 0, // Start with 0 points
        'partnerCode': userId.substring(0, 6).toUpperCase(),
        'createdAt': FieldValue.serverTimestamp(), // Good practice to timestamp
      });
    } else {
      // If the user already exists, just update their information.
      await userRef.update(data);
    }
  }

  /// This function can be used for general-purpose updates.
  Future<void> setUserProfile(String userId, Map<String, dynamic> data) async {
    await _db.collection('users').doc(userId).set(data, SetOptions(merge: true));
  }

  /// This function streams the user's profile data for real-time updates.
  Stream<DocumentSnapshot<Map<String, dynamic>>> watchUserProfile(String userId) {
    return _db.collection('users').doc(userId).snapshots();
  }
}