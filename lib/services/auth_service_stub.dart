import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<User?> signInWithGoogle() async {
    throw UnsupportedError('Google Sign-In is not supported on this platform');
  }

  Future<void> signOut() async {}

  Stream<User?> get authStateChanges => const Stream.empty();
}


