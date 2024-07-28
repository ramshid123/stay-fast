import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:fasting_app/features/fasting/presentation/widgets/period_selection_page_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PeriodSelectionPage extends StatelessWidget {
  const PeriodSelectionPage({super.key});

  static route() =>
      MaterialPageRoute(builder: (context) => const PeriodSelectionPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: kText(
          'Choose a plan',
          fontSize: 20,
        ),
        centerTitle: false,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              kHeight(20.h),
              kText(
                'Beginner plan',
                fontSize: 15,
                color: ColorConstantsDark.iconsColor,
              ),
              kHeight(15.h),
              PeriodSelectionPageWidgets.periodGridList(
                level: 'level1',
                context: context,
              ),
              kHeight(25.h),
              kText(
                'Intermediate plan',
                fontSize: 15,
                color: ColorConstantsDark.iconsColor,
              ),
              kHeight(15.h),
              PeriodSelectionPageWidgets.periodGridList(
                level: 'level2',
                context: context,
              ),
              kHeight(25.h),
              kText(
                'Advanced plan',
                fontSize: 15,
                color: ColorConstantsDark.iconsColor,
              ),
              kHeight(15.h),
              PeriodSelectionPageWidgets.periodGridList(
                level: 'level3',
                context: context,
              ),
              kHeight(25.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: ColorConstantsDark.container2Color,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    kText(
                      'Flexi',
                      fontSize: 18,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w500,
                    ),
                    kHeight(10.h),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 5.r,
                          backgroundColor:
                              ColorConstantsDark.buttonBackgroundColor,
                        ),
                        kWidth(5.w),
                        kText(
                          'Fast as long as you want',
                          fontSize: 13,
                          color: ColorConstantsDark.iconsColor,
                        ),
                      ],
                    ),
                    kHeight(30.h),
                  ],
                ),
              ),
              kHeight(20.h),
            ],
          ),
        ),
      ),
    );
  }
}
