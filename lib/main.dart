import 'dart:developer';

import 'package:fasting_app/core/services/background_service.dart';
import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/theme/theme.dart';
import 'package:fasting_app/features/fasting/presentation/bloc/fasting_bloc.dart';
import 'package:fasting_app/features/splash%20screen/pages/splash_screen.dart';
import 'package:fasting_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      log("App is in the background");
      FlutterBackgroundService().invoke('removeAllNotifications');
    } else if (state == AppLifecycleState.detached) {
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

