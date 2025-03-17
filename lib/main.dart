import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final logger = Logger(printer: SimplePrinter());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _checkAndSignIn();
  }

  Future<void> _checkAndSignIn() async {
    // Check if a user is already signed in
    if (FirebaseAuth.instance.currentUser == null) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInAnonymously();
        logger.d("Signed in as: ${userCredential.user?.uid}");
      } catch (e) {
        logger.d("Error signing in anonymously: $e");
      }
    } else {
      logger.d(
        "User already signed in: ${FirebaseAuth.instance.currentUser?.uid}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe Online',
      home: Scaffold(
        appBar: AppBar(title: Text('Tic Tac Toe Online')),
        body: Center(child: Text('Welcome to Tic Tac Toe!')),
      ),
    );
  }
}
