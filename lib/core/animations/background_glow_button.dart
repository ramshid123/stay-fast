import 'dart:developer';

import 'package:fasting_app/core/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackgroundGlowButton extends StatefulWidget {
  final Widget child;
  const BackgroundGlowButton({
    super.key,
    required this.child,
  });

  @override
  State<BackgroundGlowButton> createState() => _BackgroundGlowButtonState();
}

class _BackgroundGlowButtonState extends State<BackgroundGlowButton>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  List<Animation<Offset>> animations = [];

  bool isControllerDisposed = false;

  final radius = 7.r;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));

    animations.add(TweenSequence([
      TweenSequenceItem(
          tween: Tween<Offset>(
            begin: Offset(radius, radius),
            end: Offset(radius, -radius),
          ),
          weight: 1 / 4),
      TweenSequenceItem(
          tween: Tween<Offset>(
            begin: Offset(radius, -radius),
            end: Offset(-radius, -radius),
          ),
          weight: 1 / 4),
      TweenSequenceItem(
          tween: Tween<Offset>(
            begin: Offset(-radius, -radius),
            end: Offset(-radius, radius),
          ),
          weight: 1 / 4),
      TweenSequenceItem(
          tween: Tween<Offset>(
            begin: Offset(-radius, radius),
            end: Offset(radius, radius),
          ),
          weight: 1 / 4),
    ]).animate(
        CurvedAnimation(parent: animationController, curve: Curves.linear)));

    animations.add(TweenSequence([
      TweenSequenceItem(
          tween: Tween<Offset>(
            begin: Offset(radius, -radius),
            end: Offset(-radius, -radius),
          ),
          weight: 1 / 4),
      TweenSequenceItem(
          tween: Tween<Offset>(
            begin: Offset(-radius, -radius),
            end: Offset(-radius, radius),
          ),
          weight: 1 / 4),
      TweenSequenceItem(
          tween: Tween<Offset>(
            begin: Offset(-radius, radius),
            end: Offset(radius, radius),
          ),
          weight: 1 / 4),
      TweenSequenceItem(
          tween: Tween<Offset>(
            begin: Offset(radius, radius),
            end: Offset(radius, -radius),
          ),
          weight: 1 / 4),
    ]).animate(
        CurvedAnimation(parent: animationController, curve: Curves.linear)));

    animationController.repeat().catchError((e) {
      log('glow button error => ${e.toString()}');
      animationController.dispose();
    });
    super.initState();
  }

  @override
  void dispose() {
    isControllerDisposed = true;
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animations[0],
        builder: (context, _) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.r),
              boxShadow: [
                BoxShadow(
                  color:
                      ColorConstantsDark.buttonBackgroundColor.withOpacity(0.8),
                  offset: animations[0].value,
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color:
                      ColorConstantsDark.buttonBackgroundColor.withOpacity(0.8),
                  offset: animations[1].value,
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.transparent.withOpacity(0.8),
                  offset: -animations[0].value,
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.transparent.withOpacity(0.8),
                  offset: -animations[1].value,
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: widget.child,
          );
        });
  }
}
