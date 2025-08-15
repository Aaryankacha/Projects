# Admin Module - TaskMate App

This folder contains all the **admin-related screens** for the TaskMate app. Admin users can manage employees, assign tasks, and view overall dashboards. Each file and its purpose are described below.

---

## Files

### 1. `add_employee_page.dart`
- **Purpose:** Allows the admin to **add a new employee** to the system.
- **Key Features:**
  - Fill in employee details like name, email, phone, age, country.
  - Choose a profile avatar.
  - Save employee to Firebase Firestore.
  - Validates input fields before submission.

---

### 2. `admin_dashboard_page.dart`
- **Purpose:** The **main dashboard** for admins.
- **Key Features:**
  - Shows quick stats like total tasks, pending tasks, completed tasks.
  - Quick action buttons for adding employees, assigning tasks, and chatting with TaskPilot.
  - Displays admin profile and navigation menu.
  - Custom UI with modern design and floating TaskPilot button.

---

### 3. `assign_task_page.dart`
- **Purpose:** Allows the admin to **assign tasks to employees**.
- **Key Features:**
  - Select employee(s) from a list.
  - Add task title, description, and optional attachments.
  - Set task status (pending/completed) and due date.
  - Saves tasks to Firebase Firestore.

---

### 4. `edit_employee_details_page.dart`
- **Purpose:** Admin can **edit an existing employee’s information**.
- **Key Features:**
  - Update details like name, email, phone, age, country, avatar.
  - Changes are saved to Firebase Firestore.
  - Input validation ensures no empty fields.

---

## Notes
- All pages interact with **Firebase Firestore** for storing and fetching data.
- Ensure **Firestore rules** allow admin operations only for users with the `role: admin`.
- Reusable UI components (like text fields, buttons) are located in the `ui/` folder for consistency.
- These pages are intended for **admin users only**. Normal employees cannot access these screens.

---

## How to Use
1. Import the desired page into your `main.dart` or navigation system.
2. Ensure the user is logged in as admin.
3. Navigate using `Navigator.push()` or `Navigator.pushReplacement()`.

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const AddEmployeePage()),
);
