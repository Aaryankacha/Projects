# Common Module - TaskMate App

This folder contains screens and utilities that are **used by both Admin and Employee users**. These are shared functionalities like profile, network checking, TaskPilot chat, and app info.

---

## Files

### 1. `about_us_page.dart`
- **Purpose:** Displays information about the app and development team.
- **Key Features:**
  - Shows app name, purpose, and developer team members.
  - Simple UI with images, text, and scrollable content.
  - Can be accessed via menus or footer links.

---

### 2. `profile_page.dart`
- **Purpose:** Displays and allows editing of the logged-in user’s profile.
- **Key Features:**
  - Shows user details: name, email, phone, age, country, and avatar.
  - Admin and Employee profiles share the same layout.
  - Supports avatar change using the `AvatarPicker`.
  - Saves updated details to Firebase Firestore.

---

### 3. `network_listener.dart`
- **Purpose:** Monitors internet connectivity.
- **Key Features:**
  - Detects if the device goes offline or comes online.
  - Shows a visual alert or Snackbar if the network is lost.
  - Useful to prevent errors when fetching/saving data to Firebase.

---

### 4. `startup_checker.dart`
- **Purpose:** Checks user authentication and app startup flow.
- **Key Features:**
  - Runs when the app launches.
  - Checks if a user is logged in.
  - Directs user to **LoginPage**, **AdminDashboard**, or **EmployeeDashboard** accordingly.
  - Ensures smooth app initialization.

---

### 5. `taskpilot_page.dart`
- **Purpose:** Implements the **TaskPilot chatbot**.
- **Key Features:**
  - Allows users to ask TaskPilot for tasks, pending/completed tasks, or general queries.
  - Connects to Firebase Firestore to fetch tasks dynamically.
  - Can fallback to a backend API for general questions.
  - Displays chat messages in a modern UI with user/bot distinction.
  - Supports loading indicators and input validation.

---

## Notes
- All pages and utilities in this folder are **shared across user types**.
- TaskPilot uses **Firestore and optional backend API**, so ensure proper security rules.
- Network Listener helps improve user experience by handling connectivity changes gracefully.
- Startup Checker ensures users are redirected to the correct dashboard on app launch.

---

## How to Use
1. Import the desired page or utility into your navigation or main app logic.
2. For TaskPilot and Profile, make sure Firebase is initialized.
3. Use `NetworkListener` and `StartupChecker` at app root for better UX.

```dart
// Example: Wrap main app with NetworkListener
NetworkListener(
  child: MaterialApp(
    home: StartupChecker(),
  ),
);
