import 'package:flutter/material.dart';
import 'package:technician_app/Assets/Components/AppBar.dart';
import 'package:technician_app/Assets/Components/current_job.dart';
import 'package:technician_app/Assets/Components/new_jobs.dart';
import 'package:technician_app/assets/components/navbartop.dart';
import 'package:technician_app/assets/components/BottomNav.dart'; // Adjust the path as needed

class HomePage extends StatefulWidget {
  final String token;
  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1; // Default index for BottomNav

  // Method to handle BottomNav item taps
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background Color
      backgroundColor: Theme.of(context).colorScheme.primary,

      // Top Navigation Bar
      appBar: CustomAppBar(token: widget.token),

      // Main Content using ListView for scrollable content
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          // Centered Current Sales Section
          const Center(
            child: Column(
              children: [
                Text(
                  'Current Sales',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Since the 1st of the month",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "RM1000.00",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 2.0,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 20),

          // Left-Aligned Current Jobs Section
          const Text(
            'Current Jobs',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          CurrentJobs(token: widget.token),
          const SizedBox(height: 20),

          // Left-Aligned New Jobs Section
          const Text(
            'New Jobs',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),

          NewJobs(token: widget.token),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNav(
        onTap: _onTap,
        currentIndex: _currentIndex,
        token: widget.token,
      ),
    );
  }
}
