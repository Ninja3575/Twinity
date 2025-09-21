import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/db_service.dart';
import '../widgets/ad_banner.dart';
import '../widgets/subscribe_button.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final db = DbService();

    return Scaffold(
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
            ElevatedButton(
              onPressed: () {
                // TODO: Implement game selection modal
              },
              child: const Text('Play Games - Earn Points'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement connect partner functionality
                    },
                    child: const Text('Connect'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement create code functionality
                    },
                    child: const Text('Create Code'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement watch ad functionality
              },
              child: const Text('Watch Ad +100'),
            ),
            const Spacer(),
            const AdBanner(),
          ],
        ),
      ),
    );
  }
}