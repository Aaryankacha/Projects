import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminRegistrationPage extends StatefulWidget {
  const AdminRegistrationPage({super.key});

  @override
  State<AdminRegistrationPage> createState() => _AdminRegistrationPageState();
}

class _AdminRegistrationPageState extends State<AdminRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  final countryController = TextEditingController();

  bool isLoading = false;
  String error = '';
  String selectedAvatarPath = 'assets/avatars/avatar_1.png';

  Future<void> registerAdmin() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user?.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phoneController.text.trim(),
        'age': ageController.text.trim(),
        'country': countryController.text.trim(),
        'avatar': selectedAvatarPath,
        'role': 'admin',
        'type': 'admin',
        'createdAt': FieldValue.serverTimestamp(),
      });

      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message ?? 'Something went wrong.');
    } catch (e) {
      setState(() => error = 'Unexpected error occurred.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text("Admin Registration"),
        centerTitle: true,
        backgroundColor: Colors.orange.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Text(
                "👑 Register as Admin",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Center(
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
                              setState(() => selectedAvatarPath = path);
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                      child: const Text("Choose Avatar"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              buildTextField(
                controller: nameController,
                label: 'Full Name',
                icon: Icons.person,
              ),
              buildTextField(
                controller: emailController,
                label: 'Email',
                icon: Icons.email,
              ),
              buildTextField(
                controller: phoneController,
                label: 'Phone Number',
                icon: Icons.phone,
              ),
              buildTextField(
                controller: ageController,
                label: 'Age',
                icon: Icons.cake,
                isNumber: true,
              ),
              buildTextField(
                controller: countryController,
                label: 'Country',
                icon: Icons.flag,
              ),
              buildTextField(
                controller: passwordController,
                label: 'Password',
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              if (error.isNotEmpty)
                Text(error, style: const TextStyle(color: Colors.red)),
              ElevatedButton.icon(
                onPressed: isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          registerAdmin();
                        }
                      },
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.admin_panel_settings),
                label: Text(isLoading ? "Registering..." : "Register Admin"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) =>
            value == null || value.isEmpty ? 'Enter $label' : null,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
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
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
