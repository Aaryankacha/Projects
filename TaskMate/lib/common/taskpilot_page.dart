import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  Message({required this.text, required this.isUser, required this.timestamp});
}

class TaskPilotPage extends StatefulWidget {
  const TaskPilotPage({super.key});
  @override
  State<TaskPilotPage> createState() => _TaskPilotPageState();
}

class _TaskPilotPageState extends State<TaskPilotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  bool _loading = false;

  final String apiUrl = 'your-URL';

  Future<void> askTaskPilot(String prompt) async {
    setState(() {
      _loading = true;
      _messages.add(
        Message(text: prompt, isUser: true, timestamp: DateTime.now()),
      );
    });

    final cmd = prompt.toLowerCase();

    try {
      if (cmd == "show tasks") {
        final snapshot = await FirebaseFirestore.instance
            .collection('tasks')
            .get();

        if (snapshot.docs.isEmpty) {
          await _addBotReply("📝 No tasks found.");
        } else {
          String reply = "📝 Your current tasks:\n";
          for (int i = 0; i < snapshot.docs.length; i++) {
            final data = snapshot.docs[i].data();
            final title = data['title'] ?? "No Title";
            final status = data['status'] ?? "N/A";
            reply += "${i + 1}. $title (Status: $status)\n";
          }
          await _addBotReply(reply);
        }
      } else if (cmd == "pending tasks") {
        final snapshot = await FirebaseFirestore.instance
            .collection('tasks')
            .where('status', isEqualTo: 'pending')
            .get();

        if (snapshot.docs.isEmpty) {
          await _addBotReply("⌛ No pending tasks!");
        } else {
          String reply = "⌛ Pending tasks:\n";
          for (int i = 0; i < snapshot.docs.length; i++) {
            final data = snapshot.docs[i].data();
            final title = data['title'] ?? "No Title";
            reply += "${i + 1}. $title\n";
          }
          await _addBotReply(reply);
        }
      } else if (cmd == "completed") {
        final snapshot = await FirebaseFirestore.instance
            .collection('tasks')
            .where('status', isEqualTo: 'completed')
            .get();

        await _addBotReply(
          "✅ You've completed ${snapshot.docs.length} task(s) so far.",
        );
      } else if (cmd == "hello" || cmd == "hi") {
        await _addBotReply(
          "👋 Hello! I’m TaskPilot — your assistant for managing tasks and answering daily questions.",
        );
      } else {
        final res = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'prompt': prompt}),
        );
        final data = jsonDecode(res.body);
        final reply = data['response'] ?? data['error'] ?? 'No reply';
        await _addBotReply(reply);
      }
    } catch (e) {
      await _addBotReply("Something went wrong 😢\nError: $e");
    }

    setState(() => _loading = false);
  }

  Future<void> _addBotReply(String text) async {
    setState(() {
      _messages.add(
        Message(text: text, isUser: false, timestamp: DateTime.now()),
      );
    });
  }

  Widget buildMessage(Message msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: msg.isUser
              ? const Color.fromARGB(255, 9, 118, 201)
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            color: msg.isUser ? Colors.white : Colors.black87,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 88, 163, 244),
        elevation: 0,
        leading: BackButton(color: Colors.white), // <-- Back button
        title: const Text("TaskPilot", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: const Color.fromARGB(255, 88, 163, 244),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage(
                    "assets/images/taskpilot-avatar.png",
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Your friendly assistant, ready to help you conquer tasks and answer anything you throw my way.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) => buildMessage(_messages[index]),
            ),
          ),

          if (_loading)
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: CircularProgressIndicator(),
            ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Ask TaskPilot...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 123, 155),
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                  onPressed: _loading
                      ? null
                      : () {
                          final prompt = _controller.text.trim();
                          if (prompt.isNotEmpty) {
                            _controller.clear();
                            askTaskPilot(prompt);
                          }
                        },
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
