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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Auto Gate',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Image.asset('lib/Assets/Images/problem.png'),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Address',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white),
              ),
              const Text(
                '226A, Jalan Abdul Razak, 93200, Kuching Sarawak',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Brand',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          'Eden Robot',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 115,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Model',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          'eGate X1 Mini',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          '16 March 2024',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 90,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Time',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          '4:30PM',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Description of the Problem',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              const TextField(
                maxLines: 3,
                style: TextStyle(color: Colors.black, fontSize: 16),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  hintText: 'There is no response of the autogate working',
                ),
              ),
            ],
          ),
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
