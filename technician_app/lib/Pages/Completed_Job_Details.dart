import 'package:flutter/material.dart';
import 'package:technician_app/Assets/Components/BottomNav.dart';
import 'package:technician_app/Assets/Components/AppBar.dart';

class Complete_Job_Details extends StatefulWidget {
  const Complete_Job_Details({super.key});

  @override
  State<Complete_Job_Details> createState() => _Complete_Job_DetailsState();
}

class _Complete_Job_DetailsState extends State<Complete_Job_Details> {
  int _currentIndex = 1;

  void _onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xFF391370),
      appBar: const CustomAppBar(),

      bottomNavigationBar: BottomNav(
        onTap: _onTapTapped,
        currentIndex: _currentIndex,
      ),
    );
  }
}
