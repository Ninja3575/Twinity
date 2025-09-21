import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'main_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final user = await authService.signInWithGoogle();
              // No need to create the profile here anymore.
              // Just navigate if the user is not null.
              if (user != null && context.mounted) {
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