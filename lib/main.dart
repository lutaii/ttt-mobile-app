import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:ttt_mobile_app/models/four_in_a_row_model.dart';
import 'package:ttt_mobile_app/providers/lobby_provider.dart';
import 'package:ttt_mobile_app/screens/four_in_a_row_screen.dart';
import 'package:ttt_mobile_app/screens/game_screen.dart';
import 'package:ttt_mobile_app/screens/lobby_screen.dart';

import 'models/tic_tie_toe_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => LobbyProvider(),
      child: MyApp(),
    ),
  );
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
    return MaterialApp(title: 'Tic Tac Toe Online', home: LobbyScreen());
  }
}
