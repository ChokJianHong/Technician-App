import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Your splash background color
      body: Center(
        child: Image.asset(
          'lib/Assets/Images/Logo.png',
          width: 150, // Adjust size
        ),
      ),
    );
  }
}
