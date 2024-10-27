

import 'package:flutter/material.dart';
import 'package:technician_app/Pages/History.dart';
import 'package:technician_app/Pages/Scheduel.dart';
import 'package:technician_app/Pages/home.dart';
import 'package:technician_app/core/configs/theme/appColors.dart';

class BottomNav extends StatelessWidget {
  final Function(int) onTap;
  final int currentIndex;
  final String token;

  const BottomNav({
    super.key,
    required this.onTap,
    required this.currentIndex,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _navigateToPage(context, index, token), // Handle tap
      backgroundColor: Colors.white, // Clean background
      selectedItemColor: AppColors.primary, // Professional highlight color
      unselectedItemColor: Colors.grey, // Subtle unselected color
      showSelectedLabels: true, // Show labels for clarity
      showUnselectedLabels: false, // Hide labels for unselected items
      type: BottomNavigationBarType.fixed, // Ensures all icons are visible
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }

  void _navigateToPage(BuildContext context, int index, String token) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => History(token: token),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(token: token),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Schedule(token: token),
          ),
        );
        break;
      default:
        break;
    }
  }
}
