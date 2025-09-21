// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Consumer<UserProvider>(
        builder: (context, userProv, _) {
          final user = userProv.user;
          if (user == null) {
            // Could show loader while app decides if logged in
            return const Center(child: Text('No user — please log in'));
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (user.avatarUrl.isNotEmpty)
                  CircleAvatar(radius: 40, backgroundImage: NetworkImage(user.avatarUrl)),
                const SizedBox(height: 12),
                Text('Welcome, ${user.name}', style: const TextStyle(fontSize: 20)),
                Text(user.email),
              ],
            ),
          );
        },
      ),
    );
  }
}
