import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/db_service.dart';
import '../widgets/ad_banner.dart';
import '../widgets/subscribe_button.dart';
import 'login_screen.dart'; // <-- Add this import

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final db = DbService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Twinity Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
              if (context.mounted) {
                // Replace the current screen with the LoginScreen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user != null)
              Text('Hello, ${user.displayName ?? user.email}')
            else
              const Text('Not signed in'),
            const SizedBox(height: 12),
            if (user != null)
              StreamBuilder(
                stream: db.watchUserProfile(user.uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text('Loading profile...');
                  }
                  final data = snapshot.data!.data() ?? {};
                  return Text('Profile: $data');
                },
              ),
            const SizedBox(height: 24),
            const SubscribeButton(),
            const Spacer(),
            const AdBanner(),
          ],
        ),
      ),
    );
  }
}