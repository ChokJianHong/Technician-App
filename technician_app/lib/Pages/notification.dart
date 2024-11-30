import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:technician_app/Assets/Components/notification_manager.dart';
import 'package:technician_app/core/configs/theme/appColors.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkTeal,
        title: const Text(
          'Notifications',
          style: TextStyle(color: AppColors.lightgrey),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: () {
              // Clear all notifications
              Provider.of<NotificationManager>(context, listen: false)
                  .clearNotifications();
            },
          ),
        ],
      ),
      body: Consumer<NotificationManager>(
        builder: (context, notificationManager, child) {
          // If no notifications, show a placeholder
          if (notificationManager.notifications.isEmpty) {
            return const Center(
              child: Text('No notifications yet.'),
            );
          }

          // Otherwise, show the list of notifications
          return ListView.builder(
            itemCount: notificationManager.notifications.length,
            itemBuilder: (context, index) {
              final notification = notificationManager.notifications[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(notification["title"] ?? "No Title"),
                  subtitle: Text(notification["body"] ?? "No Content"),
                  leading: const Icon(Icons.notifications),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
