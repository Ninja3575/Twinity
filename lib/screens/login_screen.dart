import 'package:flutter/material.dart';
import 'package:twinity/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return Scaffold(
      backgroundColor: Colors.orange[800],
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await authService.signInWithGoogle();
              // The AuthWrapper will now handle navigation automatically.
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to sign in: $e')),
                );
              }
            }
          },
          child: const Text("Sign in with Google"),
        ),
      ),
    );
  }
}