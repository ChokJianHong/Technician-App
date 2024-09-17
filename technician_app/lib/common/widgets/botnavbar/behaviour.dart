import 'package:flutter/material.dart';
import 'package:technician_app/common/widgets/botnavbar/bottom_navbar.dart'; // Import BottomNavbar
import 'package:technician_app/presentation/home/pages/home.dart'; // Import HomePage
import 'package:technician_app/presentation/schedule/schedule.dart'; // Import Schedule
import 'package:technician_app/presentation/history/history.dart'; // Import History

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const Schedule(),
    const History(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavbar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
