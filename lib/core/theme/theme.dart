import 'package:fasting_app/core/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static _border([Color color = ColorConstantsDark.iconsColor]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide(
          // width: 2.w,
          color: color,
        ),
      );

  static final darkMode = ThemeData.dark().copyWith(
    textTheme: GoogleFonts.poppinsTextTheme(),
    scaffoldBackgroundColor: ColorConstantsDark.backgroundColor,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: ColorConstantsDark.backgroundColor,
      iconTheme: const IconThemeData().copyWith(
        color: ColorConstantsDark.iconsColor,
      ),
    ),
    iconTheme: const IconThemeData().copyWith(
      color: ColorConstantsDark.iconsColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: _border(),
      enabledBorder: _border(ColorConstantsDark.iconsColor),
      focusedBorder: _border(ColorConstantsDark.buttonBackgroundColor),
      errorBorder: _border(Colors.red),
    ),
  );
}
