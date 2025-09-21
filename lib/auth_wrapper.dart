import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twinity/screens/login_screen.dart';
import 'package:twinity/screens/main_screen.dart';
import 'package:twinity/services/db_service.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData && snapshot.data != null) {
          // If the user is logged in, use a FutureBuilder to ensure their profile is created
          return FutureBuilder(
            future: DbService().updateUserProfile(snapshot.data!.uid, {
              'name': snapshot.data!.displayName,
              'email': snapshot.data!.email,
              'photoURL': snapshot.data!.photoURL,
            }),
            builder: (context, dbSnapshot) {
              if (dbSnapshot.connectionState == ConnectionState.done) {
                // Once the database operation is complete, show the main screen
                return const MainScreen();
              }
              // While the database is being updated, show a loading indicator
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            },
          );
        }
        // If the user is not logged in, show the login screen
        return const LoginScreen();
      },
    );
  }
}