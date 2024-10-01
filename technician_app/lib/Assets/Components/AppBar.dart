// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:technician_app/Pages/setting.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String token;
  const CustomAppBar({
    super.key,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        child: const Icon(
          Icons.settings,
          color: Colors.white,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Setting(
                      token: token,
                    )),
          );
        },
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Icon(
            Icons.notifications,
            color: Colors.white,
          ),
        )
      ],
      backgroundColor: const Color(0xFF4E31AA),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
