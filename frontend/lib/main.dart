import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_config.dart';
import 'screens/auth_wrapper.dart';
import 'screens/login_screen.dart' as screens;
import 'screens/create_account_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/trip_details_screen.dart';
import 'screens/create_trip_screen.dart';
import 'screens/destinations_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase with secure environment variables
  await Firebase.initializeApp(options: FirebaseConfig.web);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip Story',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const AuthWrapper(), // Start with auth wrapper
      routes: {
        '/login': (context) => screens.LoginScreen(),
        '/create-account': (context) => CreateAccountScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/trip-details': (context) => TripDetailsScreen(),
        '/create-trip': (context) => CreateTripScreen(),
        '/destinations': (context) => DestinationsScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}