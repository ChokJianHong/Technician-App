import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:technician_app/API/firebase_api.dart';
import 'package:technician_app/Assets/Components/notification_manager.dart';
import 'package:technician_app/Pages/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics,
  );
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Background Notification: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  runApp(
    ChangeNotifierProvider(
      create: (context) => NotificationManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FirebaseApi firebaseApi;

  @override
  void initState() {
    super.initState();
    // Initialize firebaseApi in initState to prevent LateInitializationError
    final notificationManager = context.read<NotificationManager>();
    firebaseApi = FirebaseApi(notificationManager);
    firebaseApi.initNotifications("yourTokenHere", "yourCustomerId");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground Notification: ${message.notification?.title}');
      _showNotification(message);

      // Save notification to NotificationManager
      notificationManager.addNotification({
        "title": message.notification?.title ?? "No Title",
        "body": message.notification?.body ?? "No Content",
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Themed App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3A1078),
          primary: const Color(0xFF1A1521),
          secondary: const Color(0xFF4E31AA),
          tertiary: const Color(0xFF3795BD),
        ),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF1A1521), // Hex color for AppBar
        ),
        textTheme: const TextTheme(
          bodySmall: TextStyle(
            fontSize: 14,
            color: Color(0xFFFCFEFE),
            fontFamily: 'SF Pro',
          ),
        ),
      ),
      home: const SignInPage(), // Choose the home page you want
      debugShowCheckedModeBanner: false, // Add if needed
    );
  }
}
