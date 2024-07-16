import 'dart:developer';

import 'package:fasting_app/core/shared_preferences_strings/shared_pref_strings.dart';
import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/utils/vibrate.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:fasting_app/features/fasting/presentation/pages/home_page.dart';
import 'package:fasting_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingSubPage extends StatefulWidget {
  final int index;
  final String riveAnimationPath;
  final bool isFinal;
  final PageController pageController;
  final Duration exitDuration;
  final String title;
  const OnBoardingSubPage(
      {super.key,
      required this.title,
      required this.pageController,
      required this.index,
      required this.riveAnimationPath,
      required this.exitDuration,
      required this.isFinal});

  static route({
    required PageController pageController,
    required int index,
    required bool isFinal,
    required String title,
    required String riveAnimationPath,
    required Duration exitDuration,
  }) =>
      MaterialPageRoute(
          builder: (context) => OnBoardingSubPage(
                title: title,
                pageController: pageController,
                exitDuration: exitDuration,
                index: index,
                isFinal: isFinal,
                riveAnimationPath: riveAnimationPath,
              ));

  @override
  State<OnBoardingSubPage> createState() => _OnBoardingSubPageState();
}

class _OnBoardingSubPageState extends State<OnBoardingSubPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;

  late StateMachineController riveAnimController;
  late SMITrigger riveAnimExitTrigger;
  late SMITrigger riveAnimEnterTrigger;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this,
        duration:
            Duration(milliseconds: widget.exitDuration.inMilliseconds ~/ 2));
    animation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut));

    Future.delayed(const Duration(seconds: 1), () {
      riveAnimEnterTrigger.fire();
      animationController.forward();
    });
    super.initState();
  }

  Future navigateToHomePage() async {
    final sfInstance = serviceLocator<SharedPreferences>();
    await sfInstance.setBool(SharedPrefStrings.isFirstTime, false);
    await Navigator.of(context)
        .pushAndRemoveUntil(HomePage.route(), (c) => false);
  }

  Future exit(BuildContext context) async {
    riveAnimExitTrigger.fire();
    animationController.reverse();
    await Future.delayed(widget.exitDuration);

    widget.isFinal
        ? await navigateToHomePage()
        : await widget.pageController.animateToPage(widget.index + 1,
            duration: const Duration(milliseconds: 1), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    riveAnimController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
              animation: animation,
              builder: (context, _) {
                return Column(
                  children: [
                    kHeight(70.h),
                    Opacity(
                      opacity: (1 - animation.value).toDouble(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < 3; i++)
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                              height: 10.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                // color: Colors.white,
                                color: widget.index >= i
                                    ? Colors.white
                                    : Colors.white30,
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                            ),
                        ],
                      ),
                    ),
                    kHeight(70.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Transform.translate(
                        offset: Offset(0, -50.h * animation.value),
                        child: Opacity(
                          opacity: (1 - animation.value).toDouble(),
                          child: kText(
                            widget.title,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        vibrate();
                        await exit(context);
                      },
                      child: Transform.translate(
                        offset: Offset(0, 50.h * animation.value),
                        child: Opacity(
                          opacity: (1 - animation.value).toDouble(),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.w),
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              color: ColorConstantsDark.buttonBackgroundColor,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Center(
                              child: kText(
                                widget.isFinal ? 'Continue' : 'Next',
                                color: ColorConstantsDark.backgroundColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    kHeight(100.h),
                  ],
                );
              }),
          IgnorePointer(
            child: Transform.translate(
              offset: Offset(0.0, 30.h),
              child: RiveAnimation.asset(
                widget.riveAnimationPath,
                onInit: (artboard) {
                  riveAnimController = StateMachineController.fromArtboard(
                      artboard, 'State Machine 1')!;
                  artboard.addController(riveAnimController);

                  riveAnimExitTrigger = riveAnimController.findSMI('exit');
                  riveAnimEnterTrigger = riveAnimController.findSMI('enter');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
