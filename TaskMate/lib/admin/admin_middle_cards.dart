import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../admin/manage_employee_page.dart';
import '../../ui/theme/colors.dart';
import '../../ui/theme/text_styles.dart';
import 'task_detail_page.dart';

class AdminMiddleCards extends StatelessWidget {
  const AdminMiddleCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Card 1: Pending Tasks
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
          child: Container(
            height: 250, // size of the box
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
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
                Text("Pending Tasks", style: AppTextStyles.heading2),
                const SizedBox(height: 12),
                Expanded(
                  // This makes the list fill the remaining space in the box
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('tasks')
                        .where('status', isEqualTo: 'pending')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Text("Error loading tasks"));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Text(
                          "All tasks completed!",
                          style: AppTextStyles.smallText,
                        );
                      }

                      final tasks = snapshot.data!.docs;

                      return Scrollbar(
                        // Add scrollbar for better UX
                        child: ListView.separated(
                          itemCount: tasks.length,
                          separatorBuilder: (_, __) => const Divider(height: 8),
                          itemBuilder: (context, index) {
                            final data =
                                tasks[index].data()! as Map<String, dynamic>;
                            final title = data['title'] ?? "No Title";
                            final email = data['email'] ?? "N/A";

                            return ListTile(
                              title: Text(title),
                              subtitle: Text(
                                "Assigned to: $email",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          TaskDetailPage(taskData: data),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBlue,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                ),
                                child: const Text(
                                  "View",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        // Card 2: Edit Employee Details
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(
                  Icons.manage_accounts_rounded,
                  color: AppColors.primaryBlue,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Edit Employee Details",
                    style: AppTextStyles.bodyText,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ManageEmployeesPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                  ),
                  child: const Text("Edit"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
