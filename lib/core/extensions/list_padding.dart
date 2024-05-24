import 'package:flutter/material.dart';

extension ListPaddingExtension on List<Widget> {
  List<Widget> kPaddingOnly({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return map((widget) {
      return Padding(
        padding: EdgeInsets.only(
          left: left ?? 0,
          top: top ?? 0,
          right: right ?? 0,
          bottom: bottom ?? 0,
        ),
        child: widget,
      );
    }).toList();
  }
}
