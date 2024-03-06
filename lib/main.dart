import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_auth/pages/main_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCtrAm-uUfbC9tbPN95epBZJjP-4qHLbjk",
          appId: "1:224697504951:android:0cba46682f50a8c0922932",
          messagingSenderId: "224697504951",
          projectId: "login-6ebae"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
