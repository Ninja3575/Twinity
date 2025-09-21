import 'package:flutter/material.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSubscriptionCard(context),
          const SizedBox(height: 20),
          _buildPointsCard(context)
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Subscriptions & Point Packs",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text("You can purchase subscriptions (simulation)."),
            const SizedBox(height: 10),
            _subscriptionOption("₹9 / month", "200 pts/day · No ads"),
            _subscriptionOption("₹18 / month", "500 pts/day · No ads"),
            _subscriptionOption("₹90 / month", "3,000 pts/day · No ads"),
            _subscriptionOption("₹180 / month", "9,000 pts/day · No ads"),
            const Divider(height: 40),
            _dailyLoginReward(),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _pointPackOption("₹49", "10,000 pts"),
            _pointPackOption("₹99", "20,000 pts"),
            _pointPackOption("₹199", "50,000 pts"),
            _pointPackOption("₹349", "100,000 pts"),
          ],
        ),
      ),
    );
  }

  Widget _subscriptionOption(String price, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(price,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              Text(description, style: const TextStyle(color: Colors.black54)),
            ],
          ),
          ElevatedButton(onPressed: () {}, child: const Text("Buy"))
        ],
      ),
    );
  }

  Widget _dailyLoginReward() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Daily login reward",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(
                  "Base 50 pts — plus points from active subscriptions (stacked). You can claim once every 24 hours."),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Column(
          children: [
            const Text("Last claim:"),
            const Text("9/15/2025, 9:42:50 AM"),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {}, child: const Text("Claim Daily 50 pts")),
          ],
        )
      ],
    );
  }

  Widget _pointPackOption(String price, String points) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(price,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              Text(points, style: const TextStyle(color: Colors.black54)),
            ],
          ),
          ElevatedButton(onPressed: () {}, child: const Text("Buy"))
        ],
      ),
    );
  }
}