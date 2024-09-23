import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:technician_app/common/widgets/botnavbar/behaviour.dart';
import 'package:technician_app/core/configs/theme/app_colors.dart';
import 'package:technician_app/presentation/home/pages/home.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> additionalActions;
  final Widget? leading;
  final bool showBackButton;

  const NavBar({
    super.key,
    this.additionalActions = const [],
    this.leading,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  CupertinoPageRoute(
                    builder: (context) => const MainPage(),
                  ),
                  (route) => false, // Remove all previous routes
                );
              },
            )
          : leading ??
              IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: AppColors.icons,
                  size: 30,
                ),
                onPressed: () {
                  // Handle settings action
                },
              ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications,
            color: AppColors.icons,
            size: 30,
          ),
          onPressed: () {
            // Handle notifications action
          },
        ),
        ...additionalActions,
      ],
      backgroundColor: AppColors.primary,
      elevation: 0, // Flat look without shadow
      flexibleSpace: Container(
        decoration: const BoxDecoration(color: AppColors.primary),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
