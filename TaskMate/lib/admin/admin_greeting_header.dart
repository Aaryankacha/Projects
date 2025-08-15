
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../ui/theme/colors.dart';
import '../../ui/theme/text_styles.dart';
import 'add_employee_page.dart';
import 'assign_task_page.dart';
import '../common/about_us_page.dart';

class AdminGreetingHeader extends StatelessWidget {
  const AdminGreetingHeader({super.key});

  Future<Map<String, String>> getAdminData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null)
      return {'name': 'Admin', 'avatar': 'assets/avatars/avatar_1.png'};

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    final data = doc.data();

    return {
      'name': data?['name'] ?? 'Admin',
      'avatar': data?['avatar'] ?? 'assets/avatars/avatar_1.png',
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: getAdminData(),
      builder: (context, snapshot) {
        final name = snapshot.data?['name'] ?? "Admin";
        final avatar =
            snapshot.data?['avatar'] ?? 'assets/avatars/avatar_1.png';

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryBlue, Color(0xFF4FC3F7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row: Menu on left, profile on right
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onSelected: (value) {
                      if (value == 'logout') {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacementNamed(context, '/login');
                      } else if (value == 'about') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AboutUsPage(), 
                          ),
                        );
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'about', child: Text('About App')),
                      PopupMenuItem(value: 'logout', child: Text('Logout')),
                    ],
                  ),
                  CircleAvatar(radius: 26, backgroundImage: AssetImage(avatar)),
                ],
              ),

              const SizedBox(height: 25),

              Text(
                "Hello, $name!",
                style: AppTextStyles.heading1.copyWith(color: Colors.white),
              ),

              const SizedBox(height: 8),
              Text(
                "Manage employees and tasks easily",
                style: AppTextStyles.smallText.copyWith(color: Colors.white70),
              ),

              const SizedBox(height: 20),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddEmployeePage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Add Employee"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AssignTaskPage(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Assign Task"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
