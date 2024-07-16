import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:fasting_app/core/utils/show_notification.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> initializeBackgroundNotificationService() async {
  final service = FlutterBackgroundService();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: false,
    ),
    iosConfiguration: IosConfiguration(),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsBackground').listen((event) async {
      await service.setAsBackgroundService();
    });

    service.on('removeAllNotifications').listen((event) async {
      log('invoked service');
      await service.setAsBackgroundService();
      log('set as backgroundservice');
      await FlutterLocalNotificationsPlugin().cancelAll();
      log('cancel notifications');
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(
      const Duration(seconds: 3), (timer) => log('BACKGROUND SERVICE RUNNING'));

  await showProgressBarNotification();
}
