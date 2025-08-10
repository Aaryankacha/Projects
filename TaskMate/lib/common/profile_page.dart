import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../ui/theme/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> userData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    setState(() {
      userData = doc.data() ?? {};
      isLoading = false;
    });
  }

  void updateAvatar(String newPath) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'avatar': newPath,
    });

    setState(() {
      userData['avatar'] = newPath;
    });
  }

  void showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => AvatarPicker(
        onAvatarSelected: (path) {
          updateAvatar(path);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final name = userData['name'] ?? 'Employee';
    final email = userData['email'] ?? '';
    final phone = userData['phone'] ?? '';
    final country = userData['country'] ?? '';
    final age = userData['age'] ?? '';
    final role = userData['role'] ?? '';
    final avatar = userData['avatar'] ?? 'assets/avatars/avatar_1.png';

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 20),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: showAvatarPicker,
                  child: CircleAvatar(
                    backgroundImage: AssetImage(avatar),
                    radius: 45,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  role,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Info List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              children: [
                profileTile(Icons.email, "Email", email),
                profileTile(Icons.phone, "Mobile", phone),
                profileTile(Icons.flag, "Country", country),
                profileTile(Icons.cake, "Age", age),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget profileTile(IconData icon, String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(value),
                ],
              ),
            ),
          ],
        ),
        const Divider(height: 24),
      ],
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
