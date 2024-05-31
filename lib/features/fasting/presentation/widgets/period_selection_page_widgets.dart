import 'package:fasting_app/core/constants/fasting_periods.dart';
import 'package:fasting_app/core/entities/time_ration_entity.dart';
import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:fasting_app/features/fasting/presentation/bloc/fasting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PeriodSelectionPageWidgets {
  static Widget _periodItem(
      {required int fast, required int? eat, required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        context.read<FastingBloc>().add(FastingEventChangeFastPeriod(
            FastingTimeRatioEntity(fast: fast, eat: eat)));
        Navigator.of(context).pop();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: ColorConstantsDark.container2Color,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kText(
              eat == null ? '${fast}h' : '$fast:$eat',
              fontSize: 20,
              letterSpacing: 1,
              fontWeight: FontWeight.w500,
            ),
            kHeight(10.h),
            Row(
              children: [
                CircleAvatar(
                  radius: 5.r,
                  backgroundColor: ColorConstantsDark.buttonBackgroundColor,
                ),
                kWidth(5.w),
                kText(
                  '$fast hours fasting',
                  fontSize: 13,
                  color: ColorConstantsDark.iconsColor,
                ),
              ],
            ),
            kHeight(5.h),
            eat == null
                ? Container()
                : Row(
                    children: [
                      CircleAvatar(
                        radius: 5.r,
                        backgroundColor: ColorConstantsDark.iconsColor,
                      ),
                      kWidth(5.w),
                      kText(
                        '$eat hours eating',
                        fontSize: 13,
                        color: ColorConstantsDark.iconsColor,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  static Widget periodGridList(
      {required String level, required BuildContext context}) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 1.5.h,
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      shrinkWrap: true,
      itemCount: fastingPeriods[level]!.length,
      itemBuilder: (context, index) {
        final period = fastingPeriods[level]![index];
        return PeriodSelectionPageWidgets._periodItem(
          eat: period!.length == 1 ? null : period[1],
          fast: period[0],
          context: context,
        );
      },
    );
  }
}
