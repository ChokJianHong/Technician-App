import 'package:flutter/material.dart';

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

  const NavBar({super.key, 
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
              // Default to settings icon if no custom leading widget is provided
              IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  // Handle settings action
                },
              ),
      actions: [
        // Always include the notifications icon
        IconButton(
          icon: const Icon(
            Icons.notifications,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            // Handle notifications action
          },
        ),
        // Include additional actions provided as parameters
        ...additionalActions,
      ],
      backgroundColor:
          Theme.of(context).colorScheme.secondary, // Customize as needed
      elevation: 0, // Optionally remove shadow for a flatter look
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
