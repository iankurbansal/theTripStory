import 'dart:io' show Platform;

enum EnvironmentProfile { local, remote }

class Environment {
  static const String _defaultProfile = String.fromEnvironment(
    'FLUTTER_PROFILE',
    defaultValue: 'local',
  );

  static EnvironmentProfile get currentProfile {
    switch (_defaultProfile.toLowerCase()) {
      case 'remote':
      case 'production':
        return EnvironmentProfile.remote;
      case 'local':
      case 'development':
      default:
        return EnvironmentProfile.local;
    }
  }

  // API Configuration
  static String get apiBaseUrl {
    switch (currentProfile) {
      case EnvironmentProfile.local:
        return const String.fromEnvironment(
          'API_BASE_URL_LOCAL',
          defaultValue: 'http://localhost:8080/api',
        );
      case EnvironmentProfile.remote:
        return const String.fromEnvironment(
          'API_BASE_URL_REMOTE',
          defaultValue: 'https://thetripstory-production.up.railway.app/api',
        );
    }
  }

  // Firebase Configuration
  static String get firebaseApiKey {
    return const String.fromEnvironment(
      'FIREBASE_API_KEY',
      defaultValue: 'AIzaSyCXGUVBaRIx5us9UH08CuJQCADofaCQZ2Q',
    );
  }

  static String get firebaseAuthDomain {
    return const String.fromEnvironment(
      'FIREBASE_AUTH_DOMAIN',
      defaultValue: 'tripstory-1f299.firebaseapp.com',
    );
  }

  static String get firebaseProjectId {
    return const String.fromEnvironment(
      'FIREBASE_PROJECT_ID',
      defaultValue: 'tripstory-1f299',
    );
  }

  static String get firebaseStorageBucket {
    return const String.fromEnvironment(
      'FIREBASE_STORAGE_BUCKET',
      defaultValue: 'tripstory-1f299.firebasestorage.app',
    );
  }

  static String get firebaseMessagingSenderId {
    return const String.fromEnvironment(
      'FIREBASE_MESSAGING_SENDER_ID',
      defaultValue: '425476392775',
    );
  }

  static String get firebaseAppId {
    return const String.fromEnvironment(
      'FIREBASE_APP_ID',
      defaultValue: '1:425476392775:web:203d9178d0dae1715eee62',
    );
  }

  // Mapbox Configuration (for backend)
  static String get mapboxAccessToken {
    return const String.fromEnvironment(
      'MAPBOX_ACCESS_TOKEN',
      defaultValue: '',
    );
  }

  // Debug utilities
  static bool get isLocal => currentProfile == EnvironmentProfile.local;
  static bool get isRemote => currentProfile == EnvironmentProfile.remote;
  
  static void printConfiguration() {
    print('=== Environment Configuration ===');
    print('Profile: ${currentProfile.name}');
    print('API Base URL: $apiBaseUrl');
    print('Firebase Project ID: $firebaseProjectId');
    print('Mapbox Token Available: ${mapboxAccessToken.isNotEmpty}');
    print('================================');
  }
}