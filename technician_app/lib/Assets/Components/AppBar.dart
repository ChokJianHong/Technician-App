import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(


      leading: const Icon(Icons.settings, color: Colors.white,),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Icon(Icons.notifications, color: Colors.white,),
        )
        ],
      backgroundColor: const Color(0xFF4E31AA),
      

    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
