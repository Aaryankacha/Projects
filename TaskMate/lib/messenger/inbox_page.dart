import 'package:flutter/material.dart';
import '../services/chat_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  final ChatService _chatService = ChatService();
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📨 Inbox"),
        backgroundColor: Colors.blue.shade600,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _chatService.getInbox(currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final chats = snapshot.data ?? [];

          if (chats.isEmpty) {
            return const Center(child: Text("No messages yet 😶"));
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];

              final otherUserId = (chat['participants'] as List).firstWhere(
                (id) => id != currentUser!.uid,
              );

              final lastMessage = chat['lastMessage'] ?? '';
              final timestamp = (chat['lastTimestamp'] as Timestamp?)?.toDate();

              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(otherUserId), 
                subtitle: Text(lastMessage, maxLines: 1),
                trailing: timestamp != null
                    ? Text(
                        "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}",
                        style: const TextStyle(fontSize: 12),
                      )
                    : null,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPage(
                        receiverId: otherUserId,
                        receiverName:
                            otherUserId, 
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.chat),
        onPressed: () {
          Navigator.pushNamed(context, '/userList'); 
        },
      ),
    );
  }
}
