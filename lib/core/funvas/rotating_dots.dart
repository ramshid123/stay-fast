import 'dart:math';
import 'dart:ui';

import 'package:fasting_app/core/theme/palette.dart';
import 'package:funvas/funvas.dart';

class RotatingSquaresFunvas extends Funvas {
  @override
  void u(double t) {
    t /= 2;
    t *= pi / 2;
    const d = 750.0, r = d / 2.1;
    s2q(d);
    c.translate(d / 2, d / 2);
    const n = 3;
    for (var i = 0; i < n; i++) {
      _drawWheel(t + 2 * pi / n * i, r);
    }
  }

  void _drawWheel(double t, double r) {
    c.save();
    const n = 42;
    for (var i = 0; i < n; i++) {
      c.rotate(2 * pi / n);
      _drawStreak(t, r * 1.3, 5, i*3 / n);
    }
    c.restore();
  }

  void _drawStreak(double t, double r, double pr, double offset) {
    const n = 9;
    const delay = 0.4;
    const opacity = 0xaa / 0xff;
    for (var i = n; i >= 0; i--) {
      final lt = t - delay / n * i;
      final lo = opacity * (1 - 1 / n * i);

      _drawParticle(
        lt*2,
        r*1.3,
        pr,
        offset,
        ColorConstantsDark.buttonBackgroundColor.withOpacity(lo),
      );
    }
  }

  void _drawParticle(
    double t,
    double r,
    double pr,
    double offset,
    Color color,
  ) {
    c.drawCircle(
      Offset(r / 2 + r / 2 * S(1 / 2 + 1 / 2 * C(t + 2 * pi * offset))/2.5, 0),
      pr/2,
      Paint()
        ..color = color
        ..blendMode = BlendMode.screen,
    );
  }
}
