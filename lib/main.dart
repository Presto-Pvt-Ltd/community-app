import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:presto/app/app.router.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:stacked_services/stacked_services.dart';
import 'app/app.locator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  FlutterRingtonePlayer.playNotification();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'presto_borrowing_channel', // id
  'Presto Requests', // title
  'This channel is used for notifications', // description
  importance: Importance.high,
  enableLights: true,
  enableVibration: true,
  playSound: true,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  _initHive();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  print("channel created");
  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIos = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIos,
  );
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
}

Future _initHive() async {
  await getApplicationDocumentsDirectory().then((dir) {
    Hive.init(dir.path);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((event) {
      FlutterRingtonePlayer.playNotification();
      print("Hello");
      flutterLocalNotificationsPlugin.show(
        12,
        event.notification?.title,
        event.notification?.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            "presto_borrowing_channel_test_1",
            "Presto Custom Notification Test 2",
            "Desiogniealnvelkvs",
            importance: Importance.high,
            priority: Priority.high,
            enableLights: true,
            playSound: true,
            enableVibration: true,
          ),
        ),
      );
    });

    return MaterialApp(
      title: 'Presto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primarySwatch,
        primaryColor: primaryColor,
      ),
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
    );
  }
}
