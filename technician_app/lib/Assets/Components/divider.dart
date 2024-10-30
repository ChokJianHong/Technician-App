import 'package:flutter/material.dart';

class ADivider extends StatelessWidget {
  const ADivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      thickness: 1,
      endIndent: 10,
      color: Colors.white,
    );
  }
}
