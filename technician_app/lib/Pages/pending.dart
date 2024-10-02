import 'package:flutter/material.dart';
import 'package:technician_app/Assets/Components/AppBar.dart';
import 'package:technician_app/Assets/Components/BottomNav.dart';
import 'package:technician_app/core/configs/theme/appColors.dart';

class Pending extends StatefulWidget {
  final String token;
  const Pending({super.key, required this.token});

  @override
  State<Pending> createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  int _currentIndex = 1;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: CustomAppBar(token: widget.token),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Center(
              child: Text(
                'Auto Gate',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Image.asset('lib/Assets/Images/problem.png'),
            const Text("Address"),
            const Text("226A, Jalan Abdul Razak, 93200, Kuching Sarawak"),
            const Row(
              children: [
                Column(
                  children: [
                    Text('Brand'),
                    Text('Eden Robot'),
                  ],
                ),
                Column(
                  children: [
                    Text('Model'),
                    Text('eGate X1 Mini'),
                  ],
                ),
              ],
            ),
            const Row(
              children: [
                Column(
                  children: [
                    Text('Date'),
                    Text('16 March 2024'),
                  ],
                ),
                Column(
                  children: [
                    Text('Time'),
                    Text('4:30PM'),
                  ],
                ),
              ],
            ),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: null, // Allow multiple lines
                  decoration: InputDecoration(
                    hintText: " ",
                    border: InputBorder.none, // Remove border
                  ),
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        onTap: _onTap,
        currentIndex: _currentIndex,
        token: widget.token,
      ),
    );
  }
}
