
import 'package:fasting_app/core/entities/time_ration_entity.dart';
import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/utils/format_datetime.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class HomePageWidgets {
  static Widget timerSetButton({
    required String title,
    required DateTime dateTime,
    int index = 0,
  }) {
    return Expanded(
      child: Column(
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
          ),
          kText(
            DateFormat('h:mm a').format(dateTime),
            fontSize: 13,
          )
        ],
      ),
    );
  }

  static Widget screenshotRepaintBoundary({
    required DateTime startTime,
    required Duration duration,
    required FastingTimeRatioEntity fastingTimeRatio,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      height: 500.r,
      width: 500.r,
      decoration: BoxDecoration(
        color: ColorConstantsDark.backgroundColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: Container(),
      ),
    );
  }

  static Widget tipsContainer({
    required String emoji,
    required String title,
    required String content,
    required int index,
    required Animation animation,
  }) {
    return _TipsContainer(
      emoji: emoji,
      title: title,
      content: content,
      animation: animation,
      index: index,
    );
  }
}

class _TipsContainer extends StatefulWidget {
  final String emoji;
  final String title;
  final String content;
  final Animation animation;
  final int index;
  const _TipsContainer(
      {required this.emoji,
      required this.title,
      required this.content,
      required this.animation,
      required this.index});

  @override
  State<_TipsContainer> createState() => _TipsContainerState();
}

class _TipsContainerState extends State<_TipsContainer> {
  final _key = GlobalKey();

  double containerHeight = 0;

  @override
  void initState() {
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      containerHeight = _key.currentContext!.size!.height;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      key: _key,
      animation: widget.animation,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(
              0,
              widget.animation.value *
                  (containerHeight / 1.2) *
                  -(widget.index - 1)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            margin: EdgeInsets.only(bottom: 10.h),
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorConstantsDark.container1Color,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: RichText(
              text: TextSpan(
                text: widget.emoji,
                style: TextStyle(
                  height: 1.4.h,
                  fontSize: 14.sp,
                  letterSpacing: 0.7,
                ),
                children: [
                  TextSpan(
                    text: ' ${widget.title}: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: widget.content,
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
