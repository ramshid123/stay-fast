import 'dart:async';
import 'dart:developer';

import 'package:fasting_app/core/animations/background_glow_button.dart';
import 'package:fasting_app/core/animations/gravity_animation.dart';
import 'package:fasting_app/core/entities/time_ration_entity.dart';
import 'package:fasting_app/core/enums/fast_status.dart';
import 'package:fasting_app/core/enums/guage_status.dart';
import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/utils/show_notification.dart';
import 'package:fasting_app/core/utils/vibrate.dart';
import 'package:fasting_app/core/widgets/achievement.dart';
import 'package:fasting_app/core/widgets/bottom_nav_bar.dart';
import 'package:fasting_app/core/widgets/cracker.dart';
import 'package:fasting_app/core/widgets/guage.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:fasting_app/features/fasting/presentation/bloc/fasting_bloc.dart';
import 'package:fasting_app/features/fasting/presentation/pages/period_selection_page.dart';
import 'package:fasting_app/features/fasting/presentation/pages/save_fast_page.dart';
import 'package:fasting_app/features/fasting/presentation/widgets/home_page_widgets.dart';
import 'package:fasting_app/features/screenshot_page/screenshot_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rive/rive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  

  static route() => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween<Offset>(
                begin: const Offset(-1, 0), 
                end: Offset.zero, 
              ).chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      );
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  
  
  
  
  

  late DateTime startTime;
  late DateTime endTime;
  late Duration duration;
  late FastingTimeRatioEntity fastingTimeRatio;
  late GuageStatus guageStatus;
  StateMachineController? riveLoadingController;
  final scrollController = ScrollController();

  late SMIInput riveProgress;
  

  late Timer timer;

  late AnimationController tipsAnimationController;
  late AnimationController pageAnimationController;

  List<Animation> tipsAnimations = [];
  List<Animation> pageAnimations = [];

  void _scrollListener() {
    if (scrollController.position.pixels > 10) {
      tipsAnimationController.forward();
      scrollController.removeListener(_scrollListener);
    }
  }

  void timerCallback() {
    final prevStartTime = startTime;
    final prevEndTime = endTime;
    startTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
    endTime = startTime.add(Duration(hours: fastingTimeRatio.fast!));
    if (prevStartTime != startTime || prevEndTime != endTime) {
      setState(() {});
    }
  }

  void riveLoadingInit(Artboard artboard) {
    log('riveLoadingController');
    riveLoadingController =
        StateMachineController.fromArtboard(artboard, 'Drinks_MainScene');
    artboard.addController(riveLoadingController!);
  }

  @override
  void initState() {
    tipsAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    tipsAnimations.add(Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
        parent: tipsAnimationController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeInOut))));

    tipsAnimations.add(Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
        parent: tipsAnimationController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeInOut))));

    tipsAnimations.add(Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
        parent: tipsAnimationController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeInOut))));

    tipsAnimations.add(Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
        parent: tipsAnimationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut))));

    pageAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    pageAnimations.add(Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: pageAnimationController,
            curve: const Interval(0.0, 0.6, curve: Curves.easeInOut))));

    pageAnimations.add(Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: pageAnimationController,
            curve: const Interval(0.3, 0.9, curve: Curves.easeInOut))));

    pageAnimations.add(Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: pageAnimationController,
            curve: const Interval(0.4, 1.0, curve: Curves.easeInOut))));

    startTime = DateTime.now();
    fastingTimeRatio = FastingTimeRatioEntity(fast: 13, eat: 11);
    duration = const Duration(hours: 13);
    endTime = startTime.add(Duration(hours: fastingTimeRatio.fast!));
    guageStatus = GuageStatus.inactive;

    context.read<FastingBloc>().add(FastingEventCheckFast());

    scrollController.addListener(_scrollListener);

    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (guageStatus == GuageStatus.running && timer.isActive) {
        timer.cancel();
      }
      timerCallback();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      pageAnimationController.forward();
    });
    super.initState();
  }

  @override
  void dispose() {
    pageAnimationController.dispose();
    tipsAnimationController.dispose();
    if (riveLoadingController != null) {
      riveLoadingController!.dispose();
    }
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(

          appBar: AppBar(
            centerTitle: true,
            title: AnimatedBuilder(
                animation: pageAnimations[0],
                builder: (context, _) {
                  return Opacity(
                    opacity: pageAnimations[0].value,
                    child: RichText(
                      text: TextSpan(
                        text: 'STAY',
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        children: const [
                          TextSpan(
                            text: ' FAST',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          bottomNavigationBar: bottomNavBar(context: context, index: 0),
          body: BlocListener<FastingBloc, FastingState>(
            listener: (context, state) {
              if (state is FastingStateFailure) {
                log(state.message);
              }

              if (state is FastingStateCurrentFast) {
                
              }

              if (state is FastingStateSelectedTimeRatio) {
                fastingTimeRatio = FastingTimeRatioEntity(
                    fast: state.fastingTimeRatio.fast,
                    eat: state.fastingTimeRatio.eat);
              }
            },
            child: BlocBuilder<FastingBloc, FastingState>(
              builder: (context, state) {
                if (state is FastingStateCurrentFast) {
                  if (state.fastEntity == null ||
                      state.fastEntity!.status == FastStatus.finished) {
                    guageStatus = GuageStatus.inactive;
                  } else if ((state.fastEntity!.startTime!
                              .difference(DateTime.now())
                              .abs() <
                          Duration(
                              hours:
                                  state.fastEntity!.fastingTimeRatio!.fast!) &&
                      (state.fastEntity!.status == FastStatus.ongoing))) {
                    guageStatus = GuageStatus.running;
                  } else if ((state.fastEntity!.startTime!
                              .difference(DateTime.now())
                              .abs() >=
                          Duration(
                              hours:
                                  state.fastEntity!.fastingTimeRatio!.fast!) &&
                      (state.fastEntity!.status == FastStatus.ongoing))) {
                    guageStatus = GuageStatus.finished;
                  } else {
                    guageStatus = GuageStatus.finished;
                  }
                }
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.w),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    clipBehavior: Clip.none,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                            animation: pageAnimations[1],
                            builder: (context, _) {
                              return Transform.translate(
                                offset: Offset(
                                    0, (1 - pageAnimations[1].value) * 50.h),
                                child: Opacity(
                                  opacity: pageAnimations[1].value,
                                  child: Column(
                                    children: [
                                      kHeight(10.h),
                                      Builder(builder: (context) {
                                        if (guageStatus ==
                                            GuageStatus.inactive) {
                                          return Container();
                                        }
                                        return BlocBuilder<FastingBloc,
                                            FastingState>(
                                          buildWhen: (previous, current) {
                                            if (current
                                                is FastingStateCurrentFast) {
                                              return true;
                                            }

                                            return false;
                                          },
                                          builder: (context, state) {
                                            if (state
                                                is! FastingStateCurrentFast) {
                                              return Container();
                                            }

                                            return Align(
                                              alignment: Alignment.centerLeft,
                                              child: GestureDetector(
                                                onTap: () async {
                                                  vibrate();
                                                  final start = state
                                                          .fastEntity!
                                                          .startTime ??
                                                      DateTime.now();
                                                  final end = start.add(Duration(
                                                      milliseconds: state
                                                              .fastEntity!
                                                              .durationInMilliseconds ??
                                                          const Duration(
                                                                  hours: 13)
                                                              .inMilliseconds));
                                                  await Navigator.push(
                                                      context,
                                                      ScreenshotPage.route(
                                                        startTime: start,
                                                        endTime: end,
                                                      ));
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.w,
                                                      vertical: 5.h),
                                                  decoration: BoxDecoration(
                                                    color: ColorConstantsDark
                                                        .container2Color,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons.share,
                                                        size: 15.r,
                                                        color: Colors.white60,
                                                      ),
                                                      kWidth(10.w),
                                                      kText(
                                                        'Share screenshot',
                                                        fontSize: 14,
                                                        color: Colors.white60,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }),
                                      kHeight(40.h),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          BlocBuilder<FastingBloc,
                                              FastingState>(
                                            buildWhen: (previous, current) {
                                              if (current
                                                  is FastingStateCurrentFast) {
                                                return true;
                                              }

                                              return false;
                                            },
                                            builder: (context, state) {
                                              if (state
                                                  is! FastingStateCurrentFast) {
                                                return Container();
                                              }
                                              switch (guageStatus) {
                                                case GuageStatus.running:
                                                  return KustomGuage(
                                                    backgroundColor:
                                                        ColorConstantsDark
                                                            .buttonBackgroundColor
                                                            .withOpacity(0.2),
                                                    
                                                    
                                                    foregroundColor:
                                                        ColorConstantsDark
                                                            .buttonBackgroundColor,
                                                    guageIndicatorColor:
                                                        ColorConstantsDark
                                                            .container2Color,
                                                    strokeWidth: 40.w,
                                                    startTime: state
                                                        .fastEntity!.startTime!,
                                                    duration: Duration(
                                                        milliseconds: state
                                                            .fastEntity!
                                                            .durationInMilliseconds!),
                                                    fastingTimeRatio: state
                                                        .fastEntity!
                                                        .fastingTimeRatio!,
                                                  );

                                                case GuageStatus.finished:
                                                  return SizedBox(
                                                    height: 300.h,
                                                    width: double.infinity,
                                                    
                                                    
                                                    
                                                    child: Achievement(
                                                      duration: Duration(
                                                          milliseconds: state
                                                              .fastEntity!
                                                              .durationInMilliseconds!),
                                                      startTime: state
                                                          .fastEntity!
                                                          .startTime!,
                                                      fastingTimeRatio: state
                                                          .fastEntity!
                                                          .fastingTimeRatio!,
                                                    ),
                                                    
                                                  );

                                                case GuageStatus.inactive:
                                                  return Container(
                                                    clipBehavior: Clip.none,
                                                    height: 300.r,
                                                    width: 300.r,
                                                    child: Transform.scale(
                                                      scale: 1.1,
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          vibrate();
                                                          var timePeriod =
                                                              await Navigator.push(
                                                                  context,
                                                                  PeriodSelectionPage
                                                                      .route());

                                                          if (timePeriod !=
                                                              null) {
                                                            
                                                            
                                                            
                                                            
                                                            riveProgress.value =
                                                                ((timePeriod as FastingTimeRatioEntity)
                                                                            .fast! /
                                                                        24) *
                                                                    100;
                                                          }
                                                        },
                                                        child: Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            GravityMockAnimation(
                                                              child:
                                                                  RiveAnimation
                                                                      .asset(
                                                                'assets/rive/water.riv',
                                                                onInit:
                                                                    (artboard) {
                                                                  final riveController =
                                                                      StateMachineController.fromArtboard(
                                                                          artboard,
                                                                          'State machine 1');
                                                                  artboard.addController(
                                                                      riveController!);

                                                                  riveProgress =
                                                                      riveController
                                                                          .findSMI(
                                                                              'Progress');
                                                                  
                                                                  
                                                                  
                                                                  
                                                                  
                                                                  
                                                                  
                                                                  riveProgress
                                                                          .value =
                                                                      (fastingTimeRatio.fast! /
                                                                              24) *
                                                                          100;
                                                                },
                                                              ),
                                                            ),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .timelapse_rounded,
                                                                  
                                                                  
                                                                  color: ColorConstantsDark
                                                                      .iconsColor,
                                                                  size: 50.r,
                                                                ),
                                                                kHeight(10.h),
                                                                Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10.w,
                                                                      vertical:
                                                                          5.h),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .black26,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            100.r),
                                                                  ),
                                                                  child: kText(
                                                                    
                                                                    '${fastingTimeRatio.fast} : ${fastingTimeRatio.eat}',
                                                                    color: ColorConstantsDark
                                                                        .iconsColor,
                                                                    fontSize:
                                                                        20,
                                                                  ),
                                                                ),
                                                                kHeight(10.h),
                                                                selectedTimeRatioDisplay(
                                                                    eat: fastingTimeRatio
                                                                            .eat ??
                                                                        11,
                                                                    fast: fastingTimeRatio
                                                                            .fast ??
                                                                        13),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      kHeight(50.h),
                                      BackgroundGlowButton(
                                        child: guageStatus ==
                                                GuageStatus.inactive
                                            ? ElevatedButton(
                                                
                                                
                                                onPressed: () async {
                                                  vibrate();
                                                  await pageAnimationController
                                                      .reverse();
                                                  if (context.mounted) {
                                                    context
                                                        .read<FastingBloc>()
                                                        .add(FastingEventSaveFast(
                                                            startTime:
                                                                DateTime.now(),
                                                            durationInMilliseconds: Duration(
                                                                    hours: fastingTimeRatio
                                                                        .fast!)
                                                                .inMilliseconds,
                                                            fastingTimeRatio:
                                                                fastingTimeRatio,
                                                            status: FastStatus
                                                                .ongoing));
                                                    context.read<FastingBloc>().add(
                                                        FastingEventCheckFast());
                                                  }

                                                  FlutterBackgroundService()
                                                      .invoke(
                                                          'setAsBackground');
                                                  await invokeBackgroundNotificationService(
                                                      duration: Duration(
                                                          hours:
                                                              fastingTimeRatio
                                                                  .fast!),
                                                      startTime:
                                                          DateTime.now());
                                                  await pageAnimationController
                                                      .forward();
                                                },
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                style: ElevatedButton.styleFrom(
                                                  fixedSize:
                                                      Size(size.width, 50.h),
                                                  backgroundColor:
                                                      ColorConstantsDark
                                                          .backgroundColor,
                                                  foregroundColor:
                                                      ColorConstantsDark
                                                          .buttonBackgroundColor,
                                                  side: BorderSide(
                                                    color: ColorConstantsDark
                                                        .buttonBackgroundColor,
                                                    width: 3.r,
                                                  ),
                                                ),
                                                child: kText(
                                                  'Start Fast',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                              )
                                            : ElevatedButton(
                                                onPressed: () async {
                                                  vibrate();
                                                  await pageAnimationController
                                                      .reverse();
                                                  if (context.mounted) {
                                                    await Navigator.of(context)
                                                        .push(
                                                            SaveFastPage.route(
                                                      fastingTimeRatio: (state
                                                              as FastingStateCurrentFast)
                                                          .fastEntity!
                                                          .fastingTimeRatio!,
                                                      durationInMilliseconds: state
                                                          .fastEntity!
                                                          .durationInMilliseconds!,
                                                      isarId: state
                                                          .fastEntity!.isarId!,
                                                      startTime: state
                                                          .fastEntity!
                                                          .startTime!,
                                                    ));
                                                  }
                                                  await pageAnimationController
                                                      .forward();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  fixedSize:
                                                      Size(size.width, 50.h),
                                                  backgroundColor:
                                                      ColorConstantsDark
                                                          .backgroundColor,
                                                  foregroundColor:
                                                      ColorConstantsDark
                                                          .buttonBackgroundColor,
                                                  side: BorderSide(
                                                    color: ColorConstantsDark
                                                        .buttonBackgroundColor,
                                                    width: 3.r,
                                                  ),
                                                ),
                                                child: kText(
                                                  'End Fast',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                              ),
                                      ),
                                      kHeight(20.h),
                                      Visibility(
                                        visible:
                                            guageStatus == GuageStatus.inactive,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                HomePageWidgets.timerSetButton(
                                                  title: 'Start',
                                                  dateTime: startTime,
                                                  
                                                  index: 0,
                                                ),
                                                kWidth(20.w),
                                                HomePageWidgets.timerSetButton(
                                                  title: 'End',
                                                  
                                                  dateTime: endTime,
                                                  index: 1,
                                                ),
                                              ],
                                            ),
                                            kHeight(40.h),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                        AnimatedBuilder(
                            animation: pageAnimations[2],
                            builder: (context, _) {
                              return Transform.translate(
                                offset: Offset(
                                    0, (1 - pageAnimations[2].value) * 50.h),
                                child: Opacity(
                                  opacity: pageAnimations[2].value,
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: kText(
                                          '💡 Tips',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      kHeight(15.h),
                                      HomePageWidgets.tipsContainer(
                                          animation: tipsAnimations[0],
                                          index: 1,
                                          emoji: '💦',
                                          title: 'Stay hydrated',
                                          content:
                                              'Drink plenty of water throughout your fasting period to stay hydrated and help manage hunger and fatigue.'),
                                      HomePageWidgets.tipsContainer(
                                          animation: tipsAnimations[1],
                                          index: 2,
                                          emoji: '🏃',
                                          title: 'Stay busy',
                                          content:
                                              'Keep yourself occupied with work, hobbies or exercies to distract from hunger and make fasting hours pass more quickly.'),
                                      HomePageWidgets.tipsContainer(
                                          animation: tipsAnimations[2],
                                          index: 3,
                                          emoji: '🧘🏻‍♂️',
                                          title: 'Listen to your body',
                                          content:
                                              'Pay attention to how your body responds to fasting and adjust your fasting schedule as needed. If you feel unwell, consider breaking your fast.'),
                                      HomePageWidgets.tipsContainer(
                                          animation: tipsAnimations[3],
                                          index: 4,
                                          emoji: '🩺',
                                          title: 'Consult your doctor',
                                          content:
                                              'This app is not a substitute for professional advice. Always consult with your doctor before fasting to determine if, and which fasting plan is right for you.'),
                                    ],
                                  ),
                                ),
                              );
                            })
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        BlocBuilder<FastingBloc, FastingState>(
          builder: (context, state) {
            return guageStatus == GuageStatus.finished
                ? const SuccessCracker(isPlayed: true)
                : Container();
          },
        ),
      ],
    );
  }

  Widget selectedTimeRatioDisplay({
    required int eat,
    required int fast,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 3.r,
                backgroundColor: ColorConstantsDark.buttonBackgroundColor,
              ),
              kWidth(5.w),
              kText(
                '$fast hours fasting',
                fontSize: 11,
                color: ColorConstantsDark.iconsColor,
              ),
            ],
          ),
          kHeight(5.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 3.r,
                backgroundColor: ColorConstantsDark.iconsColor,
              ),
              kWidth(5.w),
              kText(
                '$eat hours eating',
                fontSize: 11,
                color: ColorConstantsDark.iconsColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
