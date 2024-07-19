import 'package:fasting_app/core/shared_preferences_strings/shared_pref_strings.dart';
import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:fasting_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetDataPage extends StatefulWidget {
  const ResetDataPage({super.key});

  static route() =>
      MaterialPageRoute(builder: (context) => const ResetDataPage());

  @override
  State<ResetDataPage> createState() => _ResetDataPageState();
}

class _ResetDataPageState extends State<ResetDataPage> {
  @override
  void initState() {
    
    Future.delayed(const Duration(seconds: 3), () async {
      final sf = serviceLocator<SharedPreferences>();
      await sf.clear();
      FlutterBackgroundService().invoke('stopService');
      await sf.setBool(SharedPrefStrings.isFirstTime, false);
      await Restart.restartApp();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstantsDark.backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          kText('Restarting. Please wait.'),
          SizedBox(
            height: 30.h,
            width: double.infinity,
          ),
          Container(
            padding: EdgeInsets.all(15.r),
            height: 60.r,
            width: 60.r,
            decoration: BoxDecoration(
              color: ColorConstantsDark.container2Color,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: const CircularProgressIndicator(
              color: ColorConstantsDark.buttonBackgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}
