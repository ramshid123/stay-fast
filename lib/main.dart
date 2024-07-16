import 'dart:developer';

import 'package:fasting_app/core/services/background_service.dart';
import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/theme/theme.dart';
import 'package:fasting_app/core/utils/show_notification.dart';
import 'package:fasting_app/features/fasting/presentation/bloc/fasting_bloc.dart';
import 'package:fasting_app/features/fasting/presentation/pages/dashboard_page.dart';
import 'package:fasting_app/features/fasting/presentation/pages/home_page.dart';
import 'package:fasting_app/features/fasting/presentation/pages/journal_page.dart';
import 'package:fasting_app/features/onboarding/pages/onboarding_page.dart';
import 'package:fasting_app/features/payment_page/payment_failure_page.dart';
import 'package:fasting_app/features/payment_page/payment_page.dart';
import 'package:fasting_app/features/payment_page/payment_success_page.dart';
import 'package:fasting_app/features/reset_data_page/reset_data_page.dart';
import 'package:fasting_app/features/screenshot_page/screenshot_page.dart';
import 'package:fasting_app/features/fasting/presentation/pages/settings_page.dart';
import 'package:fasting_app/features/splash%20screen/pages/splash_screen.dart';
import 'package:fasting_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restart_app/restart_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: ColorConstantsDark.backgroundColor,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await initializeBackgroundNotificationService();
  await FlutterBackgroundService().startService();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<FastingBloc>(create: (_) => serviceLocator()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App is in the background
      log("App is in the background");
      FlutterBackgroundService().invoke('removeAllNotifications');
    } else if (state == AppLifecycleState.detached) {
      // App is terminated
      FlutterBackgroundService().invoke('removeAllNotifications');
      log('the app is terminated now');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(392.72727272727275, 803.6363636363636),
        builder: (context, child) {
          return MaterialApp(
            title: 'Stay Fast',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkMode,
            darkTheme: AppTheme.darkMode,
            home: const SplashScreen(),
          );
        });
  }
}

// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';
// import 'dart:ui';

// import 'package:fasting_app/core/services/background_service.dart';
// import 'package:fasting_app/core/utils/show_notification.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await initializeBackgroundNotificationService();
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String text = "Service";
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(),
//         body: Center(
//           child: Column(
//             children: [
//               ElevatedButton(
//                 child: Text(text),
//                 onPressed: () async {
//                   final service = FlutterBackgroundService();
//                   service.invoke('setAsBackground');
//                   var isRunning = await service.isRunning();
//                   isRunning
//                       ? service.invoke("stopService")
//                       : await invokeBackgroundNotificationService(
//                           duration: Duration(minutes: 10),
//                           startTime: DateTime.now());
//                   // : service.startService();

//                   setState(() {
//                     text = isRunning ? 'Start Service' : 'Stop Service';
//                   });
//                 },
//               ),
//               ElevatedButton(
//                 child: Text('check permission'),
//                 onPressed: () async {
//                   final isDenied = await Permission.notification.isDenied;
//                   log('isDenied : $isDenied');
//                   if (isDenied) {
//                     await Permission.notification.request();
//                   }
//                 },
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
