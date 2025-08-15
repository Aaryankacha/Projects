import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final countryController = TextEditingController();
  final ageController = TextEditingController();

  String selectedRole = 'Developer'; 
  bool isLoading = false;
  String selectedAvatarPath = 'assets/avatars/avatar_1.png';
  final List<String> avatarPaths = [
    'assets/avatars/avatar_1.png',
    'assets/avatars/avatar_2.png',
    'assets/avatars/avatar_3.png',
    'assets/avatars/avatar_4.png',
    'assets/avatars/avatar_5.png',
    'assets/avatars/avatar_6.png',
    'assets/avatars/avatar_7.png',
    'assets/avatars/avatar_8.png',
    'assets/avatars/avatar_9.png',
    'assets/avatars/avatar_10.png',
  ];
  final List<String> roles = [
    'Developer',
    'Designer',
    'Manager',
    'Tester',
    'HR',
  ];

  void addEmployee() async {
    setState(() => isLoading = true);
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'uid': userCredential.user!.uid,
            'name': nameController.text.trim(),
            'email': emailController.text.trim(),
            'phone': phoneController.text.trim(),
            'role': selectedRole,
            'country': countryController.text.trim(),
            'age': ageController.text.trim(),
            'avatar': selectedAvatarPath,
            'type': 'employee',
          });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("✅ Employee added successfully!")));

      nameController.clear();
      emailController.clear();
      phoneController.clear();
      passwordController.clear();
      countryController.clear();
      ageController.clear();
      setState(() => selectedRole = 'Developer');
    } catch (e) {
      print("Error adding employee: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Failed to add employee")));
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Employee')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(selectedAvatarPath),
              ),
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => AvatarPicker(
                      onAvatarSelected: (path) {
                        setState(() {
                          selectedAvatarPath = path;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
                child: Text("Choose Avatar"),
              ),
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 10),
              TextField(
                controller: ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: countryController,
                decoration: InputDecoration(labelText: 'Country'),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedRole,
                items: roles.map((role) {
                  return DropdownMenuItem(value: role, child: Text(role));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Select Role'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : addEmployee,
                child: Text(isLoading ? 'Adding...' : 'Add Employee'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AvatarPicker extends StatelessWidget {
  final Function(String) onAvatarSelected;

  const AvatarPicker({super.key, required this.onAvatarSelected});

  @override
  Widget build(BuildContext context) {
    final List<String> avatarPaths = List.generate(
      10,
      (index) => 'assets/avatars/avatar_${index + 1}.png',
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: avatarPaths.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onAvatarSelected(avatarPaths[index]),
            child: CircleAvatar(
              backgroundImage: AssetImage(avatarPaths[index]),
              radius: 30,
            ),
          );
        },
      ),
    );
  }
}
