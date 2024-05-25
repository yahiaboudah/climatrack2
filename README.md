# ClimaTrack

**ClimaTrack** is a comprehensive climate monitoring system designed to track temperature and humidity across various rooms. This project leverages the power of Firebase for real-time data storage and user authentication, and it utilizes Flutter for a seamless, cross-platform mobile application experience. ClimaTrack is an ideal solution for anyone looking to monitor environmental conditions in different rooms, with features for both regular users and administrators.

The code for the ESP8266 programming can be found in the **arch/esp8266_conf/** folder.

## Features

### User Roles
- **Regular Users**:
  - View monitored rooms with real-time temperature and humidity data.
  - Bookmark rooms for easy access.

- **Admin Users**:
  - Manage rooms, including adding and deleting rooms.
  - View user list and manage users.

### User Interface
- **Home Page**: A welcome page with options to log in or sign up.
- **Login Page**: A login form for existing users.
- **Sign Up Page**: A registration form for new users.
- **Monitor Page**: A room monitoring page.
- **Dashboard Page**: A dashboard for seeing temperature and humidity.
- **Bookmarks Page**: A page for timestamped bookmarks.
- **Settings Page**: A page for settings including logging out.
- **Home Page (Admin)**: A dashboard for administrators with navigation to Rooms, Users, and Settings pages.
- **Rooms Page (Admin)**: To manage available rooms.
- **Users Page (Admin)**: To manage users in the DB.


### Authentication
- User authentication and management via Firebase Authentication.
- Real-time data updates and synchronization via Firebase Firestore.

## Getting Started

To run this project locally, follow these steps:

1. **Clone the repository**:
    ```sh
    git clone https://github.com/your-repository/climatrack2.git
    cd climatrack2
    ```

2. **Install dependencies**:
    ```sh
    flutter pub get
    ```

3. **Configure Firebase**:
   - Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/).
   - Add an Android and/or iOS app to your Firebase project.
   - Follow the instructions to configure the **Flutter*** app.

4. **Run the app**:
    ```sh
    flutter run
    ```

## Project Structure

- `lib/`: Contains the main Flutter application code.
  - `main.dart`: Entry point of the application.
  - `screens/`: Contains the different screen widgets for the app.
     - `screens/adminBar`: Screens related to Admin.
     - `screens/bar`: Screens for normal users.
  - `services/`: Contains service classes for authentication and database interaction.
  - `models/`: The app models: Bookmarks and Rooms.
  - `constants/`: App constants (adminUID).
- `images/`: Contains image assets used in the application.

## Dependencies

- Firebase Core
- Firebase Authentication
- Firebase Cloud Firestore
- Intl
- Flutter launcher icons
