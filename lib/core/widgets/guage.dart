import 'dart:async';

import 'package:fasting_app/core/entities/time_ration_entity.dart';
import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_screenutil/flutter_screenutil.dart';

class KustomGuage extends StatefulWidget {
  final double strokeWidth;
  final double height;
  final double width;
  final Color? backgroundColor;
  final Color? guageIndicatorColor;
  final Color foregroundColor;
  final Duration duration;
  final DateTime startTime;
  final FastingTimeRatioEntity fastingTimeRatio;

  const KustomGuage({
    super.key,
    this.strokeWidth = 20,
    this.height = 300.0,
    required this.startTime,
    this.width = 300.0,
    this.duration = const Duration(seconds: 2),
    this.backgroundColor,
    this.foregroundColor = Colors.blue,
    this.guageIndicatorColor,
    required this.fastingTimeRatio,
  });

  @override
  KustomGuageState createState() => KustomGuageState();
}

class KustomGuageState extends State<KustomGuage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _onGoingAnimationController;

  late Animation<double> _animation;
  final List<Animation> _onGoingAnimation = [];
  bool _isOnGoingAnimationControllerDisposed = false;

  late Color? _backgroundColor;
  late Color? _guageIndicatorColor;

  late Timer timer;
  ValueNotifier<double> guageValueNotifier = ValueNotifier(0.0);
  ValueNotifier<Duration> timeValueNotifier =
      ValueNotifier(const Duration(seconds: 0));

  @override
  void initState() {
    _backgroundColor = widget.backgroundColor;
    _guageIndicatorColor = widget.guageIndicatorColor;
    final rateOfChange = 1 / (widget.duration.inSeconds);

    final elapsedSeconds =
        widget.startTime.difference(DateTime.now()).inSeconds.abs();
    guageValueNotifier.value = (elapsedSeconds * rateOfChange <= 1.0)
        ? elapsedSeconds * rateOfChange
        : 1.0;
    timeValueNotifier.value = Duration(
        milliseconds:
            widget.startTime.difference(DateTime.now()).inMilliseconds.abs() -
                widget.duration.inMilliseconds);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (guageValueNotifier.value <= 1.0) {
        guageValueNotifier.value += rateOfChange;
      }

      timeValueNotifier.value =
          Duration(seconds: timeValueNotifier.value.inSeconds + 1);
      // if (guageValueNotifier.value >= 1.0) {
      // timer.cancel();
      // }
    });

    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    if (guageValueNotifier.value == 0) {
      guageValueNotifier.value = 0.001;
    }
    _backgroundColor ??= widget.foregroundColor.withOpacity(0.3);
    _guageIndicatorColor ??= widget.foregroundColor.withOpacity(0.3);

    guageValueNotifier.addListener(_valueChanged);

    _animation = Tween<double>(begin: 0.0, end: guageValueNotifier.value)
        .animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _onGoingAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _onGoingAnimation.add(Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _onGoingAnimationController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeInOutCubic))));

    _onGoingAnimation.add(Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _onGoingAnimationController,
            curve: const Interval(0.4, 1.0, curve: Curves.linear))));

    _controller.forward();

    onGoingAnimationCallback();
  }

  @override
  void dispose() {
    _controller.dispose();
    _isOnGoingAnimationControllerDisposed = true;
    _onGoingAnimationController.dispose();
    guageValueNotifier.removeListener(_valueChanged);
    super.dispose();
  }

  Future onGoingAnimationCallback() async {
    while (true) {
      if (_isOnGoingAnimationControllerDisposed) {
        break;
      }
      await Future.delayed(const Duration(milliseconds: 100));
      _onGoingAnimationController.value = 0;
      await _onGoingAnimationController.forward();
    }
  }

  void _valueChanged() {
    if (guageValueNotifier.value <= 0.0) {
      changeTarget(0.001);
    } else if (guageValueNotifier.value > 1.0) {
      changeTarget(1);
    } else {
      changeTarget(guageValueNotifier.value);
    }
  }

  void changeTarget(double newTarget) {
    _animation = Tween<double>(begin: _animation.value, end: newTarget).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height.r,
      width: widget.width.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
              animation: _onGoingAnimation[1],
              builder: (context, _) {
                return Opacity(
                  opacity: _onGoingAnimation[1].value,
                  child: Transform.rotate(
                    // angle: (math.pi / 5) * 6,
                    angle: (0.2 * math.pi) * 6,
                    child: SizedBox(
                      height: widget.height.r,
                      width: widget.width.r,
                      child: CircularProgressIndicator(
                        strokeWidth: widget.strokeWidth.r,
                        strokeCap: StrokeCap.round,
                        color: widget.foregroundColor.withOpacity(0.3),
                        value: _onGoingAnimation[0].value * 0.8,
                      ),
                    ),
                  ),
                );
              }),

          Transform.rotate(
            // angle: (math.pi / 5) * 6,
            angle: (0.2 * math.pi) * 6,
            child: SizedBox(
              height: widget.height.r,
              width: widget.width.r,
              child: CircularProgressIndicator(
                strokeWidth: widget.strokeWidth.r,
                strokeCap: StrokeCap.round,
                color: _backgroundColor,
                value: 0.8,
              ),
            ),
          ),
          Transform.rotate(
            // angle: (math.pi / 5) * 6,
            angle: (0.2 * math.pi) * 6,
            child: SizedBox(
              height: widget.height.r,
              width: widget.width.r,
              child: CircularProgressIndicator(
                strokeWidth: widget.strokeWidth.r,
                strokeCap: StrokeCap.round,
                color: widget.foregroundColor,
                value: (_animation.value) * 0.8,
              ),
            ),
          ),

          // the white indicators
          for (int i = 1; i <= 15; i++)
            Transform.rotate(
              angle: (i * (math.pi / 9)) + (math.pi / 5) * 5.55,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: widget.strokeWidth.r),
                    width: 3.w,
                    height: (widget.height.r / 30),
                    decoration: BoxDecoration(
                      color: _guageIndicatorColor,
                      borderRadius: BorderRadius.circular(widget.height.r),
                    ),
                  ),
                ],
              ),
            ),

          ValueListenableBuilder(
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
                    kText('Remaining',
                        fontSize: 13,
                        color: ColorConstantsDark.buttonBackgroundColor
                            .withOpacity(0.5)),
                    kText(
                        timeValueNotifier.value.inHours > 0
                            ? 'Completed'
                            : '${timeValueNotifier.value.inHours.abs()}h ${timeValueNotifier.value.inMinutes.remainder(60).abs()}m',
                        fontSize: 13,
                        color: ColorConstantsDark.buttonBackgroundColor
                            .withOpacity(0.5)),
                  ],
                );
              }),
          Positioned(
            bottom: 0,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: widget.height.r,
                  width: widget.width.r,
                  child: Transform.rotate(
                    angle: ((0.4 * math.pi) * 3) - (0.3 * math.pi),
                    child: CircularProgressIndicator(
                      strokeWidth: widget.strokeWidth.r,
                      strokeCap: StrokeCap.round,
                      // color: widget.backgroundColor,
                      color: ColorConstantsDark.container2Color,
                      value: 0.1,
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, widget.strokeWidth.sp * 0.3),
                  child: kText(
                    '${widget.fastingTimeRatio.fast}:${widget.fastingTimeRatio.eat}',
                    color: ColorConstantsDark.buttonBackgroundColor,
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            // child: ElevatedButton.icon(
            //   onPressed: () async =>
            //       await Navigator.of(context).push(PeriodSelectionPage.route()),
            //   icon: Icon(
            //     FontAwesomeIcons.pen,
            //     size: 13.r,
            //   ),
            //   label: BlocBuilder<FastingBloc, FastingState>(
            //     buildWhen: ((previous, current) {
            //       if (current is FastingStateSelectedTimeRatio) {
            //         return true;
            //       }
            //       return false;
            //     }),
            //     builder: (context, state) {
            //       if (state is! FastingStateSelectedTimeRatio) {
            //         return Container();
            //       }

            //       return kText(
            //         '${state.fastingTimeRatio.fast}:${state.fastingTimeRatio.eat}',
            //         letterSpacing: 1,
            //       );
            //     },
            //   ),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: ColorConstantsDark.container2Color,
            //   ),
            // ),
          ),

          // Outer Animation

          // Positioned(
          //   bottom: 0,
          //   child: _GuageOuterAnimation(
          //     height: widget.height.r,
          //     width: widget.width.r,
          //     strokeWidth: widget.strokeWidth.r,
          //   ),
          // )
        ],
      ),
    );
  }
}

class _GuageOuterAnimation extends StatefulWidget {
  final double height;
  final double width;
  final double strokeWidth;
  const _GuageOuterAnimation(
      {required this.height, required this.width, required this.strokeWidth});

  @override
  State<_GuageOuterAnimation> createState() => __GuageOuterAnimationState();
}

class __GuageOuterAnimationState extends State<_GuageOuterAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation animation;

  @override
  void initState() {
    animController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    animation =
        CurvedAnimation(parent: animController, curve: Curves.easeInOutQuad);

    animController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        builder: (context, value) {
          return SizedBox(
            height: widget.height,
            width: widget.width,
            child: Transform.scale(
              scale: 1.2,
              child: Transform.rotate(
                angle: 0.7 * (2 * math.pi) * animation.value,
                child: Transform.rotate(
                  angle: ((0.4 * math.pi) * 3) - (0.0 * math.pi),
                  child: CircularProgressIndicator(
                    strokeWidth: widget.strokeWidth * 0.4,
                    strokeCap: StrokeCap.round,
                    // color: widget.backgroundColor,
                    color: ColorConstantsDark.container2Color,
                    value: 0.1,
                  ),
                ),
              ),
            ),
          );
        });
  }
}
