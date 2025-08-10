import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  // 🧠 Replace this with your working ngrok link
  final String apiUrl = 'https://taskmate-backend-hzak.onrender.com/ask';

  Future<void> askTaskPilot(String prompt) async {
    setState(() {
      _loading = true;
      _messages.add(
        Message(text: prompt, isUser: true, timestamp: DateTime.now()),
      );
    });

    // Check for manual commands (case-insensitive)
    final cmd = prompt.toLowerCase();

    if (cmd == "show tasks") {
      await _addBotReply(
        "📝 Your current tasks:\n1. Redesign dashboard\n2. Connect Firebase\n3. Test TaskPilot bot",
      );
    } else if (cmd == "pending tasks") {
      await _addBotReply(
        "⌛ Pending tasks:\n1. Complete profile UI\n2. Add attachments to tasks",
      );
    } else if (cmd == "completed") {
      await _addBotReply("✅ You've completed 4 tasks so far. Great job!");
    } else if (cmd == "hello" || cmd == "hi") {
      await _addBotReply(
        "👋 Hello! I’m TaskPilot — your assistant for managing tasks.",
      );
    } else {
      // 🔄 Otherwise, call Gemini API
      try {
        final res = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'prompt': prompt}),
        );

        final data = jsonDecode(res.body);
        final reply = data['response'] ?? data['error'] ?? 'No reply';

        await _addBotReply(reply);
      } catch (e) {
        await _addBotReply("Something went wrong 😢");
      }
    }

    setState(() => _loading = false);
  }

  // 💬 Helper to add bot reply
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
          color: msg.isUser ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: msg.isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: TextStyle(
                color: msg.isUser ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(msg.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: msg.isUser ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
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
      appBar: AppBar(
        title: const Text("🤖 TaskPilot Chat"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Column(
        children: [
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
                  onPressed: _loading
                      ? null
                      : () {
                          final prompt = _controller.text.trim();
                          if (prompt.isNotEmpty) {
                            _controller.clear();
                            askTaskPilot(prompt);
                          }
                        },
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
