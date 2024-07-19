
import 'package:fasting_app/core/animations/opacity_translate_y.dart';
import 'package:fasting_app/core/shared_preferences_strings/shared_pref_strings.dart';
import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/utils/show_notification.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:fasting_app/features/fasting/presentation/pages/home_page.dart';
import 'package:fasting_app/features/onboarding/pages/onboarding_page.dart';
import 'package:fasting_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController1;
  late AnimationController _animationController2;
  late List<Animation> _animations;

  @override
  void dispose() {
    
    _animationController1.dispose();
    _animationController2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController1 =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animationController2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _animations = [];

    _animations.add(Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController1,
        curve: const Interval(0.0, 0.4, curve: Curves.easeInOut))));

    _animations.add(Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController1,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut))));

    _animations.add(Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController2, curve: Curves.easeInOut)));

    Future.delayed(const Duration(milliseconds: 400), () async {
      _animationController1.forward();
      await initialize();
    });

    
    super.initState();
  }

  Future initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    await initDependencies();
    await invokeBackgroundNotificationService();
    await Future.delayed(const Duration(seconds: 2));

    final sfInstance = serviceLocator<SharedPreferences>();
    bool isFirstTime =
        sfInstance.getBool(SharedPrefStrings.isFirstTime) ?? true;

    _animationController2.forward();
    await Future.delayed(const Duration(milliseconds: 700));

    if (mounted) {
      if (isFirstTime) {
        await Navigator.of(context)
            .pushAndRemoveUntil(OnBoardingPage.route(), (c) => false);
      } else {
        await Navigator.of(context)
            .pushAndRemoveUntil(HomePage.route(), (v) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
          animation: _animations[2],
          builder: (context, _) {
            return Transform.translate(
              offset: Offset(0, -_animations[2].value * 100.h),
              child: Opacity(
                opacity: (1 - _animations[2].value).toDouble(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    kWidth(double.infinity),
                    animatedOpacityTranslation(
                      isTranslated: false,
                      animation: _animations[0],
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: ColorConstantsDark.container2Color,
                          borderRadius: BorderRadius.circular(150.r),
                        ),
                        height: 150.h,
                        width: 150.h,
                        child: AnimatedBuilder(
                            animation: _animations[1],
                            builder: (context, _) {
                              return Transform.translate(
                                offset: Offset(
                                    0.0, (1 - _animations[1].value) * 150.h),
                                child: RiveAnimation.asset(
                                  'assets/rive/cheers.riv',
                                  fit: BoxFit.contain,
                                  onInit: (Artboard artboard) {
                                    final controller =
                                        StateMachineController.fromArtboard(
                                            artboard, 'Drinks_MainScene');
                                    artboard.addController(controller!);
                                  },
                                ),
                              );
                            }),
                      ),
                    ),
                    kHeight(20.h),
                    animatedOpacityTranslation(
                      animation: _animations[1],
                      child: RichText(
                        text: TextSpan(
                          text: 'STAY',
                          style: TextStyle(
                            fontSize: 28.sp,
                            color:
                                ColorConstantsDark.textColor.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                          ),
                          children: const [
                            TextSpan(
                              text: ' FAST',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
