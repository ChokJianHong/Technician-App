import 'package:flutter/material.dart';
import 'package:technician_app/common/textbox/text_box.dart';
import 'package:technician_app/core/configs/assets/app_images.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo
              Image.asset(AppImages.lock),
              const SizedBox(height: 20),
              // Text for user
              const Text(
                'Welcome Back! You’ve been missed',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              ),
              const SizedBox(height: 20),
              // Email
              MyTextField(
                  controller: emailController,
                  hintText: 'Email Address',
                  obscureText: false),
              const SizedBox(height: 20),
              // Password
              MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true),
              const SizedBox(height: 10),
              // Forget Password
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Forgot Password",
                  style: TextStyle(
                    color: Color(0xFF828282),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              //Sign in button
            ],
          ),
        ),
      ),
    );
  }
}
