// ignore_for_file: library_private_types_in_public_api

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:technician_app/API/getToken.dart';
import 'package:technician_app/API/signInAPI.dart';
import 'package:technician_app/Assets/Components/button.dart';
import 'package:technician_app/Assets/Components/text_box.dart';
import 'package:technician_app/Pages/home.dart';

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
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('lib/Assets/Images/signinlock.png'),
                const SizedBox(height: 20),
                const Text("Welcome Back! You've been missed",
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.white)),
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
                        color: const Color(0xFF41336D),
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
