import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/auth/admin_registration_page.dart';
import '../screens/auth/login_page.dart';

class StartupChecker extends StatelessWidget {
  const StartupChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .limit(1)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final hasAdmin = snapshot.data!.docs.isNotEmpty;

        if (hasAdmin) {
          return const LoginPage();
        } else {
          return const AdminRegistrationPage();
        }
      },
    );
  }
}
