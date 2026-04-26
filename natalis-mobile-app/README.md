# Natalis 🩺

**AI-powered Prenatal Ultrasound Screening**

Natalis is a modern, cross-platform mobile application built with Flutter, designed to streamline the process of prenatal ultrasound screening. This application provides distinct interfaces for both doctors and patients, ensuring a secure and user-friendly experience for all users.

---

## ✨ Features

The application is currently in the initial phase of development. Here are the features implemented so far:

*   **Splash & Welcome Screen**: A beautiful entry point to the application that introduces users to Natalis and provides clear login options.
*   **Dual User Roles**: Separate login paths for Doctors and Patients.
    *   **Doctor Login**: A secure login screen for medical professionals.
    *   **Patient Login**: A streamlined entry for patients to access their information.
*   **Modern User Interface**:
    *   Built with Material 3 design principles.
    *   Consistent and reusable custom widgets for buttons, images, and input fields.
    *   Iconography provided by Font Awesome for a clean and professional look.
*   **Doctor's Home Screen**:
    *   A tabbed interface for easy navigation between Home, Patients, and Profile sections.
    *   An `AppBar` with quick access to notifications and user profiles.
    *   A Floating Action Button (FAB) to "Add new test," which opens a sleek bottom sheet for data entry.
*   **Interactive Pop-Up**: A modal bottom sheet for adding new test details, featuring text fields and a confirmation button, which is fully compatible with the on-screen keyboard.

## 🚀 Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

*   Flutter SDK (version 3.x or higher recommended)
*   A code editor like VS Code or Android Studio

### Installation

1.  **Clone the repository:**

    git clone https://github.com/your-username/natalis_frontend.git

2.  **Navigate to the project directory:**

    cd natalis_frontend

3.  **Install dependencies:**

    flutter pub get

4.  **Run the application:**

    flutter run

## 📱 Application Flow

1.  The user is greeted by the `WelcomeScreen`.
2.  The user can choose between three main actions:
    *   **Get Started**: (Placeholder for future functionality).
    *   **Doctor Login**: Navigates to the `DoctorLoginScreen` for authentication.
    *   **Patient Login**: Navigates directly to the main `HomeScreen` (for current development purposes).
3.  Upon successful login (or by tapping "Patient Login"), the user is taken to the `HomeScreen`.
4.  The `HomeScreen` features a `BottomNavigationBar` to switch between different sections of the app and a FAB for primary actions.

## 🛠️ Built With

*   **[Flutter](https://flutter.dev/)**: The cross-platform UI toolkit for building natively compiled applications.
*   **[Dart](https://dart.dev/)**: The programming language used by Flutter.
*   **[font_awesome_flutter](https://pub.dev/packages/font_awesome_flutter)**: For a rich library of icons.

