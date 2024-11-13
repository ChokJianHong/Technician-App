import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

const baseUrl = "http://82.112.238.13:5005"; // Adjust if needed

Future<void> handleBackgroundMessage(RemoteMessage message) async{
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications(String token, String technicianId) async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Technician token: $token');
    print('Technician ID: $technicianId');
    print('Token: $fCMToken');

    if (fCMToken != null) {
      // Insert the FCM token into the database
      await saveFcmTokenToDatabase(token, technicianId, fCMToken);
      
    }

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    
  }

  Future<Map<String, dynamic>> saveFcmTokenToDatabase(String token, String technicianId,String fCMToken) async {
    try {
      print('Function did get activated');
      final response = await http.post(
        Uri.parse('$baseUrl/dashboarddatabase/technician/$technicianId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token, // Replace with actual auth token
          'userType': 'technician',
        },
        body: jsonEncode({
          'technicianId': technicianId,
          'fcmToken': fCMToken,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': 'FCM token saved successfully'};
      } else {
        return {'success': false, 'message': 'Failed to save FCM token'};
      }
    } catch (err) {
      return {'success': false, 'message': 'Error: $err'};
    }
  }
}