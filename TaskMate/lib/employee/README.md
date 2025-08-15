# Employee Module - TaskMate App

This folder contains screens specifically for **employee users**. Employees can view their assigned tasks and check their dashboard stats.

---

## Files

### 1. `view_task_page.dart`
- **Purpose:** Allows employees to **view their assigned tasks** in detail.
- **Key Features:**
  - Displays a list of tasks assigned to the logged-in employee.
  - Shows task details: title, description, status, due date, and attachments.
  - Tasks are fetched from **Firebase Firestore** dynamically.
  - Simple and clean UI for easy task tracking.
  - Supports real-time updates if Firestore data changes.

---

### 2. `employee_dashboard_page.dart`
- **Purpose:** The **main dashboard for employees**.
- **Key Features:**
  - Shows a summary of tasks (total, pending, completed).
  - Quick access to view detailed tasks or chat with TaskPilot.
  - Displays employee profile information.
  - Modern UI design consistent with the admin dashboard.
  - Uses a `Stack` layout with floating buttons for easy navigation.

---

## Notes
- Employees **cannot access admin features** like adding or editing other employees.
- All data is tied to the logged-in employee’s UID to ensure privacy.
- Firebase Firestore rules should enforce that employees can **only read their own tasks**.
- Dashboard and Task views are meant to provide a smooth user experience with minimal clicks.

---

## How to Use
1. Ensure the employee is logged in.
2. Import the desired page:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const EmployeeDashboardPage()),
);
