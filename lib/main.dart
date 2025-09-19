import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// If you run FlutterFire configure, uncomment and use the generated options.
// import 'firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'screens/login_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS)) {
    await Firebase.initializeApp();
    // Or with explicit options
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
  // Initialize Google Mobile Ads SDK only on supported platforms
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS)) {
    await MobileAds.instance.initialize();
  }
  runApp(const TwinityApp());
}

class TwinityApp extends StatelessWidget {
  const TwinityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twinity',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const LoginScreen(),
    );
  }
}
