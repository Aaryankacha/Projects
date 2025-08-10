import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;

  // 🔐 Sign In
  static Future<User?> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Login Error: $e');
      return null;
    }
  }

  // 📝 Sign Up
  static Future<User?> signUp(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Signup Error: $e');
      return null;
    }
  }

  // 🚪 Sign Out
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // 👁 Check login state
  static Stream<User?> get userChanges => _auth.authStateChanges();
}
