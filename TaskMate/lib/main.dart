import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'common/startup_checker.dart';
import 'screens/auth/login_page.dart';
import 'common/about_us_page.dart';
import 'common/taskpilot_page.dart';
import 'messenger/user_list_page.dart';
import 'employee/employee_dashboard_page.dart';
import 'admin/admin_dashboard_page.dart';

Future<void> main() async {

  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.orange.shade50,
      ),
      home: const StartupChecker(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/about': (context) => const AboutUsPage(),
        '/userList': (context) => const UserListPage(),
        '/taskpilot': (context) => const TaskPilotPage(),
        '/dashboard': (context) => const EmployeeDashboardPage(),
        '/adminDashboard': (context) => const AdminDashboardPage(),
      },
    );
  }
}
