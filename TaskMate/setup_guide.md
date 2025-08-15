

# 📌 Setup Guide

## 📂 What’s Included

This repository contains **only**:

* `lib/` → All Dart files (pages, widgets, and logic)
* `assets/` → Images and avatar resources

> ⚠ **Note:** The full Flutter project (including `android/`, `ios/`, `web/`, `pubspec.lock`, etc.) is **NOT** included.

---

## 🛠 Requirements

Before running, make sure you have:

* **Flutter SDK** installed → [Install Guide](https://docs.flutter.dev/get-started/install)
* **Firebase account** → [Sign up here](https://firebase.google.com/)
* A basic understanding of Firebase setup in Flutter

---

## 🔑 Important Notes

* Since this repo **does not** include Firebase configuration files, you **must** create your own Firebase project.
* You **cannot** directly run this project without setting up your **own Firebase database** and **API keys**.
* The files here are for reference and learning — you need to configure your own backend.

---

## 🚀 How to Setup

1. **Create a new Flutter project** on your system:

   ```bash
   flutter create your_project_name
   ```
2. Replace the newly created `lib/` and `assets/` folders with the ones from this repository.
3. Add Firebase to your new project:

   * Go to [Firebase Console](https://console.firebase.google.com/)
   * Create a new project
   * Enable **Authentication**, **Firestore Database**, and **Storage** (if required)
4. Get your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) and place them in the correct folders:

   ```
   android/app/google-services.json
   ios/Runner/GoogleService-Info.plist
   ```
5. Add your Firebase dependencies in `pubspec.yaml`:

   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     firebase_core: ^latest_version
     firebase_auth: ^latest_version
     cloud_firestore: ^latest_version
     firebase_storage: ^latest_version
     # Add any other packages used in your project
   ```
6. Run `flutter pub get` to install dependencies.
7. Initialize Firebase in your project:

   ```dart
   import 'package:firebase_core/firebase_core.dart';

   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp();
     runApp(MyApp());
   }
   ```
8. Update all Firebase-related code with **your own API keys** and **database rules**.

---

## 📄 Final Reminder

This is **not** a complete runnable project out of the box.
You need to:

* Create your own Firebase project
* Add your API keys & credentials
* Adjust database structure according to your needs

