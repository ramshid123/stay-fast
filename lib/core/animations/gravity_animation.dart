import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GravityMockAnimation extends StatefulWidget {
  final Widget child;
  const GravityMockAnimation({super.key, required this.child});

  @override
  State<GravityMockAnimation> createState() => _GravityMockAnimationState();
}

class _GravityMockAnimationState extends State<GravityMockAnimation>
    with SingleTickerProviderStateMixin {
  ValueNotifier<List<double>> angles = ValueNotifier([0.0, 0.0, 0.0]);

  late AnimationController _controller;
  late Tween<double> _angleTween;
  late Animation<double> _angleAnimation;

  late StreamSubscription<AccelerometerEvent> accelerometerListener;

  bool isControllerDisposed = false;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _angleTween = Tween<double>(begin: 0.0, end: 0.0);
    _angleAnimation = _angleTween
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    accelerometerListener =
        accelerometerEventStream(samplingPeriod: const Duration(milliseconds: 600))
            .listen(
      (AccelerometerEvent event) {
        if (isControllerDisposed) return;

        var newAngles = [event.x, event.y, event.z];
        double oldAngle = angles.value[0];
        double newAngle = newAngles[0];

        _angleTween.begin = oldAngle * 8 * (math.pi / 180.0);
        _angleTween.end = newAngle * 8 * (math.pi / 180.0);

        _controller.reset();
        _controller.forward();

        angles.value = newAngles;
      },
      onError: (error) {},
      cancelOnError: true,
    );

    super.initState();
  }

  @override
  void dispose() {
    accelerometerListener.cancel();
    isControllerDisposed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _angleAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _angleAnimation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
