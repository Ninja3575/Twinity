import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twinity/screens/game_screen.dart'; // Import the new game screen
import '../services/db_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final DbService _dbService = DbService();

  int _calculateDailySubPoints(dynamic subsData) {
    if (subsData == null || subsData is! List) {
      return 0;
    }
    if (subsData.isNotEmpty) {
      return 12000;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Center(child: Text("Not logged in."));
    }

    return StreamBuilder<dynamic>(
      stream: _dbService.watchUserProfile(currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>;
        String name = userData['name'] ?? 'Guest';
        int points = userData['points'] ?? 0;
        int dailySubPoints = _calculateDailySubPoints(userData['subscriptions']);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                color: Colors.black.withOpacity(0.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Welcome, ${name.toUpperCase()}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                const Text("Signed in", style: TextStyle(color: Colors.white70)),
                                if (dailySubPoints > 0)
                                  Text("Daily from subs: $dailySubPoints pts", style: const TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ),
                          Text(points.toString(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        // **THIS IS THE CHANGE**
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const GameScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            backgroundColor: Colors.pinkAccent),
                        child: const Text("Play Games — Earn Points", style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: ElevatedButton(onPressed: () {}, child: const Text("Connect"))),
                          const SizedBox(width: 10),
                          Expanded(child: ElevatedButton(onPressed: () {}, child: const Text("Create Code"))),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(onPressed: () {}, child: const Text("Watch Ad +100")),
                      const SizedBox(height: 10),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Tip: Go to Subscriptions to claim your free daily points.", style: TextStyle(color: Colors.white70)),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}