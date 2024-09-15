import 'package:flutter/material.dart';
import 'package:technician_app/core/configs/theme/app_theme.dart';
import 'package:technician_app/presentation/splash/pages/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Themed App',
      theme: AppTheme.darkTheme,
      home: const SplashPage(), // Choose the home page you want
      debugShowCheckedModeBanner: false, // Add if needed
    );
  }
}
