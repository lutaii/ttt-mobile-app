import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static Future<String?> getFirebaseUid() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      user = userCredential.user;
    }
    return user?.uid;
  }
}
