import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'auth_wrapper.dart'; // Import the new auth wrapper

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const TwinityApp());
}

class TwinityApp extends StatelessWidget {
  const TwinityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twinity',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        brightness: Brightness.dark,
      ),
      home: const AuthWrapper(), // Use the AuthWrapper as the home
    );
  }
}