import 'package:fasting_app/core/entities/fast_entity.dart';
import 'package:fasting_app/core/entities/time_ration_entity.dart';
import 'package:fasting_app/core/enums/fast_status.dart';
import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:fasting_app/features/fasting/presentation/bloc/fasting_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:isar/isar.dart';

class SaveFastPage extends StatefulWidget {
  final Id isarId;
  final DateTime startTime;
  final int durationInMilliseconds;
  final FastingTimeRatioEntity fastingTimeRatio;

  const SaveFastPage(
      {super.key,
      required this.isarId,
      required this.startTime,
      required this.durationInMilliseconds,
      required this.fastingTimeRatio});

  static route({
    required Id isarId,
    required DateTime startTime,
    required int durationInMilliseconds,
    required FastingTimeRatioEntity fastingTimeRatio,
  }) =>
      MaterialPageRoute(
          builder: (context) => SaveFastPage(
                isarId: isarId,
                durationInMilliseconds: durationInMilliseconds,
                fastingTimeRatio: fastingTimeRatio,
                startTime: startTime,
              ));

  @override
  State<SaveFastPage> createState() => _SaveFastPageState();
}

class _SaveFastPageState extends State<SaveFastPage> {
  final noteTextController = TextEditingController();

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
            Container(
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
            GestureDetector(
              onTap: () {
                context
                    .read<FastingBloc>()
                    .add(FastingEventUpdateFast(FastEntity(
                      durationInMilliseconds: widget.durationInMilliseconds,
                      endTime: DateTime.now(),
                      completedDurationInMilliseconds: widget.startTime
                          .difference(DateTime.now())
                          .inMilliseconds
                          .abs(),
                      fastingTimeRatio: widget.fastingTimeRatio,
                      isarId: widget.isarId,
                      note: noteTextController.text,
                      rating: 5,
                      savedOn: DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day),
                      startTime: widget.startTime,
                      status: FastStatus.finished,
                    )));
                Navigator.of(context).pop();
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
                '0 minutes',
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
                          'Today 4:53 PM',
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
                          'Today 4:53 PM',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          FontAwesomeIcons.faceTired,
                          size: 30.r,
                        ),
                        Icon(
                          FontAwesomeIcons.faceFrown,
                          size: 30.r,
                        ),
                        Icon(
                          FontAwesomeIcons.faceMeh,
                          size: 30.r,
                        ),
                        Icon(
                          FontAwesomeIcons.faceSmile,
                          size: 30.r,
                        ),
                        Icon(
                          FontAwesomeIcons.faceLaughBeam,
                          size: 30.r,
                        ),
                      ],
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
}
