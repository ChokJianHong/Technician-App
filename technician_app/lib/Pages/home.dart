// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:technician_app/assets/components/navbartop.dart';
import 'package:technician_app/assets/components/BottomNav.dart'; // Adjust the path as needed
import '../assets/components/current_sales.dart';
import '../assets/components/current_jobs.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 1; // Default index for BottomNav

  // Sample job data for demonstration
  final List<Map<String, String>> jobData = [
    {
      'name': 'Dylan',
      'description': 'The gate has multiple problems and does not work',
      'status': 'Ongoing',
    },
    {
      'name': 'Alex',
      'description': 'Need to replace the light bulb in the office',
      'status': 'Completed',
    },
    {
      'name': 'Alex',
      'description': 'Need to replace the light bulb in the office',
      'status': 'Completed',
    },
    {
      'name': 'Alex',
      'description': 'Need to replace the light bulb in the office',
      'status': 'Completed',
    },
    {
      'name': 'Alex',
      'description': 'Need to replace the light bulb in the office',
      'status': 'Completed',
    },
    // Add more job data here as needed
  ];

  // Method to handle tap events on BottomNav
  void _onTap(int index) {
    setState(() {
      _currentIndex = index; // Update the current index based on user selection
    });

    // Navigation logic based on selected index
    switch (index) {
      case 0:
        // Navigate to the "Favorites" page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FavoritesPage()),
        );
        break;
      case 1:
        // Stay on the "Home" page (no action needed)
        break;
      case 2:
        // Navigate to the "Settings" page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background color for the HomePage
      backgroundColor: Theme.of(context).colorScheme.primary,

      // Top Navigation Bar
      appBar: const NavBar(
        showBackButton: false, // No back button in the top navigation bar
      ),

      // Main content of the HomePage
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Centered Current Sales Section
            CurrentSales(),
            const SizedBox(height: 20),
            Divider(color: Theme.of(context).colorScheme.secondary),
            const SizedBox(height: 20),

            // Left-Aligned Current Jobs Section
            CurrentJobsSection(jobData: jobData),
            const SizedBox(height: 20),

            // Left-Aligned New Jobs Section
            const Text(
              'New Jobs',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 150, // Height for the ListView of new job cards
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.1), // Semi-transparent background
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                // Add new job cards here if needed
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNav(
        onTap: _onTap,
        currentIndex: _currentIndex, // Set the current index for BottomNav
      ),
    );
  }
}

// Dummy pages for navigation
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Favorites')), // Title for the Favorites page
      body: const Center(
          child: Text('Favorites Page')), // Content for the Favorites page
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Settings')), // Title for the Settings page
      body: const Center(
          child: Text('Settings Page')), // Content for the Settings page
    );
  }
}
