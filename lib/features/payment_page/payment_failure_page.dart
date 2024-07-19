import 'dart:math' as math;

import 'package:fasting_app/core/utils/vibrate.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentFailurePage extends StatefulWidget {
  const PaymentFailurePage({super.key});

  static route() =>
      MaterialPageRoute(builder: (context) => const PaymentFailurePage());

  @override
  State<PaymentFailurePage> createState() => _PaymentFailurePageState();
}

class _PaymentFailurePageState extends State<PaymentFailurePage>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController onGoingAnimationController;
  List<Animation> animations = [];
  late Animation onGoingAnimation;

  @override
  void initState() {
    
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    onGoingAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    animations.add(Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut))));

    animations.add(Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeInOut))));

    animations.add(Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.6, 1.0, curve: Curves.elasticOut))));

    onGoingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: onGoingAnimationController, curve: Curves.easeInOut));

    startAnimation();
    super.initState();
  }

  void startAnimation() async {
    animationController.value = 0;
    await animationController.forward();
    await onGoingAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    
    animationController.dispose();
    onGoingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.red,
      body: Stack(
        children: [
          Transform.translate(
            offset: Offset(0.0, 20.h),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: glitteringWidgets(
                  height: 150.r, color: Colors.white10, isReverse: false),
            ),
          ),
          Transform.translate(
            offset: Offset(50.0, 250.h),
            child: Align(
              alignment: Alignment.topRight,
              child: glitteringWidgets(
                  height: 100.r, color: Colors.white10, isReverse: true),
            ),
          ),
          Transform.translate(
            offset: Offset(0, 50.h),
            child: Align(
              alignment: Alignment.topLeft,
              child: glitteringWidgets(
                  height: 50.r, color: Colors.white10, isReverse: false),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                kWidth(double.infinity),
                AnimatedBuilder(
                    animation: animations[2],
                    builder: (context, _) {
                      return Transform.translate(
                        offset: Offset(
                            (1 - animations[2].value) *
                                -((size.width / 2) + 70.r),
                            0.0),
                        child: Transform.rotate(
                          angle: math.pi * (1 - animations[2].value) * -3,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 70.r,
                            child: Icon(
                              Icons.clear_rounded,
                              color: Colors.red,
                              size: 100.r,
                            ),
                          ),
                        ),
                      );
                    }),
                kHeight(40.h),
                AnimatedBuilder(
                    animation: animations[0],
                    builder: (context, _) {
                      return Transform.translate(
                        offset: Offset(0.0, 30.h * (1 - animations[0].value)),
                        child: Opacity(
                          opacity: animations[0].value,
                          child: kText(
                            'Payment Failed',
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }),
                kHeight(10.h),
                AnimatedBuilder(
                    animation: animations[0],
                    builder: (context, _) {
                      return Transform.translate(
                        offset: Offset(0.0, 30.h * (1 - animations[0].value)),
                        child: Opacity(
                          opacity: animations[0].value,
                          child: kText(
                            'Something went wrong while performing the payment. Please try again. Your support keeps me forward.',
                            maxLines: 10,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }),
                kHeight(100.h),
                AnimatedBuilder(
                    animation: animations[1],
                    builder: (context, _) {
                      return Transform.translate(
                        offset: Offset(0.0, 30.h * (1 - animations[1].value)),
                        child: Opacity(
                          opacity: animations[1].value,
                          child: GestureDetector(
                            onTap: () {
                              vibrate();
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Center(
                                child: kText(
                                  "Let me try again!",
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget glitteringWidgets({
    required double height,
    required Color color,
    required bool isReverse,
  }) {
    return AnimatedBuilder(
        animation: animations[2],
        builder: (context, _) {
          return Transform.scale(
            scale: animations[2].value,
            child: AnimatedBuilder(
                animation: onGoingAnimation,
                builder: (context, _) {
                  return Transform.scale(
                    
                    
                    
                    
                    scale: (isReverse
                            ? ((1 - onGoingAnimation.value) / 4)
                            : onGoingAnimation.value / 4) +
                        1,
                    child: Container(
                      height: height,
                      width: height,
                      decoration: const BoxDecoration(
                        color: Colors.white30,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }),
          );
        });
  }
}
