import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_page.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  Future<String> getCurrentUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return "User";

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    final data = doc.data();
    return data?['name'] ?? "User";
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Messages',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<String>(
            future: getCurrentUserName(),
            builder: (context, snapshot) {
              final name = snapshot.data ?? 'User';
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  'Hello, $name 👋',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),

          SizedBox(
            height: 100,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(child: Text("Error loading users"));
                }

                final users = snapshot.data!.docs
                    .where((doc) => doc.id != currentUser?.uid)
                    .toList();

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final name = user['name'] ?? 'User';
                    final avatar =
                        user['avatar'] ?? 'assets/avatars/avatar_1.png';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatPage(
                              receiverId: user.id,
                              receiverName: name,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage: AssetImage(avatar),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              width: 60,
                              child: Text(
                                name,
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          const Divider(),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading users ❌"));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final users = snapshot.data!.docs
                    .where((doc) => doc.id != currentUser!.uid)
                    .toList();

                if (users.isEmpty) {
                  return const Center(child: Text("No other users found 😶"));
                }

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final userName = user['name'];
                    final userAvatar = user['avatar'];
                    final userId = user.id;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(userAvatar),
                      ),
                      title: Text(userName),
                      subtitle: const Text("Last message preview..."),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("00.21", style: TextStyle(fontSize: 12)),
                          Icon(Icons.done_all, size: 16, color: Colors.blue),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatPage(
                              receiverId: userId,
                              receiverName: userName,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
