import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final Function(int) onTap;
  final int currentIndex;

  BottomNav({required this.onTap, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: currentIndex,
      backgroundColor: Color(0xFF391370),
      color: Color(0xFF4E31AA),
      onTap: onTap,
      items: [
        Icon(
          Icons.favorite,
          color: Colors.white,
          size: 40,
        ),
        Icon(
          Icons.home,
          color: Colors.white,
          size: 40,
        ),
        Icon(
          Icons.settings,
          color: Colors.white,
          size: 40,
        )
      ],
    );
  }
}
