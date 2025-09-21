// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Consumer<UserProvider>(builder: (context, up, _) {
        final u = up.user;
        if (u == null) {
          return const Center(child: Text('No profile data found.'));
        }
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              if (u.avatarUrl.isNotEmpty) CircleAvatar(radius: 60, backgroundImage: NetworkImage(u.avatarUrl)),
              const SizedBox(height: 20),
              Text(u.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(u.email),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => up.clearUser(),
                child: const Text('Logout'),
              )
            ],
          ),
        );
      }),
    );
  }
}
