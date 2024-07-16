import 'dart:developer';

import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:fasting_app/features/onboarding/pages/page_1.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  static route() =>
      MaterialPageRoute(builder: (context) => const OnBoardingPage());

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final pageController = PageController();
  // int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     pageIndex++;
      //     await pageController.animateToPage(pageIndex,
      //         duration: const Duration(milliseconds: 400),
      //         curve: Curves.easeInOut);
      //   },
      // ),
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          OnBoardingSubPage(
              title: 'Achieve your health goals with ease',
              pageController: pageController,
              index: 0,
              riveAnimationPath: 'assets/rive/heart_beat.riv',
              exitDuration: const Duration(seconds: 1),
              isFinal: false),
          OnBoardingSubPage(
              title: 'Record your progress and stay motivated',
              pageController: pageController,
              index: 1,
              riveAnimationPath: 'assets/rive/graph_check.riv',
              exitDuration: const Duration(seconds: 2),
              isFinal: false),
          OnBoardingSubPage(
              title: 'Track your fasting periods effortlessly',
              pageController: pageController,
              index: 2,
              riveAnimationPath: 'assets/rive/clock.riv',
              exitDuration: const Duration(milliseconds: 2100),
              isFinal: true),
        ],
      ),
    );
  }
}
