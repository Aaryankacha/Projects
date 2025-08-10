import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../ui/theme/colors.dart';
import '../../ui/theme/text_styles.dart';
import 'employee_task_page.dart';

class EmployeeMiddleCards extends StatelessWidget {
  const EmployeeMiddleCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Card 1: My Pending Tasks
        Container(
          margin: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.08),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Text("My Pending Tasks", style: AppTextStyles.heading2),
              ),
              const Divider(height: 1, color: Colors.black12),

              // Task List (scrollable if needed)
              SizedBox(
                height: 120,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .collection('tasks')
                      .where('status', isEqualTo: 'pending')
                      .orderBy('timestamp', descending: true)
                      .limit(3)
                      .snapshots(),

                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      print('🔥 Firestore stream error: ${snapshot.error}');
                      return const Center(child: Text("Something went wrong"));
                    }

                    final tasks = snapshot.data?.docs ?? [];

                    if (tasks.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "You're all caught up! ✅",
                            style: AppTextStyles.bodyText,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final data =
                            tasks[index].data() as Map<String, dynamic>;
                        final title = data['title'] ?? 'No Title';
                        final desc = data['description'] ?? 'No details';

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          title: Text(title, style: AppTextStyles.bodyText),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              desc,
                              style: AppTextStyles.smallText.copyWith(
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const EmployeeTaskPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              backgroundColor: AppColors.primaryBlue,
                            ),
                            child: const Text(
                              "View",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Card 2: Profile Reminder
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                radius: 24,
                child: const Icon(Icons.person, color: AppColors.primaryBlue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Keep your profile updated for better task assignment!",
                  style: AppTextStyles.bodyText,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
                child: const Text("Update"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
