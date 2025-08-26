import 'package:firebase_core/firebase_core.dart';
import 'config/environment.dart';

// Firebase configuration using environment variables for security
// Falls back to working values if environment variables are not set
class FirebaseConfig {
  static FirebaseOptions get web => FirebaseOptions(
    apiKey: Environment.firebaseApiKey,
    authDomain: Environment.firebaseAuthDomain,
    projectId: Environment.firebaseProjectId,
    storageBucket: Environment.firebaseStorageBucket,
    messagingSenderId: Environment.firebaseMessagingSenderId,
    appId: Environment.firebaseAppId,
  );
}