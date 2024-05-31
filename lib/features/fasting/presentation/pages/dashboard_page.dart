// import 'dart:math';

import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/widgets/bottom_nav_bar.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:fasting_app/features/fasting/presentation/bloc/fasting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  static route() =>
      MaterialPageRoute(builder: (context) => const DashBoardPage());

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  // int recordedLongestFast = 0;
  // List<FastEntity> fastList = [];

  @override
  void initState() {
    context.read<FastingBloc>().add(FastingEventGetAllFasts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: kText(
          'Dashboard',
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        actions: [
          const Icon(
            FontAwesomeIcons.gear,
          ),
          kWidth(15.w),
        ],
      ),
      bottomNavigationBar: bottomNavBar(context),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Column(
            children: [
              kHeight(20.h),
              BlocBuilder<FastingBloc, FastingState>(
                buildWhen: (previous, current) {
                  if (current is FastingStateAllFasts) {
                    return true;
                  }
                  return false;
                },
                builder: (context, state) {
                  if (state is! FastingStateAllFasts) {
                    return Container();
                  }

                  return GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.h,
                      crossAxisSpacing: 10.w,
                      mainAxisExtent: 120.h,
                    ),
                    children: [
                      _countDataContainer(
                          title: 'Fasts', data: state.totalFasts.toString()),
                      _countDataContainer(
                          title: 'Longest Fast',
                          data:
                              // '${Duration(milliseconds: state.longestFast).inHours}h'),
                              formatDuration(
                                  Duration(milliseconds: state.longestFast))),
                      _countDataContainer(
                          title: 'Total fasting time',
                          data: formatDuration(
                              Duration(milliseconds: state.totalFastingHours))),
                      // data: '${state.totalFastingHours}h'),
                      _countDataContainer(
                          title: 'Days with fast',
                          data: state.daysWithFast.toString()),
                    ],
                  );
                },
              ),
              kHeight(20.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                decoration: BoxDecoration(
                  color: ColorConstantsDark.container1Color,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        kText(
                          'Fast history',
                          fontSize: 16,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w600,
                        ),
                        const Spacer(),
                        kText(
                          'Timeline',
                          fontSize: 13,
                        ),
                        kWidth(10.w),
                        Icon(
                          FontAwesomeIcons.chevronRight,
                          size: 16.r,
                        ),
                      ],
                    ),
                    kHeight(20.h),
                    kText(
                      'Hours fasted each day',
                      fontSize: 13,
                    ),
                    kHeight(20.h),
                    BlocBuilder<FastingBloc, FastingState>(
                      buildWhen: (previous, current) {
                        if (current is FastingStateAllFasts) {
                          return true;
                        }
                        return false;
                      },
                      builder: (context, state) {
                        if (state is! FastingStateAllFasts) {
                          return Container();
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 260.h,
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  kText(
                                    formatDuration(Duration(
                                        milliseconds: state.longestFast)),
                                    // '24',
                                    fontSize: 11,
                                    color: ColorConstantsDark.iconsColor
                                        .withOpacity(0.7),
                                  ),
                                  const Spacer(),
                                  kText(
                                    formatDuration(Duration(
                                        milliseconds: state.longestFast ~/ 2)),
                                    fontSize: 11,
                                    color: ColorConstantsDark.iconsColor
                                        .withOpacity(0.7),
                                  ),
                                  const Spacer(),
                                  kText(
                                    '0',
                                    fontSize: 11,
                                    color: ColorConstantsDark.iconsColor
                                        .withOpacity(0.7),
                                  ),
                                  // const Spacer(),
                                  kText(
                                    '',
                                    fontSize: 11,
                                  ),
                                  kText(
                                    '',
                                    fontSize: 11,
                                  ),
                                  kText(
                                    '',
                                    fontSize: 9,
                                    color: ColorConstantsDark.iconsColor
                                        .withOpacity(0.7),
                                  ),
                                ],
                              ),
                            ),
                            kWidth(10.w),
                            Column(
                              children: [
                                Container(
                                  height: 230.h,
                                  width: 1.w,
                                  color: ColorConstantsDark.iconsColor
                                      .withOpacity(0.5),
                                ),
                                kText(
                                  '',
                                  fontSize: 11,
                                ),
                                kText(
                                  '',
                                  fontSize: 11,
                                ),
                                kText(
                                  '',
                                  fontSize: 9,
                                  color: ColorConstantsDark.iconsColor
                                      .withOpacity(0.7),
                                ),
                              ],
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 250.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  reverse: true,
                                  // itemCount: 20,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final dateTime = DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day)
                                        .subtract(Duration(days: index));
                                    int value = 0;

                                    state.fastList
                                        .where(
                                            (fast) => fast.savedOn == dateTime)
                                        .forEach((e) {
                                      value = value +
                                          (e.completedDurationInMilliseconds ??
                                              0);
                                    });
                                    return _graphItem(
                                        value: state.longestFast == 0
                                            ? 0
                                            : (value / state.longestFast) * 100,
                                        dateTime: dateTime);
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _graphItem({required DateTime dateTime, required double value}) {
    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(builder: (context, c) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 5.w),
              width: 30.w,
              decoration: BoxDecoration(
                color:
                    ColorConstantsDark.buttonBackgroundColor.withOpacity(0.3),
                borderRadius: BorderRadius.vertical(top: Radius.circular(50.r)),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: (value / 100) * c.maxHeight.h,
                  width: 30.w,
                  decoration: BoxDecoration(
                    color: ColorConstantsDark.buttonBackgroundColor,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(50.r)),
                  ),
                ),
              ),
            );
          }),
        ),
        Container(
          width: 40.w,
          height: 1.h,
          color: ColorConstantsDark.iconsColor.withOpacity(0.5),
        ),
        kText(
          DateFormat('E').format(dateTime),
          fontSize: 11,
        ),
        kText(
          DateFormat('d').format(dateTime),
          fontSize: 11,
        ),
        kText(
          DateFormat('MMM').format(dateTime),
          fontSize: 9,
          color: ColorConstantsDark.iconsColor.withOpacity(0.7),
        ),
      ],
    );
  }

  Widget _countDataContainer({
    required String title,
    required String data,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: ColorConstantsDark.container2Color,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          kText(
            title,
            fontSize: 14,
          ),
          kText(
            data,
            fontSize: 34,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  String formatDuration(Duration duration) {
    if (duration.inMilliseconds < Duration.secondsPerMinute * 1) {
      return '${duration.inSeconds}s';
    } else if (duration.inMilliseconds <
        Duration.minutesPerHour * Duration.secondsPerMinute) {
      return '${duration.inMinutes}m';
    } else if (duration.inMilliseconds <
        Duration.hoursPerDay * Duration.minutesPerHour) {
      return '${duration.inHours}h';
    } else {
      int days = duration.inDays;
      int remainingHours = duration.inHours.remainder(Duration.hoursPerDay);
      int remainingMinutes =
          duration.inMinutes.remainder(Duration.minutesPerHour);

      String formattedDuration = '';
      if (days > 0) {
        formattedDuration += '${days}d ';
      }
      if (remainingHours > 0) {
        formattedDuration += '${remainingHours}h ';
      }
      if (remainingMinutes > 0) {
        formattedDuration += '${remainingMinutes}m ';
      }
      return formattedDuration.trim();
    }
  }
}
