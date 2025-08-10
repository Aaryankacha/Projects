import 'package:flutter/material.dart';
import '../../ui/theme/colors.dart';
import '../common/profile_page.dart';
import '../messenger/inbox_page.dart';
import '../messenger/user_list_page.dart';
import '../employee/employee_task_page.dart';
import '../common/taskpilot_page.dart';
import 'employee_dashboard_header.dart';
import 'employee_dashboard_middle.dart';

class EmployeeDashboardPage extends StatefulWidget {
  const EmployeeDashboardPage({super.key});

  @override
  State<EmployeeDashboardPage> createState() => _EmployeeDashboardPageState();
}

class _EmployeeDashboardPageState extends State<EmployeeDashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    _HomeDashboardView(),
    InboxPage(),
    UserListPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onTaskPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EmployeeTaskPage()),
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
    return SizedBox.expand(
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: IndexedStack(index: _selectedIndex, children: _pages),
            ),
            floatingActionButton: FloatingActionButton(
              heroTag: 'employeeDashboardFAB',
              onPressed: _onTaskPressed,
              backgroundColor: AppColors.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              child: const Text(
                "T",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
              elevation: 10,
              color: Colors.white,
              child: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppColors.primaryBlue,
                unselectedItemColor: Colors.grey,
                iconSize: 22, // ← this is how you control size
                selectedFontSize: 10, // ↓ shrink text size instead of height
                unselectedFontSize: 10,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list_alt),
                    label: 'Inbox',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat_bubble_outline),
                    label: 'Chats',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),

          // ✅ TaskPilot floating icon
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
      ),
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
            EmployeeGreetingHeader(),
            SizedBox(height: 20),
            EmployeeMiddleCards(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
