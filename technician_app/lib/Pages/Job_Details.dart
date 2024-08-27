import 'package:flutter/material.dart';
import 'package:technician_app/Assets/Components/AppBar.dart';
import 'package:technician_app/Assets/Components/BottomNav.dart';

class JobDetails extends StatefulWidget {
  const JobDetails({super.key});

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {

  int _currentIndex = 1;

  void _onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF391370),
      appBar: CustomAppBar(),
      bottomNavigationBar: BottomNav(
        onTap: _onTapTapped,
        currentIndex: _currentIndex,
      ),
    );
  }
}