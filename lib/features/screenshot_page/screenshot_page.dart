import 'dart:ui';

import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/utils/format_datetime.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class ScreenshotPage extends StatefulWidget {
  final DateTime startTime;
  final DateTime endTime;
  const ScreenshotPage(
      {super.key, required this.startTime, required this.endTime});

  static route({
    required DateTime startTime,
    required DateTime endTime,
  }) =>
      MaterialPageRoute(
          builder: (context) => ScreenshotPage(
                endTime: endTime,
                startTime: startTime,
              ));

  @override
  State<ScreenshotPage> createState() => _ScreenshotPageState();
}

class _ScreenshotPageState extends State<ScreenshotPage>
    with SingleTickerProviderStateMixin {
  late double percentage;
  String elapsedTime = '';

  final testKey = GlobalKey();

  late AnimationController animationController;
  late Animation animation;

  Future<void> _capturePng() async {
    RenderRepaintBoundary boundary =
        testKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 3.0);
    var byteData = await image.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData!.buffer.asUint8List();

    await Share.shareXFiles([
      XFile.fromData(pngBytes,
          mimeType: 'image/png',
          name:
              'Stay Fast : ${DateFormat('dd/MM/yyyy').format(DateTime.now())}')
    ]);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void calculateElapsedTime() {
    DateTime now = DateTime.now();

    if (now.isBefore(widget.startTime)) {
      percentage = 0.0;
      elapsedTime = '0h 0m';
    } else if (now.isAfter(widget.endTime)) {
      percentage = 100.0;
      elapsedTime =
          '${widget.endTime.difference(widget.startTime).inHours}h ${widget.endTime.difference(widget.startTime).inMinutes.remainder(60)}m';
    }

    Duration elapsedDuration = now.difference(widget.startTime);

    Duration totalDuration = widget.endTime.difference(widget.startTime);

    double elapsedPercentage =
        (elapsedDuration.inMilliseconds / totalDuration.inMilliseconds) * 100;

    percentage = elapsedPercentage;
    elapsedTime =
        '${elapsedDuration.inHours}h ${elapsedDuration.inMinutes.remainder(60)}m';
  }

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    animation = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut)));

    animationController.value = 1;

    calculateElapsedTime();
    Future.delayed(const Duration(seconds: 2), () async {
      animationController.value = 0;
      animationController.forward();
      await Future.delayed(const Duration(milliseconds: 150));
      animationController.value = 0;
      animationController.forward();

      await Future.delayed(const Duration(seconds: 1));
      await _capturePng();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xff211f25),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF000000).withOpacity(0.5),
                    offset: const Offset(5, 5),
                    blurRadius: 11,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: RepaintBoundary(
                key: testKey,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff211f25),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      kHeight(15.h),
                      RichText(
                        text: TextSpan(
                          text: 'STAY',
                          style: TextStyle(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
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
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10.h),
                            height: size.width * 0.8,
                            width: size.width * 0.8,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white10,
                                  Colors.transparent,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(15.r),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                kHeight(50.h),
                                kText(
                                  'Fasting for',
                                  color: Colors.white,
                                ),
                                kText(
                                  elapsedTime,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                kHeight(15.h),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    for (int i = 0; i < 10; i++)
                                      elapsedBlocks(i * 10 <= percentage),
                                  ],
                                ),
                                kHeight(30.h),
                                SizedBox(
                                  width: size.width * 0.7,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          timeScheduleDisplay(
                                            title: 'Start',
                                            dateTime: widget.startTime,
                                            
                                            index: 0,
                                          ),
                                          kWidth(50.w),
                                          timeScheduleDisplay(
                                            title: 'End',
                                            
                                            dateTime: widget.endTime,
                                            index: 1,
                                          ),
                                        ],
                                      ),
                                      kHeight(50.h),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: kText(
                                          DateFormat('MMMM dd, yyyy hh:mm a')
                                              .format(DateTime.now()),
                                          fontSize: 10,
                                          color: Colors.white38,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                kHeight(15.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedBuilder(
              animation: animation,
              builder: (context, _) {
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.white.withOpacity(animation.value),
                );
              }),
        ],
      ),
    );
  }

  Widget elapsedBlocks(bool isElapsed) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      height: 20.r,
      width: 20.r,
      decoration: BoxDecoration(
        color: isElapsed ? Colors.white : Colors.transparent,
        border: Border.all(
          color: isElapsed ? Colors.transparent : Colors.white,
          width: 2.r,
        ),
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }

  Widget timeScheduleDisplay({
    required String title,
    required DateTime dateTime,
    int index = 0,
  }) {
    return Column(
      crossAxisAlignment:
          index == 0 ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment:
              index == 0 ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: index == 0
              ? [
                  kText(
                    title,
                    fontSize: 13,
                    color: ColorConstantsDark.buttonBackgroundColor
                        .withOpacity(0.7),
                  ),
                ]
              : [
                  kText(
                    title,
                    fontSize: 13,
                    color: ColorConstantsDark.buttonBackgroundColor
                        .withOpacity(0.7),
                  ),
                ],
        ),
        kHeight(4.h),
        kText(
          formatDateTime(dateTime, isTimeNeeded: false),
          fontSize: 13,
          color: Colors.white,
        ),
        kText(
          DateFormat('h:mm a').format(dateTime),
          fontSize: 13,
          color: Colors.white,
        )
      ],
    );
  }
}
