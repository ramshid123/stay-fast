import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessCracker extends StatefulWidget {
  final bool isPlayed;
  const SuccessCracker({super.key, required this.isPlayed});

  @override
  State<SuccessCracker> createState() => SuccessCrackerState();
}

class SuccessCrackerState extends State<SuccessCracker>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));

    if (widget.isPlayed) {
      _animationController.forward();
    }
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Visibility(
        visible: widget.isPlayed,
        child: Lottie.asset(
          'assets/lottie/achievement_animation.json',
          height: double.infinity,
          width: double.infinity,
          controller: _animationController,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
