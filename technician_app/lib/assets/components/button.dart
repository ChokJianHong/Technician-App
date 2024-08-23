import 'package:flutter/material.dart';

/* 

BUTTON

A simple button.

--------------------------------------------------------------------------------

To use this widget, you need:

- text
- a function ( on tap )


*/

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Padding inside
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            // Color of the button
            color: Theme.of(context).colorScheme.tertiary,
            // Curved corners
            borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFFCFEFE),
                fontSize: 16),
          ),
        ),
      ),
    );
  }
}
