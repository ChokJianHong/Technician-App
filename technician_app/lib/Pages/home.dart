import 'package:flutter/material.dart';
import 'package:technician_app/assets/components/navbartop.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background Color
      backgroundColor: Theme.of(context).colorScheme.primary,

      // Top Navigation Bar
      appBar: const NavBar(
        showBackButton: false,
      ),

      // Text
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the body content
        child: Column(
          mainAxisSize: MainAxisSize
              .max, // Ensure the Column takes up full vertical space
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center content horizontally
          children: <Widget>[
            const Center(
              // Ensure the text is horizontally centered
              // Current Sales Text
              child: Text(
                'Current Sales',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24, // Adjust font size as needed
                  color: Colors.white,
                ),
              ),
            ),
            // Since the 1st of the month Text
            const Center(
              child: Text(
                "Since the 1st of the month",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Number of Sales for the month
            const Center(
              child: Text(
                "RM1000.00",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 2.0,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      // Add Bottom Navigation Bar here if needed
    );
  }
}
