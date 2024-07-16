import 'dart:math' as math;

import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DashboardGraphItem extends StatefulWidget {
  final DateTime dateTime;
  final double value;
  final ScrollDirection scrollDirection;
  const DashboardGraphItem(
      {super.key,
      required this.dateTime,
      required this.value,
      required this.scrollDirection});

  @override
  State<DashboardGraphItem> createState() => _DashboardGraphItemState();
}

class _DashboardGraphItemState extends State<DashboardGraphItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  final animDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    // TODO: implement initState
    _animationController =
        AnimationController(vsync: this, duration: animDuration);
    _animationController.value = 1;
    _animation = CurvedAnimation(
        parent: _animationController, curve: Curves.easeInCubic);

    _animationController.reverse();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(builder: (context, c) {
            return AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: (math.pi / 2) *
                        ((widget.scrollDirection == ScrollDirection.reverse
                                ? -0.5
                                : 0.5) *
                            _animation.value),
                    alignment: Alignment.bottomCenter,
                    child: Transform.scale(
                      scaleY: 1 - double.parse((_animation.value/2).toString()),
                      alignment: Alignment.bottomCenter,
                      child: AnimatedContainer(
                        duration: animDuration,
                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                        width: 30.w,
                        decoration: BoxDecoration(
                          color: ColorConstantsDark.buttonBackgroundColor
                              .withOpacity(0.3),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(50.r),
                            bottom: Radius.circular(50.r * _animation.value),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedContainer(
                            duration: animDuration,
                            height: (widget.value / 100) * c.maxHeight.h,
                            width: 30.w,
                            decoration: BoxDecoration(
                              color: ColorConstantsDark.buttonBackgroundColor,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(50.r),
                                bottom:
                                    Radius.circular(50.r * _animation.value),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }),
        ),
        Container(
          width: 40.w,
          height: 1.h,
          color: ColorConstantsDark.iconsColor.withOpacity(0.5),
        ),
        kText(
          DateFormat('E').format(widget.dateTime),
          fontSize: 11,
        ),
        kText(
          DateFormat('d').format(widget.dateTime),
          fontSize: 11,
        ),
        kText(
          DateFormat('MMM').format(widget.dateTime),
          fontSize: 9,
          color: ColorConstantsDark.iconsColor.withOpacity(0.7),
        ),
      ],
    );
  }
}
