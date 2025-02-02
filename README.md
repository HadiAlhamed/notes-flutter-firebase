# Notes

## Description
Notes is a note-taking application that allows users to create different note categories, each with its own notes. Users can add notes as text and attach images from their gallery or capture instant photos. The app also allows users to delete categories and notes as needed.

## Features
- Create and manage note categories
- Add text notes and attach images (gallery or instant photos)
- Delete categories and notes
- Seamless integration with Firebase for storage and authentication
- User-friendly interface

## Installation Instructions
To run this project, you need to have Flutter and Dart installed. Follow the steps below to set up the project:

### Prerequisites
- Install Flutter by following the official guide: [Flutter Installation](https://docs.flutter.dev/get-started/install)
- Ensure Dart is installed (comes bundled with Flutter)
- Set up a suitable IDE (VS Code, Android Studio, etc.)
- Clone this repository:
  ```bash
  git clone <repository_url>
  ```
- Navigate to the project directory:
  ```bash
  cd notes_app
  ```
- Install dependencies:
  ```bash
  flutter pub get
  ```

## Dependencies
This project relies on the following dependencies:

```yaml
version: 1.0.0+1

environment:
    sdk: ^3.6.0

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  firebase_core: ^3.10.0
  firebase_database: ^11.3.0
  cloud_firestore: ^5.6.1
  firebase_storage: ^12.4.0
  firebase_messaging: ^15.2.0
  firebase_auth: ^5.4.0
  google_sign_in: ^6.2.2
  get: ^4.6.6
  get_storage: ^2.1.1
  awesome_dialog: ^3.2.1
  image_picker: ^1.1.2
  sqflite: ^2.4.1
  path_provider: ^2.1.5

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

## Running the App
- Ensure a device or emulator is connected.
- Run the app with the following command:
  ```bash
  flutter run
  ```

## Assets
This project includes the following assets:
- `assets/images/notes.png`
- `assets/images/google_logo.png`
- `assets/images/folder.png`

## Contact Information
For any inquiries or support, reach out to:
📧 Email: hadialhamed.py@gmail.com
