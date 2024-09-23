import 'package:flutter/material.dart';
import 'package:technician_app/common/widgets/botnavbar/bottom_navbar.dart';
import 'package:technician_app/presentation/home/pages/home.dart';
import 'package:technician_app/presentation/schedule/pages/schedule.dart';
import 'package:technician_app/presentation/history/history.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  int _previousIndex = 0; // Keep track of the previous index

  final List<Widget> _pages = [
    const HomePage(),
    const Schedule(),
    const History(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _previousIndex = _selectedIndex; // Update previous index before changing
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration:
            const Duration(milliseconds: 300), // Duration of the transition
        transitionBuilder: (Widget child, Animation<double> animation) {
          // Determine direction of the slide based on previous vs current index
          final offsetBegin = _previousIndex < _selectedIndex
              ? const Offset(1.0, 0.0) // Slide in from the right
              : const Offset(-1.0, 0.0); // Slide in from the left

          return SlideTransition(
            position: Tween<Offset>(
              begin: offsetBegin,
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut, // Smoother transition curve
            )),
            child: child,
          );
        },
        child:
            _pages[_selectedIndex].withKey(_selectedIndex), // Assign unique key
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// Helper extension to assign a unique key to the current widget
extension WithKey on Widget {
  Widget withKey(int key) => KeyedSubtree(key: ValueKey(key), child: this);
}
