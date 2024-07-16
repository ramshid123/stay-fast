import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget animatedTranslateX(
    {required Widget child,
    required Animation animation,
    required double width}) {
  return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset((1-animation.value) * -width.w / 1.5, 0),
          child: child,
        );
      });
}
