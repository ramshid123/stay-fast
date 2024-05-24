import 'dart:developer';

import 'package:fasting_app/core/entities/time_ration_entity.dart';
import 'package:fasting_app/core/enums/fast_status.dart';
import 'package:fasting_app/core/enums/guage_status.dart';
import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/widgets/bottom_nav_bar.dart';
import 'package:fasting_app/core/widgets/guage.dart';
import 'package:fasting_app/core/widgets/rotating_circle.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:fasting_app/features/fasting/presentation/bloc/fasting_bloc.dart';
import 'package:fasting_app/features/fasting/presentation/pages/period_selection_page.dart';
import 'package:fasting_app/features/fasting/presentation/pages/save_fast_page.dart';
import 'package:fasting_app/features/fasting/presentation/widgets/home_page_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  static route() => MaterialPageRoute(builder: (context) => const HomePage());
}

class _HomePageState extends State<HomePage> {
  final startTime = DateTime(2024, 5, 20, 8, 0, 37);
  final duration = const Duration(hours: 2);
  var fastingTimeRatio = FastingTimeRatioEntity(fast: 13, eat: 11);
  GuageStatus guageStatus = GuageStatus.inactive;

  @override
  void initState() {
    context.read<FastingBloc>().add(FastingEventCheckFast());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          context.read<FastingBloc>().add(FastingEventSaveFast(
                durationInMilliseconds:
                    const Duration(hours: 13).inMilliseconds,
                fastingTimeRatio: FastingTimeRatioEntity(fast: 13, eat: 11),
                startTime: DateTime.now().subtract(Duration(hours: 5)),
                status: FastStatus.ongoing,
              ));
        },
      ),
      appBar: AppBar(
        title: RichText(
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
      ),
      bottomNavigationBar: bottomNavBar(context),
      body: BlocListener<FastingBloc, FastingState>(
        listener: (context, state) {
          if (state is FastingStateFailure) {
            log(state.message);
          }

          if (state is FastingStateCurrentFast) {
            // log(state.fastEntity.toString());
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
              } else if (state.fastEntity!.status == FastStatus.ongoing) {
                guageStatus = GuageStatus.running;
              } else {
                guageStatus = GuageStatus.finished;
              }
            }
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 30.w),
              child: SingleChildScrollView(
                clipBehavior: Clip.none,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    kHeight(10.h),
                    Builder(builder: (context) {
                      if (guageStatus == GuageStatus.inactive) {
                        return Container();
                      }
                      return Row(
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
                      );
                    }),
                    kHeight(50.h),
                    BlocBuilder<FastingBloc, FastingState>(
                      buildWhen: (previous, current) {
                        if (current is FastingStateCurrentFast) {
                          return true;
                        }

                        return false;
                      },
                      builder: (context, state) {
                        if (state is! FastingStateCurrentFast) {
                          return Container();
                        }
                        print('guage build');
                        switch (guageStatus) {
                          case GuageStatus.running:
                            return KustomGuage(
                              backgroundColor:
                                  ColorConstantsDark.container2Color,
                              foregroundColor:
                                  ColorConstantsDark.buttonBackgroundColor,
                              guageIndicatorColor:
                                  ColorConstantsDark.container2Color,
                              strokeWidth: 40.w,
                              startTime: (state as FastingStateCurrentFast)
                                  .fastEntity!
                                  .startTime!,
                              duration: Duration(
                                  milliseconds: state
                                      .fastEntity!.durationInMilliseconds!),
                              fastingTimeRatio:
                                  state.fastEntity!.fastingTimeRatio!,
                            );

                          case GuageStatus.finished:
                            return Container(
                              child: kText('Completed'),
                            );

                          case GuageStatus.inactive:
                            return Container(
                              child: Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () async => await Navigator.push(
                                        context, PeriodSelectionPage.route()),
                                    child: kText(
                                        '${fastingTimeRatio.fast}:${fastingTimeRatio.eat}'),
                                  ),
                                  kText('Inactive'),
                                ],
                              ),
                            );
                        }
                      },
                    ),
                    kHeight(30.h),
                    guageStatus == GuageStatus.inactive
                        ? ElevatedButton(
                            // onPressed: () async => await Navigator.of(context)
                            //     .push(SaveFastPage.route()),
                            onPressed: () {
                              context.read<FastingBloc>().add(
                                  FastingEventSaveFast(
                                      startTime: DateTime.now(),
                                      durationInMilliseconds: Duration(
                                              hours: fastingTimeRatio.fast!)
                                          .inMilliseconds,
                                      fastingTimeRatio: fastingTimeRatio,
                                      status: FastStatus.ongoing));

                              context
                                  .read<FastingBloc>()
                                  .add(FastingEventCheckFast());
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(size.width, 50.h),
                              backgroundColor:
                                  ColorConstantsDark.buttonBackgroundColor,
                              foregroundColor:
                                  ColorConstantsDark.buttonForegroundColor,
                            ),
                            child: kText(
                              'Start Fast',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () async => await Navigator.of(context)
                                .push(SaveFastPage.route(
                              fastingTimeRatio:
                                  (state as FastingStateCurrentFast)
                                      .fastEntity!
                                      .fastingTimeRatio!,
                              durationInMilliseconds:
                                  state.fastEntity!.durationInMilliseconds!,
                              isarId: state.fastEntity!.isarId!,
                              startTime: state.fastEntity!.startTime!,
                            )),
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(size.width, 50.h),
                              backgroundColor:
                                  ColorConstantsDark.backgroundColor,
                              foregroundColor:
                                  ColorConstantsDark.buttonBackgroundColor,
                              side: BorderSide(
                                color: ColorConstantsDark.buttonBackgroundColor,
                                width: 3.r,
                              ),
                            ),
                            child: kText(
                              'End Fast',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                    kHeight(20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HomePageWidgets.timerSetButton(
                          title: 'Start',
                          value: 'Today 4:53 PM',
                          index: 0,
                        ),
                        HomePageWidgets.timerSetButton(
                          title: 'End',
                          value: 'Thu May 16, 3:53 AM',
                          index: 1,
                        ),
                      ],
                    ),
                    kHeight(50.h),
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
                        emoji: '💦',
                        title: 'Stay hydrated',
                        content:
                            'Drink plenty of water throughout your fasting period to stay hydrated and help manage hunger and fatigue.'),
                    HomePageWidgets.tipsContainer(
                        emoji: '🏃',
                        title: 'Stay busy',
                        content:
                            'Keep yourself occupied with work, hobbies or exercies to distract from hunger and make fasting hours pass more quickly.'),
                    HomePageWidgets.tipsContainer(
                        emoji: '🧘🏻‍♂️',
                        title: 'Listen to your body',
                        content:
                            'Pay attention to how your body responds to fasting and adjust your fasting schedule as needed. If you feel unwell, consider breaking your fast.'),
                    HomePageWidgets.tipsContainer(
                        emoji: '🩺',
                        title: 'Consult your doctor',
                        content:
                            'This app is not a substitute for professional advice. Always consult with your doctor before fasting to determine if, and which fasting plan is right for you.'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
