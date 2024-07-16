import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Text kText(
  String text, {
  FontWeight fontWeight = FontWeight.normal,
  double fontSize = 15,
  Color? color,
  TextAlign textAlign = TextAlign.left,
  bool softWrap = true,
  TextOverflow overflow = TextOverflow.ellipsis,
  int? maxLines,
  double? letterSpacing,
  String? fontFamily,
}) {
  return Text(
    text,
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLines,
    softWrap: softWrap,
    style: fontFamily == null
        ? TextStyle(
            fontWeight: fontWeight,
            letterSpacing: letterSpacing,
            fontSize: fontSize.sp,
            color: color,
          )
        : GoogleFonts.getFont(
            fontFamily,
            fontWeight: fontWeight,
            letterSpacing: letterSpacing,
            fontSize: fontSize.sp,
            color: color,
          ),
  );
}

SizedBox kHeight(double height) {
  return SizedBox(height: height);
}

SizedBox kWidth(double width) {
  return SizedBox(width: width);
}
