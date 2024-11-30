import 'package:flutter/material.dart';

class NotificationManager extends ChangeNotifier {
  final List<Map<String, String>> _notifications = [];

  List<Map<String, String>> get notifications => _notifications;

  // Method to add a notification after checking for duplicates
  void addNotification(Map<String, String> notification) {
    // Check if notification already exists
    bool exists = _notifications.any((existingNotification) =>
        existingNotification['title'] == notification['title'] &&
        existingNotification['body'] == notification['body']);

    if (!exists) {
      _notifications.add(notification);
      notifyListeners();
    }
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }
}
