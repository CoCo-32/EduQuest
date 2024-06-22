import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'role_selection_page.dart';
import 'user_login_page.dart';
import 'user_signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key?key}) :super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RoleSelectionPage(),
    );
  }
}