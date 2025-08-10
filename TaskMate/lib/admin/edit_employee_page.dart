import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../ui/theme/colors.dart';
import '../../ui/theme/text_styles.dart';

class EditEmployeePage extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> currentData;

  const EditEmployeePage({
    super.key,
    required this.userId,
    required this.currentData,
  });

  @override
  State<EditEmployeePage> createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends State<EditEmployeePage> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController countryController;
  late TextEditingController ageController;
  String selectedRole = "Employee";

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentData['name'] ?? '');
    phoneController = TextEditingController(text: widget.currentData['phone'] ?? '');
    countryController = TextEditingController(text: widget.currentData['country'] ?? '');
    ageController = TextEditingController(text: widget.currentData['age'] ?? '');
    final role = (widget.currentData['role'] ?? "Employee").toString().toLowerCase();
    if (role == 'admin') {
      selectedRole = 'Admin';
    } else {
      selectedRole = role[0].toUpperCase() + role.substring(1);
    }
  }

  Future<void> updateEmployee() async {
    await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
      'name': nameController.text.trim(),
      'phone': phoneController.text.trim(),
      'country': countryController.text.trim(),
      'age': ageController.text.trim(),
      'role': selectedRole,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Employee updated successfully!")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Edit Employee"),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                labelStyle: AppTextStyles.smallText,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: "Phone Number",
                labelStyle: AppTextStyles.smallText,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: countryController,
              decoration: InputDecoration(
                labelText: "Country",
                labelStyle: AppTextStyles.smallText,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ageController,
              decoration: InputDecoration(
                labelText: "Age",
                labelStyle: AppTextStyles.smallText,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: InputDecoration(
                labelText: "Role",
                labelStyle: AppTextStyles.smallText,
                border: const OutlineInputBorder(),
              ),
              items: ["Developer", "Designer", "Manager", "Tester", "HR", "Admin"]
                  .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => selectedRole = val!),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: updateEmployee,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Update", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
