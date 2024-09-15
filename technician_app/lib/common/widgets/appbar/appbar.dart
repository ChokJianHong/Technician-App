import 'package:flutter/material.dart';
import 'package:technician_app/core/configs/theme/app_colors.dart';

/*
NAVIGATION BAR

The top navigation bar of the application with fixed settings and notifications icons.
----------------------------------------------------

To use this widget, you need:

- additionalActions (List<Widget>): A list of additional widgets to display on the right side of the AppBar, 
  such as custom icons or buttons. The notifications icon is always included on the right side.
- leading (Widget?): A widget to display on the left side of the AppBar, such as the settings icon.
- showBackButton (bool): A flag to determine whether to show a default back button 
  on the left side. Set to true to display a back arrow that navigates to the previous screen.
*/

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
                Navigator.of(context).pop();
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
      // Optional: Add flexibleSpace if you need more customizations
      flexibleSpace: Container(
        decoration: const BoxDecoration(color: AppColors.primary),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
