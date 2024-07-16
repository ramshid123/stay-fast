import 'dart:developer';

import 'package:fasting_app/core/animations/opacity_translate_y.dart';
import 'package:fasting_app/core/animations/translate_x.dart';
import 'package:fasting_app/core/entities/fast_entity.dart';
import 'package:fasting_app/core/entities/time_ration_entity.dart';
import 'package:fasting_app/core/extensions/list_padding.dart';
import 'package:fasting_app/core/shared_preferences_strings/shared_pref_strings.dart';
import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/utils/vibrate.dart';
import 'package:fasting_app/core/widgets/bottom_nav_bar.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:fasting_app/features/fasting/presentation/bloc/fasting_bloc.dart';
import 'package:fasting_app/features/fasting/presentation/pages/save_fast_page.dart';
import 'package:fasting_app/features/fasting/presentation/widgets/journal_page_widgets.dart';
import 'package:fasting_app/init_dependencies.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  // static route() =>
  //     MaterialPageRoute(builder: (context) => const JournalPage());

  static route() => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const JournalPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween<Offset>(
                begin: const Offset(0, 1), // Start position (right to left)
                end: Offset.zero, // End position (current position)
              ).chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      );

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  Soundpool? soundpool;
  int? soundId;

  bool isSoundAllowed = true;

  Future loadSoundModule() async {
    soundpool = Soundpool.fromOptions(
        options: const SoundpoolOptions(
            maxStreams: 2, streamType: StreamType.music));
    soundId = await rootBundle
        .load("assets/sounds/press.mp3")
        .then((ByteData soundData) {
      return soundpool!.load(soundData);
    });
  }

  void checkForSoundPermission() {
    final sf = serviceLocator<SharedPreferences>();
    isSoundAllowed = sf.getBool(SharedPrefStrings.isSoundAllowed) ?? true;
    if (isSoundAllowed) {
      loadSoundModule();
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    checkForSoundPermission();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (soundpool != null) {
      soundpool!.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // extendBody: true,
      appBar: PreferredSize(
        preferredSize: Size(size.width, size.height / 2.8),
        child: SafeArea(
          child: Container(
            color: ColorConstantsDark.backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                kHeight(10.h),
                animatedOpacityTranslation(
                  animation: _animation,
                  isTranslated: false,
                  child: kText(
                    'Journal',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                kHeight(20.h),
                Expanded(
                  child: animatedTranslateX(
                    animation: _animation,
                    width: size.width,
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

                            return JournalScrollItem(
                              context: context,
                              soundpool: soundpool,
                              soundId: soundId,
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
                ),
                kHeight(20.h),
                BlocBuilder<FastingBloc, FastingState>(
                  buildWhen: ((prev, current) {
                    if (current is FastingStateSelectedJournalDate) {
                      return true;
                    }
                    return false;
                  }),
                  builder: (context, state) {
                    return animatedOpacityTranslation(
                      animation: _animation,
                      child: kText(
                        state is! FastingStateSelectedJournalDate ||
                                state.fastEntities.isEmpty
                            ? 'No Records'
                            : DateFormat("MMM d, yyyy")
                                .format(state.fastEntities.first.savedOn!),
                        // 'Droid Sans Mono', 'monospace', monospace
                        // 'Today, 4:52 PM',
                        fontSize: 23,
                      ),
                    );
                  },
                ),
                kHeight(10.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: bottomNavBar(context: context, index: 1),
      body: SafeArea(
        child: animatedOpacityTranslation(
          animation: _animation,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(),
            child: SingleChildScrollView(
              clipBehavior: Clip.none,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  children: [
                    kHeight(10.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.w, vertical: 25.h),
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
                              // GestureDetector(
                              //   onTap: () async {
                              //   },
                              //   child: Row(
                              //     children: [
                              //       kText(
                              //         'Add fast',
                              //         fontSize: 13,
                              //         color: ColorConstantsDark.iconsColor,
                              //       ),
                              //       kWidth(10.w),
                              //       Icon(
                              //         FontAwesomeIcons.circlePlus,
                              //         size: 17.r,
                              //       ),
                              //     ],
                              //   ),
                              // ),
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
                                    for (var fast in fastEntities)
                                      _fastItem(fast),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    kHeight(20.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.w, vertical: 25.h),
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
                                backgroundColor: ColorConstantsDark.iconsColor
                                    .withOpacity(0.1),
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
                              color: ColorConstantsDark.iconsColor
                                  .withOpacity(0.1),
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
        vibrate();
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
                  kText(
                    '--',
                    fontSize: 13,
                    color: isSelected
                        ? ColorConstantsDark.container1Color
                        : ColorConstantsDark.iconsColor,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _ratingEmoji({
    required IconData icon,
  }) {
    return Icon(
      icon,
      size: 30.r,
      color: ColorConstantsDark.buttonBackgroundColor,
    );
  }

  Widget _fastItem(FastEntity fastEntity) {
    final ratings = [
      _ratingEmoji(
        icon: FontAwesomeIcons.faceTired,
      ),
      _ratingEmoji(
        icon: FontAwesomeIcons.faceFrown,
      ),
      _ratingEmoji(
        icon: FontAwesomeIcons.faceMeh,
      ),
      _ratingEmoji(
        icon: FontAwesomeIcons.faceSmile,
      ),
      _ratingEmoji(
        icon: FontAwesomeIcons.faceLaughBeam,
      ),
    ];
    return Builder(builder: (context) {
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
                '${fastEntity.fastingTimeRatio!.fast} : ${fastEntity.fastingTimeRatio!.eat} fast',
                // '11:13 fast',
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
              kWidth(10.w),
              GestureDetector(
                onTap: () async {
                  vibrate();
                  final date =
                      await Navigator.of(context).push(SaveFastPage.route(
                    isarId: fastEntity.isarId!,
                    startTime: fastEntity.startTime!,
                    durationInMilliseconds: fastEntity.durationInMilliseconds!,
                    fastingTimeRatio: fastEntity.fastingTimeRatio!,
                    endTime: fastEntity.endTime,
                    note: fastEntity.note,
                    rating: fastEntity.rating,
                    savedOn: fastEntity.savedOn,
                  ));
                  await Future.delayed(const Duration(milliseconds: 100));
                  context
                      .read<FastingBloc>()
                      .add(FastingEventSelectJournalDate(date as DateTime));
                },
                child: SizedBox(
                  child: Icon(
                    FontAwesomeIcons.pen,
                    size: 13.r,
                  ),
                ),
              ),
              const Spacer(),
              kText(
                  // '0h 0m',
                  '${Duration(milliseconds: fastEntity.completedDurationInMilliseconds!).inHours}h ${Duration(milliseconds: fastEntity.completedDurationInMilliseconds!).inMinutes.remainder(60)}m'),
            ],
          ),
          kHeight(10.h),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  kHeight(8.h),
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
                ],
              ),
              const Spacer(),
              if (fastEntity.rating == 1)
                ratings[0]
              else if (fastEntity.rating == 2)
                ratings[1]
              else if (fastEntity.rating == 3)
                ratings[2]
              else if (fastEntity.rating == 4)
                ratings[3]
              else if (fastEntity.rating == 5)
                ratings[4]
            ],
          ),
          fastEntity.note != null && fastEntity.note.toString().isNotEmpty
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 15.h),
                    child: kText(
                      '"${fastEntity.note ?? ''}"',
                      fontFamily: 'Nanum Gothic Coding',
                      fontSize: 17,
                      textAlign: TextAlign.left,
                      maxLines: 50,
                    ),
                  ),
                )
              : Container(),
        ],
      );
    });
  }
}
