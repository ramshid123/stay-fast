
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/utils/vibrate.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPageWidgets {
  static Widget aboutSheet() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: ColorConstantsDark.backgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          kHeight(20.h),
          // Image.network(
          //   'https://raw.githubusercontent.com/ramshid123/ramshid123.github.io/main/assets/assets/icon/ic_light.png',
          //   height: 100.r,
          //   width: 100.r,
          // ),
          CachedNetworkImage(
            imageUrl:
                'https://raw.githubusercontent.com/ramshid123/ramshid123.github.io/main/assets/assets/icon/ic_light.png',
            height: 100.r,
            width: 100.r,
            progressIndicatorBuilder:
                (context, url, DownloadProgress progress) {
              return SizedBox(
                height: 25.r,
                width: 25.r,
                child: CircularProgressIndicator(
                  color: ColorConstantsDark.buttonBackgroundColor,
                  value: progress.downloaded.toDouble(),
                ),
              );
            },
          ),
          kHeight(20.h),
          kText(
            'Ramsheed Dilhan',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          kHeight(5.h),
          kText(
            'Developer',
            fontSize: 13,
            color: ColorConstantsDark.textColor.withOpacity(0.8),
          ),
          kHeight(30.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            height: 2.h,
            width: double.infinity,
            color: ColorConstantsDark.container2Color,
          ),
          kHeight(30.h),
          _aboutSectionSocialMedia(
            title: 'LinkedIn',
            icon: FontAwesomeIcons.linkedinIn,
            url: 'https://www.linkedin.com/in/ramsheed-dilhan-015035272',
          ),
          _aboutSectionSocialMedia(
            title: 'Instagram',
            icon: FontAwesomeIcons.instagram,
            url: 'https://instagram.com/r.a.m.s.h.i.d',
          ),
          _aboutSectionSocialMedia(
            title: 'Gmail',
            icon: FontAwesomeIcons.google,
            url: 'mailto:ramshid.abc@gmail.com',
          ),
        ],
      ),
    );
  }

  static Widget _aboutSectionSocialMedia({
    required String title,
    required IconData icon,
    required String url,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: InkWell(
        onTap: () async {
          await launchUrl(Uri.parse(url));
        },
        child: Row(
          children: [
            Container(
              height: 45.r,
              width: 45.r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: ColorConstantsDark.container2Color,
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  size: 25.r,
                ),
              ),
            ),
            kWidth(20.w),
            kText(
              title,
              fontSize: 15,
              fontWeight: FontWeight.w100,
            ),
            const Spacer(),
            FaIcon(
              FontAwesomeIcons.arrowUpRightFromSquare,
              size: 15.r,
              color: ColorConstantsDark.buttonBackgroundColor,
            ),
            kWidth(20.w),
          ],
        ),
      ),
    );
  }

  static Widget feedbackBottomSheet({required BuildContext context}) {
    return Container(
      padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: ColorConstantsDark.backgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          kHeight(50.h),
          kText(
            'What needs fixing?',
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          kHeight(10.h),
          kText(
            'Share Your Feedback and Help Us Improve.',
            fontSize: 13,
          ),
          kHeight(30.h),
          TextFormField(
            maxLines: 5,
            cursorColor: ColorConstantsDark.buttonBackgroundColor,
            style: GoogleFonts.getFont(
              'Poppins',
              fontSize: 13.sp,
            ),
            decoration: InputDecoration(
              hintText: 'How was your ride? Write your thoughts.',
              hintStyle: GoogleFonts.getFont(
                'Poppins',
                fontSize: 13.sp,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(
                  color: ColorConstantsDark.iconsColor,
                ),
              ),
            ),
          ),
          kHeight(30.h),
          GestureDetector(
            onTap: () {
              vibrate();
              Navigator.of(context).pop();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: ColorConstantsDark.buttonBackgroundColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: kText(
                  'Submit',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          kHeight(50.h),
        ],
      ),
    );
  }
}

// kText('What Needs Fixing?'),// how was your ride
// kText('Share Your Feedback and Help Us Improve')
