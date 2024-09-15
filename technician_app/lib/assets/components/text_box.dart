import 'package:flutter/material.dart';

/* TEXT FIELD 

A box where the user can type into

----------------------------------------------------

To use this widget, you need:

- text controller (to access what the user typed)
- hint text (e.g "Enter Password")
- obscure text (e.g true --> hides pw)

*/

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        // Border when not selected
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        // Border when selected
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        fillColor: Colors.white,
        filled: true,
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF848484)),
        // Add inner padding here
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }
}
