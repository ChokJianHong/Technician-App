import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
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
    return CurvedNavigationBar(
      index: currentIndex,
      backgroundColor: Colors.transparent,
      color: AppColors.secondary,
      buttonBackgroundColor: AppColors.primary,
      height: 60.0,
      onTap: (index) {
        _navigateToPage(context, index, token); // Pass token here
      },
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
        ),
      ],
    );
  }
}

// Update the navigation function to accept the token
void _navigateToPage(BuildContext context, int index, String token) {
  switch (index) {
    case 0:
      
      break;
    case 1:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(token: token,)),
      );
      break;
    case 2:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>  Schedule(token: token,), // Pass token correctly
        ),
      );
      break;
    default:
      // Handle default case if necessary
      break;
  }
}
