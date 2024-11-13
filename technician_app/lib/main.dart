import 'package:flutter/material.dart';
import 'package:technician_app/Pages/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Themed App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3A1078),
          primary: const Color(0xFF1A1521),
          secondary: const Color(0xFF4E31AA),
          tertiary: const Color(0xFF3795BD),
        ),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF1A1521), // Hex color for AppBar
        ),
        textTheme: const TextTheme(
          bodySmall: TextStyle(
            fontSize: 14,
            color: Color(0xFFFCFEFE),
            fontFamily: 'SF Pro',
          ),
        ),
      ),

      home: const SignInPage(), // Choose the home page you want

      debugShowCheckedModeBanner: false, // Add if needed
    );
  }
}
