import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salah_x/notifs/tokens.dart';
import 'package:timezone/timezone.dart' as tz;

final notificationServiceProvider =
    AsyncNotifierProvider<NotificationService, void>(
  () => NotificationService(),
);

class NotificationService extends AsyncNotifier<void> {
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  @override
  Future<void> build() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Android initialization
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Linux initialization
    const LinuxInitializationSettings linuxInitializationSettings =
        LinuxInitializationSettings(defaultActionName: 'default');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      linux: linuxInitializationSettings,
    );

    try {
      await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  Future<void> schedulePrayerNotification(
    int id,
    DateTime prayerTime,
    String prayerName,
  ) async {
    final random = Random();

    // Pick a random message from the prayer's list of messages
    final List<String> messages = motivatingMessages[prayerName] ?? [];
    final message = messages.isNotEmpty
        ? messages[random.nextInt(messages.length)]
        : "It’s time for $prayerName!";

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'It\'s time for $prayerName!',
        message,
        tz.TZDateTime.from(prayerTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'prayer_channel',
            'Prayer Notifications',
            channelDescription: 'Channel for prayer notifications',
          ),
          linux: LinuxNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
      );
    } catch (e) {
      print('Error scheduling prayer notification for $prayerName: $e');
    }
  }

  Future<void> schedulePostPrayerReminder(
    int id,
    DateTime prayerTime,
    String prayerName,
  ) async {
    final reminderTime = prayerTime.add(const Duration(minutes: 30));

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'Have you prayed $prayerName?',
        'Don\'t forget to complete your $prayerName prayer!',
        tz.TZDateTime.from(reminderTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'prayer_reminder_channel',
            'Prayer Reminders',
            channelDescription: 'Reminders to complete prayers',
          ),
          linux: LinuxNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
      );
    } catch (e) {
      print('Error scheduling post-prayer reminder for $prayerName: $e');
    }
  }

  Future<void> scheduleAllNotifications(List<DateTime> prayerTimes) async {
    const prayerNames = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    for (int i = 0; i < prayerTimes.length; i++) {
      try {
        await schedulePrayerNotification(i, prayerTimes[i], prayerNames[i]);
        await schedulePostPrayerReminder(
            i + 100, prayerTimes[i], prayerNames[i]);
      } catch (e) {
        print('Error scheduling notifications for $prayerNames[i]: $e');
      }
    }
  }
}
