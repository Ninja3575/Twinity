import 'package:cloud_firestore/cloud_firestore.dart';

class DbService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    final userRef = _db.collection('users').doc(userId);
    final doc = await userRef.get();

    if (!doc.exists) {
      await userRef.set({
        ...data,
        'points': 0,
        'partnerCode': userId.substring(0, 6).toUpperCase(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      await userRef.update(data);
    }
  }

  Future<bool> doesUserExist(String userId) async {
    final userRef = _db.collection('users').doc(userId);
    final doc = await userRef.get();
    return doc.exists;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchUserProfile(String userId) {
    return _db.collection('users').doc(userId).snapshots();
  }
}