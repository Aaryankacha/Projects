import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';

class AssignTaskPage extends StatefulWidget {
  const AssignTaskPage({super.key});

  @override
  State<AssignTaskPage> createState() => _AssignTaskPageState();
}

class _AssignTaskPageState extends State<AssignTaskPage> {
  final emailController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? dueDate;

  PlatformFile? pickedFile;
  String? uploadedFileUrl;
  bool isLoading = false;

  Future<void> assignTask() async {
    setState(() => isLoading = true);
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: emailController.text.trim())
          .get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ No user found with this email")),
        );
      } else {
        final userDoc = querySnapshot.docs.first;
        final uid = userDoc.id;

        final globalTask = await FirebaseFirestore.instance
            .collection('tasks')
            .add({
              'uid': uid,
              'email': emailController.text.trim(),
              'title': titleController.text.trim(),
              'description': descriptionController.text.trim(),
              'timestamp': Timestamp.now(),
              'status': 'pending',
              'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
            });

        final globalTaskId = globalTask.id;
        if (pickedFile != null) {
          try {
            final dio =
                Dio(); 
            late FormData
            formData; 

            if (pickedFile!.bytes != null) {
      
              formData = FormData.fromMap({
                'file': MultipartFile.fromBytes(
                  pickedFile!.bytes!,
                  filename:
                      "${DateTime.now().millisecondsSinceEpoch}_${pickedFile!.name}",
                ),
              });
            } else if (pickedFile!.path != null) {
 
              formData = FormData.fromMap({
                'file': await MultipartFile.fromFile(
                  pickedFile!.path!,
                  filename:
                      "${DateTime.now().millisecondsSinceEpoch}_${pickedFile!.name}",
                ),
              });
            } else {
              throw Exception(
                "❌ No valid file data to upload.",
              ); 
            }
            final response = await dio.post(
              'your-URL',
              data: formData,
            );
            if (response.statusCode == 200 && response.data['url'] != null) {
              uploadedFileUrl =
                  "your-URL";
            } else {
              throw Exception(
                "File upload failed",
              );
            }
          } catch (e) {
            print("Upload error: $e");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("❌ File upload failed")),
            );
            setState(() => isLoading = false);
            return;
          }
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('tasks')
            .add({
              'title': titleController.text.trim(),
              'description': descriptionController.text.trim(),
              'timestamp': Timestamp.now(),
              'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
              'status': 'pending',
              'globalTaskId': globalTaskId, 
              'attachmentUrl': uploadedFileUrl,
            });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Task assigned successfully!")),
        );

        emailController.clear();
        titleController.clear();
        descriptionController.clear();
      }
    } catch (e) {
      print("Error assigning task: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("❌ Failed to assign task")));
    }

    setState(() => isLoading = false);
    dueDate = null;
  }

  Future<void> selectDueDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => dueDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade600,
        title: const Text("Assign Task"),
        centerTitle: true,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.assignment_turned_in_rounded,
                    size: 60,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(height: 20),
                  buildTextField(
                    controller: emailController,
                    label: "Employee Email",
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 15),
                  buildTextField(
                    controller: titleController,
                    label: "Task Title",
                    icon: Icons.title,
                  ),
                  const SizedBox(height: 15),
                  buildTextField(
                    controller: descriptionController,
                    label: "Task Description",
                    icon: Icons.description,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          dueDate == null
                              ? "📅 No due date selected"
                              : "📅 Due: ${dueDate!.day}/${dueDate!.month}/${dueDate!.year}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      TextButton(
                        onPressed: () => selectDueDate(context),
                        child: const Text("Select Date"),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles();
                      if (result != null) {
                        setState(() => pickedFile = result.files.first);
                      }
                    },
                    icon: const Icon(Icons.attach_file),
                    label: Text(
                      pickedFile == null
                          ? "Attach File"
                          : "Attached: ${pickedFile!.name}",
                    ),
                  ),

                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.send),
                      label: Text(
                        isLoading ? "Assigning..." : "Assign Task",
                        style: const TextStyle(fontSize: 16),
                      ),
                      onPressed: isLoading ? null : assignTask,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blue.shade400),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(color: Colors.black87),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
      ),
    );
  }
}
