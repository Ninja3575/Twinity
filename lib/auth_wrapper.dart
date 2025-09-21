import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twinity/screens/login_screen.dart';
import 'package:twinity/screens/main_screen.dart';
import 'package:twinity/screens/create_profile_screen.dart'; // Import new screen
import 'package:twinity/services/db_service.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final User? user = snapshot.data;
        if (user == null) {
          return const LoginScreen();
        } else {
          // Check if the user document exists in Firestore
          return FutureBuilder<bool>(
            future: DbService().doesUserExist(user.uid),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              // If user document exists, go to main screen
              if (userSnapshot.data == true) {
                return const MainScreen();
              }
              // Otherwise, go to create profile screen
              else {
                return CreateProfileScreen(user: user);
              }
            },
          );
        }
      },
    );
  }
}