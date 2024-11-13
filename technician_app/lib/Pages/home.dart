import 'package:technician_app/API/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:technician_app/Assets/Components/AppBar.dart';
import 'package:technician_app/Assets/Components/current_job.dart';
import 'package:technician_app/Assets/Components/new_jobs.dart';
import 'package:technician_app/Assets/Components/request_card.dart';
import 'package:technician_app/assets/components/BottomNav.dart';
import 'package:technician_app/core/configs/theme/appColors.dart'; // Adjust the path as needed
import 'package:jwt_decoder/jwt_decoder.dart';

class HomePage extends StatefulWidget {
  final String token;
  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;

  final FirebaseApi firebaseapi = FirebaseApi();
  late String technicianId;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
      technicianId = decodedToken['userId'].toString();
    } catch (error) {
      print('Error decoding token: $error');
      technicianId = 'default';
    } 
    firebaseapi.initNotifications(widget.token, technicianId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
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
          const SizedBox(
            height: 20,
          ),
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
