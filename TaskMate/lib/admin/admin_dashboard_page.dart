// admin_dashboard_page.dart

import 'package:flutter/material.dart';
import '../../ui/theme/colors.dart';
import 'admin_greeting_header.dart';
import 'admin_middle_cards.dart';
import '../admin/add_employee_page.dart';
import '../admin/assign_task_page.dart';
import '../admin/view_all_tasks_page.dart';
import '../common/profile_page.dart';
import '../messenger/user_list_page.dart';
import '../common/taskpilot_page.dart'; // ✅ Import your TaskPilot Page

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    _HomeDashboardView(),
    UserListPage(),
    ViewAllTasksPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onAddPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEmployeePage()),
    );
  }

  void _onTaskPilotPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TaskPilotPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.background,
          body: _pages[_selectedIndex],
          floatingActionButton: FloatingActionButton(
            heroTag: 'adminFAB', // 🛠️ Add this line!
            onPressed: _onAddPressed,
            backgroundColor: AppColors.primaryBlue,
            child: const Icon(Icons.add, size: 32, color: Colors.white),
            elevation: 6,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            elevation: 10,
            color: Colors.white,
            child: SizedBox(
              height: 60,
              child: BottomNavigationBar(
                iconSize: 22,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                backgroundColor: Colors.transparent,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppColors.primaryBlue,
                unselectedItemColor: Colors.grey,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat_bubble_outline),
                    label: 'Chats',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list_alt),
                    label: 'Tasks',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),

        // ✅ Floating TaskPilot Icon
        Positioned(
          right: 20,
          bottom: 90,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TaskPilotPage()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(
                4,
              ), // Slight padding to make it compact
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26, // subtle shadow for depth
                    blurRadius: 6,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/taskpilot_icon.png',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover, // prevents overflow/sharp edges
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 👇 Home dashboard layout
class _HomeDashboardView extends StatelessWidget {
  const _HomeDashboardView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            AdminGreetingHeader(),
            SizedBox(height: 20),
            AdminMiddleCards(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
