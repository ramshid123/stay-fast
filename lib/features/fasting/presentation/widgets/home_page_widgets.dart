import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePageWidgets {
  static Widget timerSetButton({
    required String title,
    required String value,
    int index = 0,
  }) {
    return Column(
      crossAxisAlignment:
          index == 0 ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Row(
          children: index == 0
              ? [
                  kText(
                    title,
                    fontSize: 13,
                    color: ColorConstantsDark.buttonBackgroundColor
                        .withOpacity(0.7),
                  ),
                  kWidth(10.w),
                  Icon(
                    FontAwesomeIcons.pen,
                    size: 14.r,
                  ),
                ]
              : [
                  Icon(
                    FontAwesomeIcons.pen,
                    size: 14.r,
                  ),
                  kWidth(10.w),
                  kText(
                    title,
                    fontSize: 13,
                    color: ColorConstantsDark.buttonBackgroundColor
                        .withOpacity(0.7),
                  ),
                ],
        ),
        kHeight(2.h),
        kText(
          value,
          fontSize: 13,
        ),
      ],
    );
  }

  static Widget tipsContainer({
    required String emoji,
    required String title,
    required String content,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      margin: EdgeInsets.only(bottom: 10.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorConstantsDark.container1Color,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: RichText(
        text: TextSpan(
          text: emoji,
          style: TextStyle(
            height: 1.4.h,
            fontSize: 14.sp,
            letterSpacing: 0.7,
          ),
          children: [
            TextSpan(
              text: ' $title: ',
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: content,
              style: const TextStyle(
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
