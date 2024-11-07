// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:technician_app/Pages/setting.dart';
import 'package:technician_app/core/configs/theme/appColors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String token;
  const CustomAppBar({
    super.key,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.settings),
        color: AppColors.lightgrey,
        onPressed: () {
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
            color: AppColors.lightgrey,
          ),
        )
      ],
      backgroundColor: AppColors.darkTeal,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
