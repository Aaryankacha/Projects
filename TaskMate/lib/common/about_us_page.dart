
import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "About Us",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue.shade600,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Card
            _buildHeaderCard(),
            const SizedBox(height: 16),

            // Developer Info Card
            _buildInfoCard(
              icon: Icons.person,
              title: "👨‍💻 Developer Info",
              content:
                  "Hi, I'm Aryan 👋\n\nThis app was built as a part of my learning and personal project journey using Flutter and Firebase.\n\nI wanted to build something practical where an Admin can manage employees and assign them tasks, while Employees can track their own tasks — all inside one smooth mobile/web experience.",
            ),
            const SizedBox(height: 16),

            // Tech Stack Card
            _buildInfoCard(
              icon: Icons.code,
              title: "🛠️ Tech Stack",
              content:
                  "• Flutter (UI framework)\n• Firebase Auth (Login/signup)\n• Cloud Firestore (Database)\n• Dart (Programming language)\n• OpenRouter API (AI Assistant)\n• Flask (File handling backend)",
            ),
            const SizedBox(height: 16),

            // App Features Card
            _buildInfoCard(
              icon: Icons.featured_play_list,
              title: "📱 App Features",
              content:
                  "• Admin can add, edit & delete employees\n"
                  "• Assign tasks with file attachments\n"
                  "• Built-in messaging system\n"
                  "• AI chat assistant (Task Pilot)\n"
                  "• Role-based login (admin/employee)\n"
                  "• File sharing (PDF, images, documents)",
            ),
            const SizedBox(height: 16),

            // Future Plans Card
            _buildInfoCard(
              icon: Icons.lightbulb,
              title: "💡 Future Plans",
              content:
                  "• Dark mode support\n• Push notifications\n• Advanced analytics dashboard\n• Enhanced AI capabilities\n• Mobile & web optimization",
            ),
            const SizedBox(height: 24),

            // Thank You Card
            _buildThankYouCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.task_alt, size: 48, color: Colors.white),
          const SizedBox(height: 12),
          const Text(
            "TaskMate",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Streamline your workflow with efficiency",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.blue.shade600, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThankYouCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.favorite, size: 36, color: Colors.white),
          const SizedBox(height: 12),
          const Text(
            "Thank you for checking out the app! 🙌",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Built with ❤️ using Flutter",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
