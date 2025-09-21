// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const TwinityApp());
}

class TwinityApp extends StatelessWidget {
  const TwinityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final up = UserProvider();
        up.loadFromPrefs(); // load persisted user on start
        return up;
      },
      child: MaterialApp(
        title: 'Twinity',
        theme: ThemeData.dark(),
        home: const RootDecider(),
      ),
    );
  }
}

class RootDecider extends StatelessWidget {
  const RootDecider({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProv, _) {
      if (userProv.isLoggedIn) {
        return const HomeScreen(); // or main app scaffold
      } else {
        return const LoginScreen();
      }
    });
  }
}
