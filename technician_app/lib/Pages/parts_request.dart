import 'package:flutter/material.dart';
import 'package:technician_app/assets/components/navbartop.dart';
import 'package:technician_app/assets/components/BottomNav.dart'; // Adjust the path as needed
import 'package:technician_app/assets/components/text_box.dart';
import '../assets/components/details.dart'; // Import the ClientBox component
import '../assets/components/button.dart';

class Request extends StatefulWidget {
  const Request({super.key});

  @override
  State<Request> createState() => _RequestState();
}

final TextEditingController _searchController = TextEditingController();
final TextEditingController _newsearchController = TextEditingController();

class _RequestState extends State<Request> {
  int _currentIndex = 1; // Default index for BottomNav
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
    final clientData = {
      'name': 'Dylan Wong',
      'brand': 'Eden Robot',
      'model': 'eGate X1 Mini',
      'date': '16 March 2024',
      'time': '4:30PM',
    };

    return Scaffold(
      // Background Color
      backgroundColor: Theme.of(context).colorScheme.primary,

      // Top Nav Bar
      appBar: const NavBar(
        showBackButton: true,
      ),

      // Client Details
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Client Details: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            ClientBox(
              name: clientData['name']!,
              brand: clientData['brand']!,
              model: clientData['model']!,
              date: clientData['date']!,
              time: clientData['time']!,
            ),
            const SizedBox(height: 30),
            const Text(
              'Parts Request: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            MyTextField(
                controller: _searchController,
                hintText: 'Search',
                obscureText: false),
            const SizedBox(height: 30),
            const Text(
              'Parts Not in the System',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            MyTextField(
                controller: _newsearchController,
                hintText: 'Item Name',
                obscureText: false),
            const Padding(padding: EdgeInsets.only(bottom: 150)),
            MyButton(text: "Request Parts", onTap: () {})
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
