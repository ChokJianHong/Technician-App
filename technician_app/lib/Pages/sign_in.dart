// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:technician_app/API/getToken.dart';
import 'package:technician_app/API/signInAPI.dart';
import 'package:technician_app/Assets/Components/button.dart';
import 'package:technician_app/Assets/Components/text_box.dart';
import 'package:technician_app/Pages/home.dart';
import 'package:technician_app/core/configs/theme/appColors.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  // Initialize the FlutterSecureStorage
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    _checkLoggedInStatus();
  }

  // Check if a valid token exists in storage
  Future<void> _checkLoggedInStatus() async {
    final token = await storage.read(key: 'userToken');

    if (token != null) {
      // If a token exists, navigate directly to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(token: token)),
      );
    }
  }

  // Forgot Password Function
  void _forgotPassword() async {
    final TextEditingController emailController = TextEditingController();
    String? userType = 'customer'; // Default user type

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Forgot Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration:
                    const InputDecoration(labelText: 'Enter your email'),
              ),
              DropdownButton<String>(
                value: userType,
                onChanged: (String? newValue) {
                  setState(() {
                    userType = newValue!;
                  });
                },
                items: <String>['customer', 'technician']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final email = emailController.text;

                if (email.isEmpty || !EmailValidator.validate(email)) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please enter a valid email')));
                  return;
                }

                try {
                  final response = await http.post(
                    Uri.parse(
                        'http://82.112.238.13:5005/dashboarddatabase/forgot-password'),
                    headers: {'Content-Type': 'application/json'},
                    body: json.encode({
                      'email': email,
                      'userType': userType,
                    }),
                  );

                  final responseData = json.decode(response.body);
                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(responseData['message'] ??
                            'Password reset email sent!')));
                    Navigator.pop(context); // Close the dialog
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(responseData['message'] ??
                            'Failed to send reset email')));
                  }
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error occurred: $error')));
                }
              },
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  bool _validateInputs() {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || !EmailValidator.validate(email)) {
      setState(() {
        errorMessage = 'Please enter a valid email address.';
      });
      return false;
    }

    if (password.isEmpty) {
      setState(() {
        errorMessage = 'Password cannot be empty.';
      });
      return false;
    }

    return true;
  }

  void _signIn() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    if (!_validateInputs()) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final api = SignInAPI();
      final userData =
          await api.loginUser(emailController.text, passwordController.text);

      // Assuming the token is returned in the 'token' field
      final token = userData['token'];
      print('Token: $token');

      // Store the token securely
      const storage = FlutterSecureStorage();
      await storage.write(key: 'userToken', value: token);

      // Fetch customer details using the token
      await _getTechnicianDetails(token);

      // Navigate to home page or handle success
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  token: token,
                )),
      );
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _getTechnicianDetails(String token) async {
    try {
      // ignore: non_constant_identifier_names
      final TechnicianTokenApi = GetToken();
      final technicinaData = await TechnicianTokenApi.getUserToken(token);
      print('Technician Data: $technicinaData');
      // Handle customer data (e.g., store it, display it, etc.)
    } catch (e) {
      print('Error fetching technician details: $e');
      // Handle errors accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'lib/Assets/Images/Logo.png',
                  width: screenWidth * 0.5,
                  height: screenHeight * 0.3,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                MyTextField(
                  controller: emailController,
                  hintText: 'Email Address',
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                if (errorMessage != null)
                  Text(errorMessage!,
                      style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.centerRight, // Aligns to the right
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                ),
                const SizedBox(height: 10),
                isLoading
                    ? const CircularProgressIndicator()
                    : MyButton(
                        text: "Sign In",
                        onTap: _signIn,
                        color: AppColors.orange,
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
