import 'dart:developer';

import 'package:fasting_app/core/entities/fast_entity.dart';
import 'package:fasting_app/core/entities/time_ration_entity.dart';
import 'package:fasting_app/core/extensions/list_padding.dart';
import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/widgets/bottom_nav_bar.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:fasting_app/features/fasting/presentation/bloc/fasting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';

class JournalPage extends StatelessWidget {
  JournalPage({super.key});

  static route() => MaterialPageRoute(builder: (context) => JournalPage());

  Map<int, int?> fastingHoursCache = {};

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(size.width, 250.h),
        child: SafeArea(
          child: Container(
            color: ColorConstantsDark.backgroundColor,
            child: Column(
              children: [
                kHeight(10.h),
                kText(
                  'Journal',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                kHeight(20.h),
                Expanded(
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: ListWheelScrollView.useDelegate(
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          if (DateTime.now()
                              .subtract(Duration(days: index))
                              .isAfter(DateTime.now())) {
                            return null;
                          }

                          final today = DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day);
                          if (!fastingHoursCache.containsKey(today
                              .subtract(Duration(days: index))
                              .millisecondsSinceEpoch)) {
                            context.read<FastingBloc>().add(
                                FastingEventGetFastOnDate(
                                    today.subtract(Duration(days: index))));
                          }

                          return _scrollItem(
                            context: context,
                            dateTime: DateTime(DateTime.now().year,
                                    DateTime.now().month, DateTime.now().day)
                                .subtract(Duration(days: index)),
                          );
                        },
                      ),
                      diameterRatio: size.width,
                      itemExtent: 60.w,
                    ),
                  ),
                ),
                kHeight(20.h),
                kText(
                  'Today, 4:52 PM',
                  fontSize: 23,
                ),
                kHeight(10.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: bottomNavBar(context),
      body: SingleChildScrollView(
        clipBehavior: Clip.none,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              kHeight(10.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
                decoration: BoxDecoration(
                  color: ColorConstantsDark.container1Color,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        kText(
                          'Fasts',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        kWidth(10.w),
                        kText(
                          '[0h 0m]',
                          fontSize: 13,
                          color: ColorConstantsDark.iconsColor,
                        ),
                        const Spacer(),
                        kText(
                          'Add fast',
                          fontSize: 13,
                          color: ColorConstantsDark.iconsColor,
                        ),
                        kWidth(10.w),
                        Icon(
                          FontAwesomeIcons.circlePlus,
                          size: 17.r,
                        ),
                      ],
                    ),
                    BlocBuilder<FastingBloc, FastingState>(
                      buildWhen: (previous, current) {
                        if (current is FastingStateSelectedJournalDate) {
                          return true;
                        }
                        return false;
                      },
                      builder: (context, state) {
                        List<FastEntity> fastEntities = [];
                        if (state is FastingStateSelectedJournalDate) {
                          fastEntities = state.fastEntities;
                        }
                        return Column(
                          children: [
                            if (fastEntities.isEmpty) ...[
                              kHeight(20.h),
                              Align(
                                alignment: Alignment.center,
                                child: kText(
                                  'No fasts for the day',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              kHeight(20.h)
                            ] else
                              for (var fast in fastEntities) _fastItem(fast),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              kHeight(20.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
                decoration: BoxDecoration(
                  color: ColorConstantsDark.container1Color,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        kText(
                          'Weight',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        const Spacer(),
                        CircleAvatar(
                          backgroundColor:
                              ColorConstantsDark.iconsColor.withOpacity(0.1),
                          radius: 15.r,
                          child: Icon(
                            FontAwesomeIcons.pen,
                            size: 14.r,
                          ),
                        ),
                      ],
                    ),
                    kHeight(20.h),
                    kText(
                      'No weight recorded',
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                    ),
                    kHeight(20.h),
                    Container(
                      height: 10.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorConstantsDark.iconsColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                    ),
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

  Widget _scrollItem({
    required DateTime dateTime,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        context
            .read<FastingBloc>()
            .add(FastingEventSelectJournalDate(dateTime));
      },
      child: BlocBuilder<FastingBloc, FastingState>(
        builder: (context, state) {
          bool isSelected = false;

          if (state is FastingStateSelectedJournalDate) {
            if (state.selectedDate == dateTime) {
              isSelected = true;
            }
          }

          // log('hours: $hours\nlength: ${(state as FastingStateJournalItem).fastEntities.length}');

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? ColorConstantsDark.buttonBackgroundColor
                  : ColorConstantsDark.backgroundColor,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: RotatedBox(
              quarterTurns: -1,
              child: Column(
                children: [
                  kText(DateFormat('E').format(dateTime),
                      fontSize: 13,
                      color: isSelected
                          ? ColorConstantsDark.container1Color
                          : ColorConstantsDark.iconsColor),
                  kText(DateFormat('d').format(dateTime),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? ColorConstantsDark.container1Color
                          : ColorConstantsDark.iconsColor),
                  kText(DateFormat('MMM').format(dateTime),
                      fontSize: 13,
                      color: isSelected
                          ? ColorConstantsDark.container1Color
                          : ColorConstantsDark.iconsColor),
                  kHeight(8.h),
                  BlocBuilder<FastingBloc, FastingState>(
                    buildWhen: ((previous, current) {
                      // if (DateTime(2024, 5, 23).eqvDay(dateTime)) {
                      //   return true;
                      // }
                      // return false;

                      if (fastingHoursCache[dateTime.millisecondsSinceEpoch] ==
                          null) {
                        return false;
                      }

                      if (current is FastingStateJournalItem &&
                          current.fastEntities.isNotEmpty &&
                          DateTime(
                                  current.fastEntities.first.endTime!.year,
                                  current.fastEntities.first.endTime!.month,
                                  current.fastEntities.first.endTime!.day)
                              .eqvDay(dateTime)) {
                        return true;
                      }

                      return false;
                    }),
                    builder: (context, state) {
                      int? hours;
                      if (state is FastingStateJournalItem &&
                          fastingHoursCache[dateTime.millisecondsSinceEpoch] ==
                              null) {
                        for (var fast in state.fastEntities) {
                          hours = (hours ?? 0) +
                              Duration(
                                      milliseconds:
                                          fast.completedDurationInMilliseconds!)
                                  .inSeconds;
                        }

                        fastingHoursCache[dateTime.millisecondsSinceEpoch] =
                            hours;
                      }
                      log(fastingHoursCache[dateTime.millisecondsSinceEpoch]
                          .toString());

                      return fastingHoursCache[
                                  dateTime.millisecondsSinceEpoch] ==
                              null
                          ? kText(
                              '--',
                              fontSize: 13,
                              color: isSelected
                                  ? ColorConstantsDark.container1Color
                                  : ColorConstantsDark.iconsColor,
                            )
                          : Container(
                              padding: EdgeInsets.all(4.r),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? ColorConstantsDark.container1Color
                                      : ColorConstantsDark.iconsColor,
                                  width: 2.r,
                                ),
                              ),
                              child: kText(
                                '${hours}h',
                                fontSize: 13,
                                color: isSelected
                                    ? ColorConstantsDark.container1Color
                                    : ColorConstantsDark.iconsColor,
                              ),
                            );
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _fastItem(FastEntity fastEntity) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 20.h),
          height: 1.h,
          width: double.infinity,
          color: ColorConstantsDark.iconsColor.withOpacity(0.3),
        ),
        Row(
          children: [
            kText(
              '${fastEntity.fastingTimeRatio!.fast}:${fastEntity.fastingTimeRatio!.eat} fast',
              // '11:13 fast',
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
            kWidth(10.w),
            Icon(
              FontAwesomeIcons.pen,
              size: 13.r,
            ),
            const Spacer(),
            kText(
                // '0h 0m',
                '${Duration(milliseconds: fastEntity.completedDurationInMilliseconds!).inHours}h ${Duration(milliseconds: fastEntity.completedDurationInMilliseconds!).inMinutes.remainder(60)}m'),
          ],
        ),
        kHeight(5.h),
        ...[
          Row(
            children: [
              Icon(
                FontAwesomeIcons.play,
                size: 12.r,
              ),
              kWidth(5.w),
              kText(
                // 'Today 4:53 PM',
                '${DateTime(fastEntity.startTime!.year, fastEntity.startTime!.month, fastEntity.startTime!.day) == DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day) ? 'Today' : DateFormat('MMM d').format(fastEntity.startTime!)} ${DateFormat('jm').format(fastEntity.startTime!)}',
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                FontAwesomeIcons.flagCheckered,
                size: 12.r,
              ),
              kWidth(5.w),
              kText(
                // 'Today 10:12 PM',
                '${DateTime(fastEntity.endTime!.year, fastEntity.endTime!.month, fastEntity.endTime!.day) == DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day) ? 'Today' : DateFormat('MMM d').format(fastEntity.endTime!)} ${DateFormat('jm').format(fastEntity.endTime!)}',
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ],
          )
        ].kPaddingOnly(left: 10.w, top: 5.h),
      ],
    );
  }
}
