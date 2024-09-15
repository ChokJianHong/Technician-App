import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final Function(int) onTap;
  final int currentIndex;

  const BottomNav({super.key, required this.onTap, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: currentIndex,
      backgroundColor: Colors.transparent, // Transparent background
      color: const Color(0xFF4E31AA), // Background color of the bar
      buttonBackgroundColor: const Color(0xFF391370), // Color of the central button
      height: 60.0, // Adjusted height for better icon size
      onTap: onTap,
      items: const [

        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Icon(
            Icons.favorite,
            color: Colors.white,
            size: 40,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Icon(
            Icons.home,
            color: Colors.white,
            size: 40,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Icon(
            Icons.settings,
            color: Colors.white,
            size: 40,
          ),
        )

      ],
    );
  }
}
