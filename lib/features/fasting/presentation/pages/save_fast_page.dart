import 'package:fasting_app/core/entities/fast_entity.dart';
import 'package:fasting_app/core/entities/time_ration_entity.dart';
import 'package:fasting_app/core/enums/fast_status.dart';
import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/utils/format_datetime.dart';
import 'package:fasting_app/core/utils/vibrate.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:fasting_app/features/fasting/presentation/bloc/fasting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:isar/isar.dart';

class SaveFastPage extends StatefulWidget {
  final Id isarId;
  final DateTime startTime;
  final int durationInMilliseconds;
  final FastingTimeRatioEntity fastingTimeRatio;
  final int? rating;
  final String? note;
  final DateTime? savedOn;
  final DateTime? endTime;

  const SaveFastPage({
    super.key,
    required this.isarId,
    required this.startTime,
    required this.durationInMilliseconds,
    required this.fastingTimeRatio,
    this.rating,
    this.note,
    this.savedOn,
    this.endTime,
  });

  static route({
    required Id isarId,
    required DateTime startTime,
    required int durationInMilliseconds,
    required FastingTimeRatioEntity fastingTimeRatio,
    int? rating,
    String? note,
    DateTime? savedOn,
    DateTime? endTime,
  }) =>
      MaterialPageRoute(
          builder: (context) => SaveFastPage(
                isarId: isarId,
                durationInMilliseconds: durationInMilliseconds,
                fastingTimeRatio: fastingTimeRatio,
                startTime: startTime,
                rating: rating,
                note: note,
                savedOn: savedOn,
                endTime: endTime,
              ));

  @override
  State<SaveFastPage> createState() => _SaveFastPageState();
}

class _SaveFastPageState extends State<SaveFastPage> {
  final noteTextController = TextEditingController();
  late DateTime startTime;
  late DateTime endTime;
  ValueNotifier<int?> selectedRating = ValueNotifier(null);

  @override
  void initState() {
    noteTextController.text = widget.note ?? '';
    startTime = widget.startTime;
    endTime = widget.endTime ?? DateTime.now();
    selectedRating.value = widget.rating;

    super.initState();
  }

  @override
  void dispose() {
    noteTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: kText(
          '11:13 fast',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      bottomSheet: Container(
        height: 70.h,
        width: double.infinity,
        color: ColorConstantsDark.backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                vibrate();
                context
                    .read<FastingBloc>()
                    .add(FastingEventDeleteFast(widget.isarId));
                Navigator.of(context).pop(widget.savedOn ??
                    DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 15.h),
                width: 150.w,
                decoration: BoxDecoration(
                  color: ColorConstantsDark.backgroundColor,
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Center(
                  child: kText(
                    'Delete',
                    fontSize: 13,
                    color: ColorConstantsDark.buttonBackgroundColor,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                vibrate();
                context
                    .read<FastingBloc>()
                    .add(FastingEventUpdateFast(FastEntity(
                      durationInMilliseconds: widget.durationInMilliseconds,
                      endTime: endTime,
                      completedDurationInMilliseconds: widget.startTime
                          .difference(endTime)
                          .inMilliseconds
                          .abs(),
                      fastingTimeRatio: widget.fastingTimeRatio,
                      isarId: widget.isarId,
                      note: noteTextController.text,
                      rating: selectedRating.value,
                      savedOn: widget.savedOn ??
                          DateTime(DateTime.now().year, DateTime.now().month,
                              DateTime.now().day),
                      startTime: widget.startTime,
                      status: FastStatus.finished,
                    )));
                context.read<FastingBloc>().add(FastingEventSelectJournalDate(
                    widget.savedOn ??
                        DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day)));
                Navigator.of(context).pop(widget.savedOn ??
                    DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 15.h),
                width: 150.w,
                decoration: BoxDecoration(
                  color: ColorConstantsDark.buttonBackgroundColor,
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Center(
                  child: kText(
                    'Save',
                    fontSize: 13,
                    color: ColorConstantsDark.backgroundColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Column(
            children: [
              kHeight(40.h),
              kText(
                'Total fasting time',
                color: ColorConstantsDark.textColor,
              ),
              kHeight(2.h),
              kText(
                // '0 minutes',
                '${startTime.difference(endTime).inMinutes.remainder(60).abs()} minutes ${startTime.difference(endTime).inHours.abs() == 0 ? '' : '${startTime.difference(endTime).inHours.abs()} hours'}',
                color: ColorConstantsDark.textColor,
              ),
              kHeight(40.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
                decoration: BoxDecoration(
                  color: ColorConstantsDark.container1Color,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    kText(
                      'Start/Finish',
                      fontSize: 15,
                    ),
                    kHeight(15.h),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.play,
                          size: 18.r,
                        ),
                        kWidth(10.w),
                        kText(
                          formatDateTime(startTime),
                          // 'Today 4:53 PM',
                          fontSize: 13,
                        ),
                        const Spacer(),
                        Icon(
                          FontAwesomeIcons.pen,
                          size: 13.r,
                        ),
                      ],
                    ),
                    kHeight(10.h),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.flagCheckered,
                          size: 18.r,
                        ),
                        kWidth(10.w),
                        kText(
                          formatDateTime(endTime),
                          // 'Today 4:53 PM',
                          fontSize: 13,
                        ),
                        const Spacer(),
                        Icon(
                          FontAwesomeIcons.pen,
                          size: 13.r,
                        ),
                      ],
                    )
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    kText('Rating'),
                    kHeight(20.h),
                    ValueListenableBuilder(
                        valueListenable: selectedRating,
                        builder: (context, value, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _ratingEmoji(
                                icon: FontAwesomeIcons.faceTired,
                                ratingIndex: 1,
                                selectedRating: selectedRating,
                                color: const Color(0xffFF0000),
                              ),
                              _ratingEmoji(
                                icon: FontAwesomeIcons.faceFrown,
                                ratingIndex: 2,
                                selectedRating: selectedRating,
                                color: const Color(0xffFFA500),
                              ),
                              _ratingEmoji(
                                icon: FontAwesomeIcons.faceMeh,
                                ratingIndex: 3,
                                selectedRating: selectedRating,
                                color: const Color(0xffFFFF00),
                              ),
                              _ratingEmoji(
                                icon: FontAwesomeIcons.faceSmile,
                                ratingIndex: 4,
                                selectedRating: selectedRating,
                                color: const Color(0xff90EE90),
                              ),
                              _ratingEmoji(
                                icon: FontAwesomeIcons.faceLaughBeam,
                                ratingIndex: 5,
                                selectedRating: selectedRating,
                                color: const Color.fromARGB(255, 0, 255, 0),
                              ),
                            ],
                          );
                        }),
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
                child: TextFormField(
                  controller: noteTextController,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorConstantsDark.textColor,
                  ),
                  maxLines: null,
                  minLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Add Notes',
                    labelText: 'Notes',
                    alignLabelWithHint: true,
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),
              kHeight(70.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ratingEmoji({
    required IconData icon,
    required int ratingIndex,
    required ValueNotifier<int?> selectedRating,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        vibrate();
        selectedRating.value = ratingIndex;
      },
      child: Icon(
        icon,
        size: 30.r,
        color: ratingIndex == selectedRating.value ? color : null,
      ),
    );
  }
}
