import 'package:flutter/material.dart';
import 'package:technician_app/Pages/Scheduel.dart';
import 'package:technician_app/assets/components/job_card.dart';
import 'package:technician_app/assets/components/navbartop.dart';
import 'package:technician_app/assets/components/BottomNav.dart'; // Adjust the path as needed

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 1; // Default index for BottomNav

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Add your navigation logic here
    // Example: navigate to different pages based on the selected index
    switch (index) {
      case 0:
        // Navigate to the "Favorites" page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FavoritesPage()),
        );
        break;
      case 1:
        // Stay on the "Home" page
        break;
      case 2:
        // Navigate to the "Settings" page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Schedule()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background Color
      backgroundColor: Theme.of(context).colorScheme.primary,

      // Top Navigation Bar
      appBar: const NavBar(
        showBackButton: false,
      ),

      // Main Content
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Centered Current Sales Section
            const Center(
              child: Column(
                children: [
                  Text(
                    'Current Sales',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Since the 1st of the month",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "RM1000.00",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 2.0,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 20),

            // Left-Aligned Current Jobs Section
            const Text(
              'Current Jobs',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 150, // Adjust the height based on content
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.1), // Semi-transparent background
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: const [
                  JobCard(title: 'Job 1', description: 'Description of Job 1'),
                  JobCard(title: 'Job 2', description: 'Description of Job 2'),
                  JobCard(title: 'Job 3', description: 'Description of Job 3'),
                  // Add more JobCards here
                ],
              ),
            ),
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
              height: 150, // Adjust the height based on content
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.1), // Semi-transparent background
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: const [
                  JobCard(
                      title: 'New Job 1',
                      description: 'Description of New Job 1'),
                  JobCard(
                      title: 'New Job 2',
                      description: 'Description of New Job 2'),
                  // Add more JobCards here
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNav(
        onTap: _onTap,
        currentIndex: _currentIndex,
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
      appBar: AppBar(title: const Text('Favorites')),
      body: const Center(child: Text('Favorites Page')),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Page')),
    );
  }
}
