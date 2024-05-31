import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:fasting_app/features/fasting/presentation/pages/dashboard_page.dart';
import 'package:fasting_app/features/fasting/presentation/pages/home_page.dart';
import 'package:fasting_app/features/fasting/presentation/pages/journal_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget bottomNavBar(BuildContext context) {
  return Container(
    height: 70.h,
    color: ColorConstantsDark.backgroundColor,
    width: double.infinity,
    child: Row(
      children: [
        _bottomNavBarItem(
            text: 'Fast',
            icon: FontAwesomeIcons.house,
            context: context,
            route: HomePage.route()),
        _bottomNavBarItem(
            text: 'Journal',
            icon: FontAwesomeIcons.book,
            context: context,
            route: JournalPage.route()),
        _bottomNavBarItem(
            text: 'Dashboard',
            icon: FontAwesomeIcons.solidUser,
            context: context,
            route: DashBoardPage.route()),
      ],
    ),
  );
}

Widget _bottomNavBarItem({
  required MaterialPageRoute route,
  required BuildContext context,
  required String text,
  required IconData icon,
}) {
  return Expanded(
    child: GestureDetector(
      onTap: () async => await Navigator.of(context)
          .pushAndRemoveUntil(route, (route) => false),
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              size: 25.r,
            ),
            kText(
              text,
              fontSize: 13,
              color: ColorConstantsDark.iconsColor,
            ),
          ],
        ),
      ),
    ),
  );
}
