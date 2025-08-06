import 'package:firebase_core/firebase_core.dart';

// Firebase configuration using environment variables for security
class FirebaseConfig {
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_API_KEY', defaultValue: 'your-api-key-here'),
    authDomain: String.fromEnvironment('FIREBASE_AUTH_DOMAIN', defaultValue: 'your-project.firebaseapp.com'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'your-project-id'),
    storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: 'your-project.firebasestorage.app'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: '123456789'),
    appId: String.fromEnvironment('FIREBASE_APP_ID', defaultValue: 'your-app-id'),
    measurementId: String.fromEnvironment('FIREBASE_MEASUREMENT_ID', defaultValue: 'G-XXXXXXXXXX')
  );
}