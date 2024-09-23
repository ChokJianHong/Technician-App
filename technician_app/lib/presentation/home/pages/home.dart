import 'package:flutter/material.dart';
import 'package:technician_app/common/widgets/appbar/appbar.dart';
import 'package:technician_app/presentation/home/widgets/current_jobs.dart';
import 'package:technician_app/presentation/home/widgets/current_sales.dart';
import 'package:technician_app/presentation/home/widgets/new_jobs.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // Sample job data for demonstration
  final List<Map<String, String>> jobData = [
    {
      'name': 'Dylan',
      'description': 'The gate has multiple problems and does not work',
      'status': 'Ongoing',
    },
    {
      'name': 'Alex',
      'description': 'Need to replace the light bulb in the office',
      'status': 'Completed',
    },
    {
      'name': 'Alex',
      'description': 'Need to replace the light bulb in the office',
      'status': 'Completed',
    },
    {
      'name': 'Alex',
      'description': 'Need to replace the light bulb in the office',
      'status': 'Completed',
    },
    {
      'name': 'Alex',
      'description': 'Need to replace the light bulb in the office',
      'status': 'Completed',
    },
    // Add more job data here as needed
  ];

  final List<Map<String, String>> newjobData = [
    {
      'name': 'Fix Air Conditioner',
      'location': 'Office Building A',
      'jobtype': 'Alarm',
      'status': 'Emergency'
    },
    {
      'name': 'Install Security Camera',
      'location': 'Parking Lot B',
      'jobtype': 'Autogate',
      'status': 'Urgent'
    },
    {
      'name': 'Replace Light Bulbs',
      'location': 'Conference Room 3',
      'jobtype': 'Alarm',
      'status': 'Normal'
    },
    {
      'name': 'Upgrade Network Switch',
      'location': 'Server Room',
      'jobtype': 'Autogate',
      'status': 'Normal'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // Top Navigation Bar
      appBar: const NavBar(
        showBackButton: false, // No back button in the top navigation bar
      ),

      // Main content of the HomePage
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, // Responsive horizontal padding
          vertical: screenHeight * 0.02, // Responsive vertical padding
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Centered Current Sales Section
            const CurrentSales(),
            const SizedBox(height: 20),
            const SizedBox(height: 20),

            // Left-Aligned Current Jobs Section
            CurrentJobsSection(jobData: jobData),
            const SizedBox(height: 10),

            // Left-Aligned New Jobs Section
            NewJobsSection(newjobData: newjobData),

          ],
        ),
      ),
    );
  }
}
