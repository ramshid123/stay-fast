import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RotatingCircle extends StatefulWidget {
  const RotatingCircle({super.key});

  @override
  State<RotatingCircle> createState() => _RotatingCircleState();
}

class _RotatingCircleState extends State<RotatingCircle> {
  ValueNotifier sizeValue = ValueNotifier(Size(100.r, 200.r));
  final _sizeState1 = Size(100.r, 200.r);
  final _sizeState2 = Size(200.r, 100.r);

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      sizeValue.value =
          sizeValue.value == _sizeState1 ? _sizeState2 : _sizeState1;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: sizeValue,
        builder: (context, value, child) {
          return AnimatedContainer(
            height: 200.r,
            width: 100.r,
            duration: const Duration(seconds: 3),
            curve: Curves.linear,
            child: const CircularProgressIndicator(
              value: 1.0,
            ),
          );
        });
  }
}
