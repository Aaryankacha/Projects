import 'package:flutter/material.dart';
import '../../ui/theme/colors.dart';
import '../../ui/theme/text_styles.dart';

class TaskDetailPage extends StatelessWidget {
  final Map<String, dynamic> taskData;

  const TaskDetailPage({super.key, required this.taskData});

  @override
  Widget build(BuildContext context) {
    final title = taskData['title'] ?? 'No Title';
    final email = taskData['email'] ?? 'N/A';
    final description = taskData['description'] ?? 'No Description';
    final dueDate = taskData['dueDate'] ?? 'N/A';
    final attachmentUrl = taskData['attachment']; 

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Details"),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.heading1),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.email),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    taskData['email'],
                    overflow: TextOverflow.ellipsis, 
                    maxLines: 1,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.date_range, color: AppColors.textDark),
                const SizedBox(width: 8),
                Text("Due Date: $dueDate", style: AppTextStyles.bodyText),
              ],
            ),
            const SizedBox(height: 20),
            Text("Description", style: AppTextStyles.heading2),
            const SizedBox(height: 8),
            Text(description, style: AppTextStyles.bodyText),
            const SizedBox(height: 20),
            if (attachmentUrl != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Attachment", style: AppTextStyles.heading2),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                    },
                    icon: const Icon(Icons.attach_file),
                    label: const Text("Download"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
