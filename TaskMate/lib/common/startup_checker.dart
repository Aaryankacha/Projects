import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/auth/admin_registration_page.dart';
import '../screens/auth/login_page.dart';

class StartupChecker extends StatelessWidget {
  const StartupChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkAdmin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(body: Center(child: Text('Error loading app')));
        }

        final hasAdmin = snapshot.data ?? false;

        return hasAdmin ? const LoginPage() : const AdminRegistrationPage();
      },
    );
  }

  Future<bool> _checkAdmin() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Startup check error: $e');
      return false; // default if error
    }
  }
}
