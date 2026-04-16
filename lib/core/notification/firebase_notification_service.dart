// import 'dart:convert';
// import 'dart:io';
// import 'package:peel/core/navigation/app_navigator.dart';
// import 'package:peel/injection_container.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';

// // Define the navigation handling for when a notification is tapped
// final GlobalKey<NavigatorState>  navigatorKey = sl<AppNavigator>().navigatorKey;

// // This function will be called when the app is in the background
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   debugPrint("Handling a background message: ${message.messageId}");
// }

// class FirebaseNotificationService {
//   static FirebaseMessagingInstance? _instance;

//   static FirebaseMessagingInstance get instance {
//     _instance ??= FirebaseMessagingInstance();
//     return _instance!;
//   }
// }

// class FirebaseMessagingInstance {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   String? _token;
//   String? get token => _token;

//   // Initialize FCM
//   Future<void> init() async {
//     // Initialize Firebase
//     await Firebase.initializeApp();

//     // Request notification permission for Android 13+
//     if (Platform.isAndroid) {
//       final status = await Permission.notification.request();
//       debugPrint('Notification permission status: $status');
//     }

//     // Set up background message handler
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     // Request permission for iOS
//     if (Platform.isIOS) {
//       await _firebaseMessaging.requestPermission(
//         alert: true,
//         announcement: false,
//         badge: true,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: false,
//         sound: true,
//       );
//       await _firebaseMessaging.setForegroundNotificationPresentationOptions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
      
//       // Get APNS token for iOS
//       String? apnsToken = await _firebaseMessaging.getAPNSToken();
//       debugPrint('APNS Token: $apnsToken');
//     }

//     // Initialize local notifications
//     const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
        
//     final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();
            
//     final InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     await _flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
//     );

//     // Create notification channel for Android
//     if (Platform.isAndroid) {
//       await _createNotificationChannel();
//     }

//     // Get FCM token
//     await _getToken();

//     // Set up message handlers
//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    
//     // Check if app was opened from a notification
//     await _checkInitialMessage();
//   }

//   // Create notification channel for Android
//   Future<void> _createNotificationChannel() async {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel',
//       'High Importance Notifications',
//       description: 'This channel is used for important notifications.',
//       importance: Importance.high,
//     );

//     await _flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }

//   // Get the FCM token
//   Future<void> _getToken() async {
//     _token = await _firebaseMessaging.getToken();
//     debugPrint('FCM Token: $_token');
    
//     // Set up token refresh listener
//     _firebaseMessaging.onTokenRefresh.listen((String token) {
//       _token = token;
//       debugPrint('FCM Token refreshed: $_token');
//       // Here you would typically send the new token to your server
//     });
//   }

//   static const String _topic = "LOGISTICS_USERS";
//   // Subscribe to a topic
//   Future<void> subscribeToTopic() async {
//     await _firebaseMessaging.subscribeToTopic(_topic);
//     debugPrint('Subscribed to topic: $_topic');
//   }

//   // Unsubscribe from a topic
//   Future<void> unsubscribeFromTopic() async {
//     await _firebaseMessaging.unsubscribeFromTopic(_topic);
//     debugPrint('Unsubscribed from topic: $_topic');
//   }

//   // Handle foreground messages
//   void _handleForegroundMessage(RemoteMessage message) {
//     debugPrint('Got a message whilst in the foreground!');
//     debugPrint('Message data: ${message.data}');

//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;

//     // Show local notification
//     if (notification != null) {
//       _flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             'high_importance_channel',
//             'High Importance Notifications',
//             channelDescription: 'This channel is used for important notifications.',
//             icon: android?.smallIcon ?? '@mipmap/ic_launcher',
//           ),
//           iOS: const DarwinNotificationDetails(),
//         ),
//         payload: jsonEncode(message.data),
//       );
//     }
//   }

//   // Handle when app is opened from a notification
//   Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
//     debugPrint('Message opened app: ${message.data}');
//     _navigateToRoute(message.data);
//   }

//   // Check if app was opened from a notification when it was terminated
//   Future<void> _checkInitialMessage() async {
//     RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    
//     if (initialMessage != null) {
//       debugPrint('App opened from terminated state: ${initialMessage.data}');
//       _navigateToRoute(initialMessage.data);
//     }
//   }

//   // Navigate to the appropriate route based on notification data
//   void _navigateToRoute(Map<String, dynamic> data) {
//     // Extract route information from notification data
//     String? route = data['route'];
    
//     if (route != null) {
//       switch (route) {
//         case 'order_details':
//           String? orderId = data['order_id'];
//           if (orderId != null) {
//             navigatorKey.currentState?.pushNamed('/order-details', arguments: orderId);
//           }
//           break;
//         case 'notifications':
//           navigatorKey.currentState?.pushNamed('/notifications');
//           break;
//         default:
//           navigatorKey.currentState?.pushNamed('/');
//       }
//     }
//   }

//   // iOS specific method to handle local notifications
//   void onDidReceiveLocalNotification(
//       int id, String? title, String? body, String? payload) {
//     debugPrint('Local notification received: $payload');
//   }

//   // Handle notification tap
//   void onDidReceiveNotificationResponse(NotificationResponse details) {
//     final String? payload = details.payload;
//     if (payload != null) {
//       debugPrint('Notification payload: $payload');
//       try {
//         final data = jsonDecode(payload) as Map<String, dynamic>;
//         _navigateToRoute(data);
//       } catch (e) {
//         debugPrint('Error parsing notification payload: $e');
//       }
//     }
//   }
// }