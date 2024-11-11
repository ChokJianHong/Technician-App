import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:technician_app/API/getTechnician.dart';
import 'package:technician_app/Assets/Components/button.dart';
import 'package:technician_app/Assets/Components/settingItem.dart';
import 'package:technician_app/Pages/sign_in.dart';
import 'package:technician_app/core/configs/theme/appColors.dart';

class Setting extends StatefulWidget {
  final String token;
  const Setting({super.key, required this.token});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String technicianName = "Loading...";
  String technicianEmail = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchTechnicianDetails();
  }

  Future<void> _fetchTechnicianDetails() async {
    print('Token: ${widget.token}'); // Debugging line

    try {
      // Decode the token to get technician ID
      Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
      final technicianId = decodedToken['userId'];
      if (technicianId == null) {
        throw Exception('Token does not contain userId');
      }

      // Fetch technician details using TechnicianService API
      final technicianDetails = await TechnicianService.getTechnician(
          widget.token, technicianId.toString());
      print('Technician details: $technicianDetails'); // Debugging line

      // Extract the first technician entry from the 'technician' list
      final technicianData =
          (technicianDetails['technician'] as List).isNotEmpty
              ? technicianDetails['technician'][0]
              : null;

      if (technicianData == null) {
        throw Exception('No technician data found');
      }

      // Set state to update the UI with the technician's name and email
      setState(() {
        technicianName = technicianData['name'] ?? 'Unknown Name';
        technicianEmail = technicianData['email'] ?? 'Unknown Email';
      });
    } catch (error) {
      print('Error fetching technician details: $error');
      setState(() {
        technicianName = 'Error loading name';
        technicianEmail = 'Error loading email';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Account Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.darkTeal,
      ),
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          // Profile Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            color: AppColors.primary,
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      AssetImage('lib/Assets/Images/smallProfile.png'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      technicianName,
                      style: const TextStyle(
                        color: AppColors.lightgrey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      technicianEmail,
                      style: const TextStyle(
                        color: AppColors.lightgrey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Settings List
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero, // Remove padding to prevent extra space
              children: [
                Container(
                  color: AppColors.darkTeal,
                  child: const Column(
                    children: [
                      SettingItem(title: 'Notification Settings'),
                      SettingItem(title: 'Help Center'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sign Out Button
          Padding(
            padding: const EdgeInsets.only(
                bottom: 16.0), // Adds space around the button
            child: MyButton(
              text: 'Sign Out',
              color: AppColors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInPage(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
