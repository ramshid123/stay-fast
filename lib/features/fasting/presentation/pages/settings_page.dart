
import 'dart:developer';

import 'package:fasting_app/core/shared_preferences_strings/shared_pref_strings.dart';
import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/utils/vibrate.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:fasting_app/features/fasting/presentation/bloc/fasting_bloc.dart';
import 'package:fasting_app/features/fasting/presentation/widgets/settings_page_widgets.dart';
import 'package:fasting_app/features/payment_page/payment_page.dart';
import 'package:fasting_app/features/reset_data_page/reset_data_page.dart';
import 'package:fasting_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  static route() =>
      MaterialPageRoute(builder: (context) => const SettingsPage());

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final deviceInfo = serviceLocator<PackageInfo>();

  final sf = serviceLocator<SharedPreferences>();
  ValueNotifier<bool> isNotificationAllowed = ValueNotifier(true);
  ValueNotifier<bool> isSoundAllowed = ValueNotifier(true);
  ValueNotifier<bool> isVibrationAllowed = ValueNotifier(true);

  ValueNotifier<bool> nullNotifierValue = ValueNotifier(true);

  Future toggleValue({
    required bool value,
    required String sfString,
    required ValueNotifier<bool> switchValue,
  }) async {
    await sf.setBool(sfString, value);
    switchValue.value = value;
  }

  Future resetData(BuildContext context) async {
    await showAdaptiveDialog(
      context: context,
      builder: (context) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            decoration: BoxDecoration(
              color: ColorConstantsDark.container2Color,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  kText(
                    'Erase Data ?',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  kHeight(20.h),
                  Image.asset(
                    'assets/images/bin.png',
                    height: 100.h,
                    width: 100.w,
                    fit: BoxFit.contain,
                  ),
                  kHeight(30.h),
                  InkWell(
                    onTap: () {
                      vibrate();
                      Navigator.of(context).pop();
                    },
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      width: 200.w,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        
                        color: Colors.transparent,
                        border: Border.all(
                          width: 2.r,
                          color: ColorConstantsDark.buttonBackgroundColor,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: kText(
                          'No, Go back.',
                          color: ColorConstantsDark.buttonBackgroundColor,
                        ),
                      ),
                    ),
                  ),
                  kHeight(10.h),
                  InkWell(
                    onTap: () {
                      vibrate();
                      context.read<FastingBloc>().add(FastingEventResetData());
                    },
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      width: 200.w,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.red,
                          width: 2.r,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: kText(
                          'Yes, Go ahead.',
                          color: Colors.red,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future showAboutBottomSheet() async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SettingsPageWidgets.aboutSheet();
        });
  }

  Future showFeedbackBottomSheet() async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SettingsPageWidgets.feedbackBottomSheet(context: context);
        });
  }

  @override
  void initState() {
    isNotificationAllowed.value =
        sf.getBool(SharedPrefStrings.isNotificationAllowed) ?? true;

    isSoundAllowed.value = sf.getBool(SharedPrefStrings.isSoundAllowed) ?? true;

    isVibrationAllowed.value =
        sf.getBool(SharedPrefStrings.isVibrationAllowed) ?? true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FastingBloc, FastingState>(
      listener: (context, state) async {
        if (state is FastingStateRestartApp) {
          await Navigator.push(context, ResetDataPage.route());
        } else if (state is FastingStateFailure) {
          log('error => ${state.message}');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: kText(
            'Settings',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: false,
          leading: InkWell(
            onTap: () {
              vibrate();
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        body: Column(
          children: [
            settingsPageButtons(
              title: 'Notification',
              icon: Icons.notifications,
              buttonType: _ButtonType.switchType,
              switchValue: isNotificationAllowed,
              onTap: () => toggleValue(
                sfString: SharedPrefStrings.isNotificationAllowed,
                switchValue: isNotificationAllowed,
                value: !isNotificationAllowed.value,
              ),
            ),
            settingsPageButtons(
              title: 'Sound',
              icon: Icons.volume_up_sharp,
              buttonType: _ButtonType.switchType,
              switchValue: isSoundAllowed,
              onTap: () => toggleValue(
                sfString: SharedPrefStrings.isSoundAllowed,
                switchValue: isSoundAllowed,
                value: !isSoundAllowed.value,
              ),
            ),
            settingsPageButtons(
              title: 'Vibration',
              icon: Icons.vibration,
              buttonType: _ButtonType.switchType,
              switchValue: isVibrationAllowed,
              onTap: () => toggleValue(
                sfString: SharedPrefStrings.isVibrationAllowed,
                switchValue: isVibrationAllowed,
                value: !isVibrationAllowed.value,
              ),
            ),
            settingsPageButtons(
              title: 'Data',
              icon: Icons.data_saver_off_sharp,
              buttonType: _ButtonType.arrowType,
              onTap: () async {
                vibrate();
                await resetData(context);
              },
            ),
            kHeight(20.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25.w),
              height: 3.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorConstantsDark.container2Color,
                borderRadius: BorderRadius.circular(100.r),
              ),
            ),
            kHeight(20.h),
            settingsPageButtons(
              title: 'Feedback',
              icon: Icons.feedback_rounded,
              buttonType: _ButtonType.normalType,
              onTap: () async => await showFeedbackBottomSheet(),
            ),
            settingsPageButtons(
              title: 'About',
              icon: Icons.info,
              buttonType: _ButtonType.normalType,
              onTap: () async => await showAboutBottomSheet(),
            ),
            settingsPageButtons(
              title: 'Contribute',
              icon: Icons.currency_rupee,
              buttonType: _ButtonType.normalType,
              onTap: () async {
                vibrate();
                await Navigator.push(context, PaymentPage.route());
              },
            ),
            const Spacer(),
            Opacity(
              opacity: 0.4,
              child: kText(
                'Version ${deviceInfo.version}',
                fontSize: 11,
              ),
            ),
            kHeight(2.h),
            Opacity(
              opacity: 0.4,
              child: kText(
                'Privacy Policy  |  Terms of Use',
                fontSize: 11,
              ),
            ),
            kHeight(30.h),
          ],
        ),
      ),
    );
  }

  Widget settingsPageButtons({
    required String title,
    required IconData icon,
    Color? iconColor,
    required _ButtonType buttonType,
    void Function()? onTap,
    ValueNotifier<bool>? switchValue,
  }) {
    if (buttonType == _ButtonType.switchType && switchValue == null) {
      throw ('switchValue must be given if isSwitch is true');
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
      child: ValueListenableBuilder(
          valueListenable: buttonType == _ButtonType.switchType
              ? switchValue!
              : nullNotifierValue,
          builder: (context, value, _) {
            return InkWell(
              borderRadius: BorderRadius.circular(10.r),
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: const BoxDecoration(
                        color: ColorConstantsDark.container2Color,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: 25.r,
                        color: iconColor,
                      ),
                    ),
                    kWidth(25.w),
                    kText(
                      title,
                      fontSize: 16,
                    ),
                    const Spacer(),
                    buttonType == _ButtonType.switchType
                        ? Switch(
                            value: switchValue!.value,
                            onChanged: (value) => onTap!(),
                            activeColor:
                                ColorConstantsDark.buttonBackgroundColor,
                            inactiveThumbColor:
                                ColorConstantsDark.buttonBackgroundColor,
                            trackOutlineColor: WidgetStateProperty.all(
                                ColorConstantsDark.buttonBackgroundColor),
                          )
                        : (buttonType == _ButtonType.arrowType
                            ? Icon(
                                Icons.navigate_next,
                                size: 30.r,
                              )
                            : Container()),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

enum _ButtonType {
  switchType,
  arrowType,
  normalType,
}


