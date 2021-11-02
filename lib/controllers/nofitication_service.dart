import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  //Singleton pattern
  // static final NotificationService _notificationService =
  //     NotificationService._internal();
  // factory NotificationService() {
  //   return _notificationService;
  // }
  // NotificationService._internal();
  //instance of FlutterLocalNotificationsPlugin

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  var androidNotificationDetails = AndroidNotificationDetails(
    'channel ID',
    'channel name',
    priority: Priority.high,
    importance: Importance.high,
  );
  var iosNotificationDetails = IOSNotificationDetails();

  Future<void> init() async {
    //Initialization Settings for Android
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    //Initialization Settings for iOS
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    //InitializationSettings for initializing settings for both platforms (Android & iOS)
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    // tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  requestIOSPermissions() {
    (FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    };
  }

  Future<void> everyAtTimeNotification() async {
    var platformChannelSpecifics = NotificationDetails(
        iOS: iosNotificationDetails, android: androidNotificationDetails);
    //var time = Time(09, 0, 0);

    await flutterLocalNotificationsPlugin.periodicallyShow(
      1,
      '공명',
      '오늘의 공명을 확인하세요!',
      RepeatInterval.everyMinute,
      platformChannelSpecifics,
      payload: 'Hello Flutter',
    );
  }

  Future<void> ScheduleTimeNotification() async {
    Time alarmTime = Time(9, 00, 00);
    var platformChannelSpecifics = NotificationDetails(
        iOS: iosNotificationDetails, android: androidNotificationDetails);
    //var time = Time(09, 0, 0);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      '공명',
      '오늘의 공명을 확인하세요!',
      //tz.TZDateTime.now(tz.local).add(Duration(minutes: 3)),
      scheduledDaily(alarmTime),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: 'Hello Flutter',
    );
  }
}

tz.TZDateTime scheduledDaily(Time alarmTime) {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local, now.year, now.month, now.day, alarmTime.hour, alarmTime.minute);
  //scheduledDate = scheduledDate.add(const Duration(days: 1));
  return scheduledDate;
}
