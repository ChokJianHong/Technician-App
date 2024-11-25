import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:technician_app/Assets/Model/notification_model.dart';
import 'package:logging/logging.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Create a logger instance
  final Logger _logger = Logger('NotificationPage');
  
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        // Log the message instead of print
        _logger.info('Foreground notification received: ${message.notification!.title}');

        setState(() {
          notifications.add(NotificationModel.fromMap(message.data));
        });
      }
    });

    // Listen for background messages
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      if (message.notification != null) {
        // Log the message instead of print
        _logger.info('Background notification received: ${message.notification!.title}');

        setState(() {
          notifications.add(NotificationModel.fromMap(message.data));
        });
      }
      return Future.value();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: notifications.isEmpty
          ? const Center(child: Text('No notifications yet.'))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  title: Text(notification.title),
                  subtitle: Text(notification.body),
                  onTap: () {
                    // Handle the notification tap
                    _logger.info("Notification tapped: ${notification.title}");
                  },
                );
              },
            ),
    );
  }
}
