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
        : "It's time for $prayerName!";

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
            styleInformation: BigTextStyleInformation(''),
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

  Future<void> schedulePostPrayerReminders(
    int id,
    DateTime currentPrayerTime,
    DateTime nextPrayerTime,
    String prayerName,
  ) async {
    final totalDuration = nextPrayerTime.difference(currentPrayerTime);

    // We want 3 reminders within the prayer window, so we divide the time interval by 4.
    final intervalDuration = totalDuration ~/ 4;

    final random = Random();
    final List<String> messages = postPrayerReminderMessages[prayerName] ?? [];

    for (int i = 1; i <= 3; i++) {
      final reminderTime = currentPrayerTime.add(intervalDuration * i);

      // Pick a random reminder message for each notification
      final message = messages.isNotEmpty
          ? messages[random.nextInt(messages.length)]
          : "Have you prayed $prayerName? Don’t forget to complete your prayer!";

      try {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          id + i, // Using different IDs for each notification
          'Have you prayed $prayerName?',
          message,
          tz.TZDateTime.from(reminderTime, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'prayer_reminder_channel',
              'Prayer Reminders',
              channelDescription: 'Reminders to complete prayers',
              styleInformation: BigTextStyleInformation(''),
            ),
            linux: LinuxNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.wallClockTime,
        );
      } catch (e) {
        print(
            'Error scheduling post-prayer reminder for $prayerName at $reminderTime: $e');
      }
    }
  }

  Future<void> scheduleAllNotifications(List<DateTime> prayerTimes) async {
    const prayerNames = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    for (int i = 0; i < prayerTimes.length - 1; i++) {
      try {
        // Schedule prayer notification
        await schedulePrayerNotification(i, prayerTimes[i], prayerNames[i]);

        // Schedule 3 post-prayer reminders between consecutive prayers
        await schedulePostPrayerReminders(
          i * 100,
          prayerTimes[i],
          prayerTimes[i + 1],
          prayerNames[i],
        );
      } catch (e) {
        print('Error scheduling notifications for ${prayerNames[i]}: $e');
      }
    }
  }

  Future<void> cancelPostPrayerReminders(int id) async {
    for (int i = 1; i <= 3; i++) {
      try {
        await _flutterLocalNotificationsPlugin.cancel(id + i);
      } catch (e) {
        print('Error canceling reminder notification with id ${id + i}: $e');
      }
    }
  }
}
