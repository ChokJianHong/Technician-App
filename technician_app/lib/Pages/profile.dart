import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final String token;
  const Profile({super.key, required this.token});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
