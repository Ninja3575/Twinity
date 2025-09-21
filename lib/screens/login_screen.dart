// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  bool _loading = false;

  final AuthService _auth = AuthService(baseUrl: 'https://your-api.example.com');

  Future<void> _attemptLogin() async {
    setState(() => _loading = true);
    try {
      final result = await _auth.login(_emailCtl.text.trim(), _passCtl.text.trim());
      final token = result['token'] as String?;
      final userJson = result['user'] as Map<String, dynamic>? ?? result;

      if (token == null && userJson['token'] != null) {
        // some APIs return token inside user or differently
      }

      final user = UserModel.fromJson(userJson);
      // Save user to provider (and persist)
      await context.read<UserProvider>().setUser(user, token: token);
      // Navigate to home - provider RootDecider will show Home
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _emailCtl, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _passCtl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _attemptLogin,
              child: _loading ? const CircularProgressIndicator() : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
