import 'package:firebase_auth/firebase_auth.dart';
import 'db_service.dart'; // Import the database service

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DbService _dbService = DbService(); // Instantiate the database service

  Future<User?> signInWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    // Sign in with a popup window.
    final UserCredential userCredential =
    await _auth.signInWithPopup(googleProvider);
    final user = userCredential.user;

    // **THE FIX IS HERE:**
    // If the user is successfully signed in, immediately create their profile.
    if (user != null) {
      await _dbService.updateUserProfile(user.uid, {
        'name': user.displayName,
        'email': user.email,
        'photoURL': user.photoURL,
      });
    }

    return user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}