import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twinity/services/auth_service.dart';
import 'package:twinity/services/db_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final DbService _dbService = DbService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      // Show a message if for some reason no user is logged in
      return const Center(child: Text("Not logged in."));
    }

    return StreamBuilder<dynamic>(
      stream: _dbService.watchUserProfile(currentUser!.uid),
      builder: (context, snapshot) {
        // Handle loading state
        if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: CircularProgressIndicator());
        }

        // **THE FIX IS HERE:** Handle the error case by showing an error message.
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        // Extract user data from the snapshot
        var userData = snapshot.data!.data() as Map<String, dynamic>;
        String name = userData['name'] ?? 'No Name';
        String email = userData['email'] ?? 'No Email';
        String photoURL = userData['photoURL'] ?? '';
        String partnerCode = userData['partnerCode'] ?? '—';
        String couple = userData['couple'] ?? '—';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Profile", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: photoURL.isNotEmpty ? NetworkImage(photoURL) : null,
                        child: photoURL.isEmpty ? const Icon(Icons.person, size: 40) : null,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Name: $name", style: const TextStyle(fontSize: 16, color: Colors.black)),
                            const SizedBox(height: 4),
                            Text("Email: $email", style: const TextStyle(fontSize: 16, color: Colors.black)),
                            const SizedBox(height: 4),
                            Text("Partner code: $partnerCode", style: const TextStyle(fontSize: 16, color: Colors.black)),
                            const SizedBox(height: 4),
                            Text("Couple: $couple", style: const TextStyle(fontSize: 16, color: Colors.black)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(onPressed: () { /* TODO: Implement edit name */ }, child: const Text("Edit name")),
                      ElevatedButton(onPressed: () { /* TODO: Implement change photo */ }, child: const Text("Change Photo")),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _authService.signOut();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text("Sign Out"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Made by @lynx_argon_op", style: TextStyle(color: Colors.black54)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}