import 'package:flutter/material.dart';
import '../assets/components/text_box.dart'; // Import the custom text box widget

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo
              Image.asset('lib/assets/pictures/signinlock.png'),
              const SizedBox(height: 20),
              // Text for user
              Text(
                'Welcome Back! You’ve been missed',
                style: theme.textTheme.bodySmall,
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
              const SizedBox(height: 20),
              //Sign in button
              ElevatedButton(
                onPressed: () {
                  // Handle sign in logic
                },
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
