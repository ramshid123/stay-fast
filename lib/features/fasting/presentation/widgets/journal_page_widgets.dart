import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/utils/vibrate.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:fasting_app/features/fasting/presentation/bloc/fasting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:soundpool/soundpool.dart';

class JournalScrollItem extends StatefulWidget {
  final DateTime dateTime;
  final BuildContext context;
  final Soundpool? soundpool;
  final int? soundId;
  const JournalScrollItem({
    super.key,
    required this.dateTime,
    required this.soundId,
    required this.soundpool,
    required this.context,
  });

  @override
  State<JournalScrollItem> createState() => JournalScrollItemState();
}

class JournalScrollItemState extends State<JournalScrollItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    _animationController.value = 1;
    _animationController.reverse();
    if (widget.soundId != null && widget.soundpool != null) {
      widget.soundpool!.play(widget.soundId!);
    }
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            children: [
              Transform.translate(
                offset: Offset(-(size.height / 5.6) * _animation.value, 0),
                child: GestureDetector(
                  onTap: () {
                    vibrate();
                    context
                        .read<FastingBloc>()
                        .add(FastingEventSelectJournalDate(widget.dateTime));
                  },
                  child: BlocBuilder<FastingBloc, FastingState>(
                    builder: (context, state) {
                      bool isSelected = false;

                      if (state is FastingStateSelectedJournalDate) {
                        if (state.selectedDate == widget.dateTime) {
                          isSelected = true;
                        }
                      }

                      // log('hours: $hours\nlength: ${(state as FastingStateJournalItem).fastEntities.length}');

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.h),
                        margin: EdgeInsets.symmetric(horizontal: 5.w),
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
                              kText(DateFormat('E').format(widget.dateTime),
                                  fontSize: 13,
                                  color: isSelected
                                      ? ColorConstantsDark.container1Color
                                      : ColorConstantsDark.iconsColor),
                              kText(DateFormat('d').format(widget.dateTime),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? ColorConstantsDark.container1Color
                                      : ColorConstantsDark.iconsColor),
                              kText(DateFormat('MMM').format(widget.dateTime),
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
                ),
              ),
            ],
          );
        });
  }
}
