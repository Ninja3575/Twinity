import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/db_service.dart';
import 'main_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final DbService dbService = DbService();

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final user = await authService.signInWithGoogle();
              if (user != null && context.mounted) {
                // Use the new function to create profile if it's the first time
                await dbService.updateUserProfile(user.uid, {
                  'name': user.displayName,
                  'email': user.email,
                  'photoURL': user.photoURL,
                });

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to sign in: $e')),
              );
            }
          },
          child: const Text("Login with Google"),
        ),
      ),
    );
  }
}