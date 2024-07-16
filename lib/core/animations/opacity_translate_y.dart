import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget animatedOpacityTranslation({
    required Widget child,
    required Animation animation,
    bool isTranslated = true,
  }) {
    return AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          return Opacity(
            opacity: animation.value,
            child: Transform.translate(
              offset: Offset(
                  0.0, isTranslated ? ((1 - animation.value) * 50.h) : 0),
              child: child,
            ),
          );
        });
  }