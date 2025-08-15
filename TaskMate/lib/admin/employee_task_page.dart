import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../ui/theme/colors.dart';
import '../../ui/theme/text_styles.dart';

class EmployeeTaskPage extends StatelessWidget {
  const EmployeeTaskPage({super.key});

  Stream<QuerySnapshot> getEmployeeTasks() {
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    return FirebaseFirestore.instance
        .collection('tasks')
        .where('email', isEqualTo: currentUserEmail)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("My Tasks"),
        backgroundColor: AppColors.primaryBlue,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getEmployeeTasks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("❌ Error loading tasks"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = snapshot.data!.docs;

          if (tasks.isEmpty) {
            return const Center(child: Text("🎉 No tasks assigned yet"));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final data = task.data() as Map<String, dynamic>;

              final status = data['status'] ?? 'unknown';
              final title = data['title'] ?? 'No Title';
              final description = data['description'] ?? 'No Description';

              final statusColor = status == 'completed'
                  ? AppColors.success
                  : status == 'pending'
                  ? AppColors.warning
                  : AppColors.error;

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.heading2),

                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: AppTextStyles.bodyText.copyWith(
                        color: Colors.grey.shade800,
                      ),
                    ),

                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: AppTextStyles.smallText.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
