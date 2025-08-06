import 'package:firebase_core/firebase_core.dart';

// Firebase configuration using environment variables for security
// Falls back to working values if environment variables are not set
class FirebaseConfig {
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_API_KEY', defaultValue: 'AIzaSyCXGUVBaRIx5us9UH08CuJQCADofaCQZ2Q'),
    authDomain: String.fromEnvironment('FIREBASE_AUTH_DOMAIN', defaultValue: 'tripstory-1f299.firebaseapp.com'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'tripstory-1f299'),
    storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: 'tripstory-1f299.firebasestorage.app'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: '425476392775'),
    appId: String.fromEnvironment('FIREBASE_APP_ID', defaultValue: '1:425476392775:web:203d9178d0dae1715eee62'),
    measurementId: String.fromEnvironment('FIREBASE_MEASUREMENT_ID', defaultValue: 'G-DWV3Z3GQ69')
  );
}