import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_wrapper.dart'; // Import the new wrapper
import 'firebase_options.dart';

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
        scaffoldBackgroundColor: Colors.orange[800],
        cardColor: Colors.orange[300],
      ),
      // Use the AuthWrapper as the entry point of the app
      home: const AuthWrapper(),
    );
  }
}