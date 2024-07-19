import 'package:fasting_app/core/shared_preferences_strings/shared_pref_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> invokeBackgroundNotificationService({
  Duration? duration,
  DateTime? startTime,
}) async {
  final sf = await SharedPreferences.getInstance();
  await sf.reload();

  final isNotificationAllowed =
      sf.getBool(SharedPrefStrings.isNotificationAllowed) ?? true;
  if (!isNotificationAllowed) {
    return;
  }

  final isNotificationOnGoing =
      sf.getBool(SharedPrefStrings.isNotificationOnGoing) ?? false;

  if (!isNotificationOnGoing && duration != null && startTime != null) {
    await sf.setInt(
        SharedPrefStrings.durationInMilliseconds, duration.inMilliseconds);

    await sf.setString(SharedPrefStrings.startTime, startTime.toString());

    await sf.setBool(SharedPrefStrings.isNotificationOnGoing, true);
  }

  await Future.delayed(const Duration(seconds: 1));

  final isDenied = await Permission.notification.isDenied;
  if (isDenied) {
    final status = await Permission.notification.request();
    if (status.isDenied) {
      return;
    }
  }

  final service = FlutterBackgroundService();
  service.invoke('setAsBackground');
  await service.startService();
}

Future<void> showProgressBarNotification() async {
  final sf = await SharedPreferences.getInstance();
  await sf.reload();

  var durationInMilliseconds =
      sf.getInt(SharedPrefStrings.durationInMilliseconds) ?? 0;
  var startTimeString = sf.getString(SharedPrefStrings.startTime) ?? '';

  if (durationInMilliseconds == 0 || startTimeString.isEmpty) {
    return;
  }

  final duration = Duration(milliseconds: durationInMilliseconds);
  final startTime = DateTime.parse(startTimeString);

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  ValueNotifier<double> guageValueNotifier = ValueNotifier(0.0);
  ValueNotifier<Duration> timeValueNotifier =
      ValueNotifier(const Duration(seconds: 0));

  final rateOfChange = 1 / (duration.inSeconds);

  final elapsedSeconds = startTime.difference(DateTime.now()).inSeconds.abs();
  guageValueNotifier.value = (elapsedSeconds * rateOfChange <= 1.0)
      ? elapsedSeconds * rateOfChange
      : 1.0;
  timeValueNotifier.value = Duration(
      milliseconds: startTime.difference(DateTime.now()).inMilliseconds.abs() -
          duration.inMilliseconds);

  while (guageValueNotifier.value <= 1.0) {
    await Future.delayed(const Duration(milliseconds: 1000), () async {
      if (guageValueNotifier.value <= 1.0) {
        guageValueNotifier.value += rateOfChange;
      }

      timeValueNotifier.value =
          Duration(seconds: timeValueNotifier.value.inSeconds + 1);
      await flutterLocalNotificationsPlugin.show(
        0,
        'Stay fasting, Keep going 🔥🔥',
        '🕒 ${timeValueNotifier.value.inHours.abs()} hours ${timeValueNotifier.value.inMinutes.remainder(60).abs()} minutes ${timeValueNotifier.value.inSeconds.remainder(60).abs()} seconds remaining',
        NotificationDetails(
          android: AndroidNotificationDetails(
            'progress channel',
            'progress channel name',
            channelDescription: 'progress channel description',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            playSound: false,
            onlyAlertOnce: true,
            showProgress: true,
            maxProgress: 100,
            progress: (guageValueNotifier.value * 100).floor(),
          ),
        ),
      );
    });
  }
  await flutterLocalNotificationsPlugin.show(
    0,
    'Bravo🎉',
    '🎊 You have finished your fasting period.',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'progress channel',
        'progress channel name',
        channelDescription: 'progress channel description',
        importance: Importance.high,
        priority: Priority.high,
        onlyAlertOnce: true,
      ),
    ),
  );

  await sf.setInt(SharedPrefStrings.durationInMilliseconds, 0);
  await sf.setString(SharedPrefStrings.startTime, '');
  FlutterBackgroundService().invoke("stopService");
}
