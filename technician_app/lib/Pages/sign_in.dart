import 'package:flutter/material.dart';
import 'package:technician_app/Pages/home.dart';
import '../assets/components/text_box.dart'; // Import the custom text box widget
import '../assets/components/button.dart'; // Import custom button

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInPage({super.key});

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
              Image.asset('lib/Pages/signinlock.png'),
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
              const SizedBox(height: 10),
              // Forget Password
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Forgot Password",
                  style: TextStyle(
                      color: Color(0xFF828282),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SF Pro'),
                ),
              ),
              const SizedBox(height: 20),
              //Sign in button
              MyButton(text: "Sign In", onTap: () {
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
              })
            ],
          ),
        ),
      ),
    );
  }
}
