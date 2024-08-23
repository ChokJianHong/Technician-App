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
