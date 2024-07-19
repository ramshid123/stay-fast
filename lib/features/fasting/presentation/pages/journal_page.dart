
import 'package:fasting_app/core/animations/opacity_translate_y.dart';
import 'package:fasting_app/core/animations/translate_x.dart';
import 'package:fasting_app/core/entities/fast_entity.dart';
import 'package:fasting_app/core/shared_preferences_strings/shared_pref_strings.dart';
import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/utils/vibrate.dart';
import 'package:fasting_app/core/widgets/bottom_nav_bar.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:fasting_app/features/fasting/presentation/bloc/fasting_bloc.dart';
import 'package:fasting_app/features/fasting/presentation/pages/save_fast_page.dart';
import 'package:fasting_app/features/fasting/presentation/widgets/journal_page_widgets.dart';
import 'package:fasting_app/init_dependencies.dart';
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

  
  

  static route() => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const JournalPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween<Offset>(
                begin: const Offset(0, 1), 
                end: Offset.zero, 
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
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  late AnimationController _entryAnimationController;
  late AnimationController _exitAnimationController;

  late Animation _entryAnimation;
  late Animation _exitAnimation;

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
    checkForSoundPermission();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _animationController.forward();

    _entryAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    _entryAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _entryAnimationController, curve: Curves.easeInOut));

    _exitAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    _exitAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _exitAnimationController, curve: Curves.easeInOut));

    _entryAnimationController.reset();
    _exitAnimationController.reset();
    _entryAnimationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    if (soundpool != null) {
      soundpool!.dispose();
    }
    _animationController.dispose();
    _entryAnimationController.dispose();
    _exitAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
                              entryAnimationController:
                                  _entryAnimationController,
                              exitAnimationController: _exitAnimationController,
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
                      child: AnimatedBuilder(
                          animation: _entryAnimation,
                          builder: (context, _) {
                            return AnimatedBuilder(
                                animation: _exitAnimation,
                                builder: (context, _) {
                                  return Opacity(
                                    opacity: _entryAnimation.value,
                                    child: Opacity(
                                      opacity: _exitAnimation.value,
                                      child: kText(
                                        state is! FastingStateSelectedJournalDate ||
                                                state.fastEntities.isEmpty
                                            ? 'No Records'
                                            : DateFormat("MMM d, yyyy").format(
                                                state.fastEntities.first
                                                    .savedOn!),
                                        
                                        
                                        fontSize: 23,
                                      ),
                                    ),
                                  );
                                });
                          }),
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
                    BlocBuilder<FastingBloc, FastingState>(
                      buildWhen: (previous, current) {
                        if (current is FastingStateSelectedJournalDate) {
                          return true;
                        }
                        return false;
                      },
                      builder: (context, state) {
                        List<FastEntity> fastEntities = [];
                        int totalFastingTime = 0;
                        if (state is FastingStateSelectedJournalDate) {
                          fastEntities = state.fastEntities;
                          for (var fast in fastEntities) {
                            totalFastingTime +=
                                fast.completedDurationInMilliseconds!;
                          }
                        }

                        return AnimatedBuilder(
                            animation: _entryAnimation,
                            builder: (context, _) {
                              return Transform.translate(
                                offset: Offset(
                                    size.width * (_entryAnimation.value), 0.0),
                                child: AnimatedBuilder(
                                    animation: _exitAnimation,
                                    builder: (context, _) {
                                      return Transform.translate(
                                        offset: Offset(
                                            -size.width * _exitAnimation.value,
                                            0.0),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25.w, vertical: 25.h),
                                          decoration: BoxDecoration(
                                            color: ColorConstantsDark
                                                .container1Color,
                                            borderRadius:
                                                BorderRadius.circular(15.r),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                    
                                                    '[${Duration(milliseconds: totalFastingTime).inHours}h ${Duration(milliseconds: totalFastingTime).inMinutes.remainder(60)}m]',
                                                    fontSize: 13,
                                                    color: ColorConstantsDark
                                                        .iconsColor,
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  if (fastEntities.isEmpty) ...[
                                                    kHeight(20.h),
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: kText(
                                                        'No fasts for the day',
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                    kHeight(20.h)
                                                  ] else
                                                    for (var fast
                                                        in fastEntities)
                                                      _fastItem(fast),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              );
                            });
                      },
                    ),
                    kHeight(20.h),
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
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
                  if (context.mounted) {
                    context
                        .read<FastingBloc>()
                        .add(FastingEventSelectJournalDate(date as DateTime));
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: const BoxDecoration(
                    color: ColorConstantsDark.container2Color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    FontAwesomeIcons.pen,
                    size: 13.r,
                  ),
                ),
              ),
              const Spacer(),
              kText(
                  
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
