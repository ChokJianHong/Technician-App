import 'package:flutter/material.dart';
import 'package:technician_app/Assets/Components/AppBar.dart';
import 'package:technician_app/Assets/Components/current_job.dart';
import 'package:technician_app/Assets/Components/new_jobs.dart';
import 'package:technician_app/Assets/Components/request_card.dart';
import 'package:technician_app/assets/components/BottomNav.dart'; // Adjust the path as needed

class HomePage extends StatefulWidget {
  final String token;
  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: CustomAppBar(token: widget.token),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          const SizedBox(height: 10),
          const Text(
            'Current Jobs',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          CurrentJobs(token: widget.token),
          const SizedBox(height: 20),
          const Text(
            'New Jobs',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          NewJobs(token: widget.token),
          const SizedBox(height: 20),
          const Text(
            'Part Requests',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          RequestCard(token: widget.token),
        ],
      ),
      bottomNavigationBar: BottomNav(
        onTap: _onTap,
        currentIndex: _currentIndex,
        token: widget.token,
      ),
    );
  }
}
