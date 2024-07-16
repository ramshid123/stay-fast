import 'dart:async';

import 'package:fasting_app/core/entities/time_ration_entity.dart';
import 'package:fasting_app/core/funvas/rotating_dots.dart';
import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:funvas/funvas.dart';

class Achievement extends StatefulWidget {
  final Duration duration;
  final DateTime startTime;
  final FastingTimeRatioEntity fastingTimeRatio;
  const Achievement(
      {super.key,
      required this.duration,
      required this.startTime,
      required this.fastingTimeRatio});

  @override
  State<Achievement> createState() => _AchievementState();
}

class _AchievementState extends State<Achievement> {
  late Timer timer;

  ValueNotifier<Duration> timeValueNotifier =
      ValueNotifier(const Duration(seconds: 0));

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 300.h,
          width: double.infinity,
          child: FunvasContainer(
            funvas: RotatingSquaresFunvas(),
          ),
        ),
        _AchievementTimer(
            duration: widget.duration,
            startTime: widget.startTime,
            fastingTimeRatio: widget.fastingTimeRatio)
      ],
    );
  }
}

class _AchievementTimer extends StatefulWidget {
  final Duration duration;
  final DateTime startTime;
  final FastingTimeRatioEntity fastingTimeRatio;
  const _AchievementTimer(
      {super.key,
      required this.duration,
      required this.startTime,
      required this.fastingTimeRatio});

  @override
  State<_AchievementTimer> createState() => __AchievementTimerState();
}

class __AchievementTimerState extends State<_AchievementTimer> {
  late Timer timer;

  ValueNotifier<Duration> timeValueNotifier =
      ValueNotifier(const Duration(seconds: 0));

  @override
  void initState() {
    timeValueNotifier.value = Duration(
        milliseconds:
            widget.startTime.difference(DateTime.now()).inMilliseconds.abs() -
                widget.duration.inMilliseconds);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeValueNotifier.value =
          Duration(seconds: timeValueNotifier.value.inSeconds + 1);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: timeValueNotifier,
        builder: (context, value, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              kText(
                'Fasting for',
              ),
              kText(
                '${widget.startTime.difference(DateTime.now()).inHours.abs()}h ${widget.startTime.difference(DateTime.now()).inMinutes.remainder(60).abs()}m',
                fontSize: 40,
                fontWeight: FontWeight.w500,
              ),
              kText(
                '${widget.startTime.difference(DateTime.now()).inSeconds.remainder(60).abs()}s',
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              kHeight(10.h),
              Container(
                height: 1.h,
                width: 150.w,
                color: ColorConstantsDark.container2Color,
              ),
              kHeight(10.h),
              kText(
                'Bravo!!',
                fontSize: 18,
                color: ColorConstantsDark.buttonBackgroundColor,
              ),
              kHeight(5.h),
              kText(
                'Finished',
                fontSize: 15,
                color: ColorConstantsDark.buttonBackgroundColor,
              )
              // kText(
              //     timeValueNotifier.value.inHours > 0
              //         ? 'Completed'
              //         : '${timeValueNotifier.value.inHours.abs()}h ${timeValueNotifier.value.inMinutes.remainder(60).abs()}m ${timeValueNotifier.value.inSeconds.remainder(60).abs()}s',
              //     fontSize: 13,
              //     color: ColorConstantsDark.buttonBackgroundColor
              //         .withOpacity(0.5)),
            ],
          );
        });
  }
}
