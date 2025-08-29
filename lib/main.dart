import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // This will be the new main home with bottom nav

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Management',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green, // You can adjust primary color
        scaffoldBackgroundColor: const Color(0xFF1A1A2E), // Dark background from image
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF16213E), // Darker app bar
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF16213E), // Dark card background
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white.withOpacity(0.9)),
          bodyMedium: TextStyle(color: Colors.white.withOpacity(0.8)),
          labelLarge: const TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F3460), // Dark blue button
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF0F3460).withOpacity(0.7), // Darker input field
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color(0xFF16213E),
          selectedItemColor: Colors.greenAccent, // Highlight active icon
          unselectedItemColor: Colors.grey.shade600,
          type: BottomNavigationBarType.fixed,
        ),
        // Add other theme properties as needed
      ),
      home: HomeScreen(),
    );
  }
}