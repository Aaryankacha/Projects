import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> downloadAndOpenFile(String url, String filename) async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$filename';

    await Dio().download(url, filePath);
    print("✅ File downloaded to: $filePath");

    await OpenFilex.open(filePath);
    print("📂 File opened successfully.");
  } catch (e) {
    print("❌ Error opening file: $e");
  }
}

class EmployeeTaskPage extends StatelessWidget {
  const EmployeeTaskPage({super.key});

  Stream<List<DocumentSnapshot>> getEmployeeTasks() {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((employeeSnapshot) async {
          final allTasks = employeeSnapshot.docs;

          final globalSnapshot = await FirebaseFirestore.instance
              .collection('tasks')
              .get();
          final validGlobalTaskIds = globalSnapshot.docs
              .map((doc) => doc.id)
              .toSet();

          final filteredTasks = allTasks.where((doc) {
            final taskData = doc.data() as Map<String, dynamic>;
            final globalTaskId = taskData['globalTaskId'];
            return globalTaskId == null ||
                validGlobalTaskIds.contains(globalTaskId);
          }).toList();

          return filteredTasks;
        });
  }

  String formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  Future<void> markAsCompleted(String taskId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userTaskRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId);

    final taskSnapshot = await userTaskRef.get();
    final globalTaskId = taskSnapshot['globalTaskId'];

    // Update user's task
    await userTaskRef.update({'status': 'completed'});

    // Update global task if globalTaskId exists
    if (globalTaskId != null && globalTaskId is String) {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(globalTaskId)
          .update({'status': 'completed'});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('My Tasks'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: getEmployeeTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "🎉 No tasks assigned yet!",
                style: TextStyle(color: Colors.black54, fontSize: 18),
              ),
            );
          }

          final tasks = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskCard(
                taskId: task.id,
                title: task['title'],
                description: task['description'],
                date: formatTimestamp(task['timestamp']),
                status: task['status'],
                onComplete: () => markAsCompleted(task.id),
                attachmentUrl: task.data().toString().contains('attachmentUrl')
                    ? task['attachmentUrl']
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String taskId;
  final String title;
  final String description;
  final String date;
  final String status;
  final VoidCallback onComplete;
  final String? attachmentUrl;

  const TaskCard({
    super.key,
    required this.taskId,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.onComplete,
    this.attachmentUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = status == 'completed';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "📌 $title",
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            if (attachmentUrl != null) ...[
              const Divider(height: 24),
              ElevatedButton.icon(
                onPressed: () async {
                  final fileName = attachmentUrl!.split('/').last;
                  await downloadAndOpenFile(attachmentUrl!, fileName);
                },
                icon: const Icon(Icons.file_download),
                label: const Text("Download & Open"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "📅 $date",
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Colors.green.shade600
                        : Colors.orange.shade600,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: isCompleted ? null : onComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompleted
                    ? Colors.grey
                    : Colors.blue.shade700,
                minimumSize: const Size.fromHeight(40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(
                isCompleted ? Icons.check_circle : Icons.check,
                color: Colors.white,
              ),
              label: Text(
                isCompleted ? "Completed" : "Mark as Completed",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
