import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/create_account_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/trip_details_screen.dart';
import 'screens/create_trip_screen.dart';
import 'screens/destinations_screen.dart';

void main() {
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
      home: LoginScreen(), // Start with login screen
      routes: {
        '/login': (context) => LoginScreen(),
        '/create-account': (context) => CreateAccountScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/trip-details': (context) => TripDetailsScreen(),
        '/create-trip': (context) => CreateTripScreen(),
        '/destinations': (context) => DestinationsScreen(),
      },
    );
  }
}