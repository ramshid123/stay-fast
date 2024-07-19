

import 'package:fasting_app/core/animations/opacity_translate_y.dart';
import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/utils/vibrate.dart';
import 'package:fasting_app/core/widgets/bottom_nav_bar.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:fasting_app/features/fasting/presentation/bloc/fasting_bloc.dart';
import 'package:fasting_app/features/fasting/presentation/widgets/dashboard_page_widgets.dart';
import 'package:fasting_app/features/fasting/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});


  static route() => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const DashBoardPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween<Offset>(
                begin: const Offset(1, 0), 
                end: Offset.zero, 
              ).chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      );

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage>
    with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late List<Animation> _animations;

  @override
  void initState() {
    context.read<FastingBloc>().add(FastingEventGetAllFasts());
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));


    _animations = [];

    _animations.add(Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.1, 0.4, curve: Curves.easeInOut))));

    _animations.add(Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeInOut))));

    _animations.add(Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 0.9, curve: Curves.easeInOut))));

    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: kText(
          'Dashboard',
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        actions: [
          InkWell(
            onTap: () async {
              vibrate();
              await Navigator.of(context).push(SettingsPage.route());
            },
            child: const Icon(
              FontAwesomeIcons.gear,
            ),
          ),
          kWidth(15.w),
        ],
      ),
      bottomNavigationBar: bottomNavBar(context: context, index: 2),
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
                        title: 'Fasts',
                        data: state.totalFasts.toString(),
                        animation: _animations[0],
                      ),
                      _countDataContainer(
                        title: 'Longest Fast',
                        data:
                            formatDuration(
                                Duration(milliseconds: state.longestFast)),
                        animation: _animations[0],
                      ),
                
                      _countDataContainer(
                        title: 'Total fasting time',
                        data: Duration(milliseconds: state.totalFastingHours)
                                    .inHours >
                                1000
                            ? '${Duration(milliseconds: state.totalFastingHours).inHours ~/ 1000}k hrs'
                            : formatDuration(Duration(
                                milliseconds: state.totalFastingHours)),
                        animation: _animations[1],
                      ),
                      _countDataContainer(
                        title: 'Days with fast',
                        data: state.daysWithFast.toString(),
                        animation: _animations[1],
                      ),
                    ],
                  );
                },
              ),
              kHeight(20.h),
              animatedOpacityTranslation(
                animation: _animations[2],
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
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
                   
                        ],
                      ),
                      kHeight(20.h),
                      kText(
                        'Time fasted each day',
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
                                  
                                  children: [
                                    kText(
                                      formatDuration(Duration(
                                          milliseconds: state.longestFast)),
                                      
                                      fontSize: 11,
                                      color: ColorConstantsDark.iconsColor
                                          .withOpacity(0.7),
                                    ),
                                    const Spacer(),
                                    kText(
                                      formatDuration(Duration(
                                          milliseconds:
                                              state.longestFast ~/ 2)),
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
                                  child: Builder(builder: (context) {
                                    ScrollDirection scrollDirection =
                                        ScrollDirection.forward;
                                    return NotificationListener<
                                        UserScrollNotification>(
                                      onNotification: (notification) {
                                        scrollDirection =
                                            notification.direction;
                                        return true;
                                      },
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        reverse: true,
                                        
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          final dateTime = DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month,
                                                  DateTime.now().day)
                                              .subtract(Duration(days: index));
                                          int value = 0;

                                          state.fastList
                                              .where((fast) =>
                                                  fast.savedOn == dateTime)
                                              .forEach((e) {
                                            value = value +
                                                (e.completedDurationInMilliseconds ??
                                                    0);
                                          });
                                          return DashboardGraphItem(
                                            value: state.longestFast == 0
                                                ? 0
                                                : (value / state.longestFast) *
                                                    100,
                                            dateTime: dateTime,
                                            scrollDirection: scrollDirection,
                                          );
                                        },
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  Widget _countDataContainer({
    required String title,
    required String data,
    required Animation animation,
  }) {
    return animatedOpacityTranslation(
      animation: animation,
      child: Container(
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
      ),
    );
  }

  String formatDuration(Duration duration) {
    if (duration.inMilliseconds < Duration.secondsPerMinute * 1) {
      return '${duration.inSeconds}s';
    } else if (duration.inMilliseconds <
        Duration.minutesPerHour * Duration.secondsPerMinute) {
      return '${duration.inMinutes}m';
    } else {
      int hours = duration.inHours;
      int remainingMinutes =
          duration.inMinutes.remainder(Duration.minutesPerHour);
      int remainingSeconds =
          duration.inSeconds.remainder(Duration.secondsPerMinute);

      String formattedDuration = '';
      if (hours > 0) {
        formattedDuration += '${hours}h ';
      }
      if (remainingMinutes > 0) {
        formattedDuration += '${remainingMinutes}m ';
      }
      if (remainingSeconds > 0) {
        formattedDuration += '${remainingSeconds}s';
      }
      return formattedDuration.trim();
    }
  }
}
