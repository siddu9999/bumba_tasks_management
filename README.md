Bumba Task Management App

Bumba is a Flutter-based task management application with integrated authentication features. It provides a seamless experience for users to organize their tasks and manage their progress across multiple states. Designed with simplicity and efficiency, Bumba ensures smooth and responsive interactions, even when offline.

Features

1. Authentication Flow
Login: Secure login using locally stored credentials.
Signup: User registration to create a new account.
Forgot Password: Password recovery functionality.
All authentication data is securely stored locally using SQLite, ensuring access even without an internet connection.

2. Task Management
Three Tabs:
To Do: Newly added tasks appear here by default.
In Progress: Swipe right on a task in "To Do" to move it here.
Done: Swipe right on tasks in "In Progress" to move them here.
Re-Swiping: Swipe left to move tasks back to previous states.
Task Operations:
Add Tasks: Create new tasks using a floating action button.
Edit Tasks: Modify existing tasks.
Delete Tasks: Remove tasks permanently.
Persistence:
Tasks are stored locally using SQLite.
Supports full offline functionality with instant data saving.
3. Design and Typography
Typography

Primary Font: System default (San Francisco for iOS, Roboto for Android)
Header Size: 18sp/pt
Body Text: 14sp/pt
Caption Text: 12sp/pt
Color Palette

Primary Color: #6c5ce7 (Purple)
Background: #f8f9fa (Light Gray)
Text: #2d3436 (Dark Gray)
Card Background: #ffffff (White)
Border Color: #e1e4e8 (Light Gray)
Iconography

App icon and text elements are implemented using SVG for crisp, scalable visuals.
4. Project Architecture
Model-View-Update (MVU):
Model: Manages data and business logic.
View: Renders UI components based on the state.
Update: Handles events and updates the state accordingly.
Why MVU?
Promotes a clear separation of concerns.
Enhances code maintainability and scalability.
5. State Management
Utilizes BLoC (Business Logic Component) pattern:
Centralizes state management.
Decouples business logic from the UI.
Provides reactive programming benefits.
6. Offline Support
SQLite Integration:
All data, including authentication and tasks, are stored locally.
Ensures the app is fully functional without internet access.
Provides a seamless user experience in offline mode.
7. Design Implementation
Smooth Interactions: Implemented fluid swipe gestures for task transitions.
Responsiveness: Optimized for performance across different devices.
Accuracy: Closely follows the specified design guidelines and color schemes.
How to Run the Project

Prerequisites
Flutter SDK: Install Flutter
Development IDE: Android Studio or VS Code with Flutter extensions
SQLite: No additional setup required; uses Flutter's sqflite package
Steps to Run
Clone the Repository:
bash
Copy code
git clone https://github.com/your-username/bumba_app.git
cd bumba_app
Install Dependencies:
bash
Copy code
flutter pub get
Run the Application:
bash
Copy code
flutter run
Select your target device (emulator or physical device).
