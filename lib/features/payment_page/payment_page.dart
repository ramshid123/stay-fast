import 'dart:developer';

import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/utils/vibrate.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:fasting_app/features/payment_page/payment_failure_page.dart';
import 'package:fasting_app/features/payment_page/payment_success_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:upi_india/upi_india.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  static route() =>
      MaterialPageRoute(builder: (context) => const PaymentPage());

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final UpiIndia _upiIndia = UpiIndia();

  List<UpiApp> apps = [];

  final FocusNode amountFocusNode = FocusNode();
  final FocusNode noteFocusNode = FocusNode();
  final TextEditingController amountTextController = TextEditingController();
  final TextEditingController noteTextController = TextEditingController();

  final formkey = GlobalKey<FormState>();

  ValueNotifier<UpiApp> selectedUpiApp = ValueNotifier(UpiApp.googlePay);
  ValueNotifier<bool> isIntialised = ValueNotifier(false);

  @override
  void initState() {
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) async {
      apps = value;
      selectedUpiApp.value = apps.first;
      await Future.delayed(const Duration(seconds: 2));
      isIntialised.value = true;
    }).catchError((e) {
      apps = [];
      isIntialised.value = true;
    });

    amountFocusNode.addListener(() {
      if (amountFocusNode.hasFocus == false) {
        amountTextController.text =
            '₹ ${double.parse(amountTextController.text)}';
      }
    });

    super.initState();
  }

  border({Color color = ColorConstantsDark.iconsColor}) => UnderlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 2.r,
          style: BorderStyle.solid,
        ),
      );

  Future initiateTransaction() async {
    if (formkey.currentState!.validate() == false) {
      return;
    }
    vibrate();

    isIntialised.value = false;

    try {
      final response = await _upiIndia.startTransaction(
        app: selectedUpiApp.value,
        receiverUpiId: "ramshid.abc@okaxis",
        receiverName: 'Ramsheed Dilhan',
        transactionRefId: DateTime.now().millisecondsSinceEpoch.toString(),
        transactionNote: noteTextController.text,
        amount: double.parse(amountTextController.text.replaceAll('₹', '')),
      );

      if (response.status == UpiPaymentStatus.FAILURE) {
        await Navigator.push(context, PaymentFailurePage.route());
      } else {
        await Navigator.push(context, PaymentSuccessPage.route());
      }
    } catch (e) {
      await Navigator.push(context, PaymentFailurePage.route());
    }

    isIntialised.value = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    amountTextController.dispose();
    noteTextController.dispose();
    amountFocusNode.dispose();
    noteFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ValueListenableBuilder(
        valueListenable: isIntialised,
        builder: (context, value, _) {
          return Material(
            color: ColorConstantsDark.backgroundColor,
            child: !value
                ? Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.all(20.r),
                      height: 100.r,
                      width: 100.r,
                      decoration: BoxDecoration(
                        color: ColorConstantsDark.container2Color,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: ColorConstantsDark.buttonBackgroundColor,
                        ),
                      ),
                    ),
                  )
                : (apps.isEmpty
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 40.r,
                          ),
                          SizedBox(
                            height: 10.h,
                            width: double.infinity,
                          ),
                          kText(
                            'Oops!',
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                          kHeight(5.h),
                          kText(
                            'No UPI Applications found',
                            fontSize: 13,
                            color:
                                ColorConstantsDark.textColor.withOpacity(0.8),
                          ),
                          kHeight(50.h),
                          GestureDetector(
                            onTap: () {
                              vibrate();
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: ColorConstantsDark.buttonBackgroundColor,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: kText(
                                'Go Back',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      )
                    : GestureDetector(
                        onTap: () {
                          vibrate();
                          amountFocusNode.unfocus();
                          noteFocusNode.unfocus();
                        },
                        child: Scaffold(
                          appBar: AppBar(
                            title: kText(
                              'Payment',
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            leading: InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              child: Icon(
                                Icons.navigate_before,
                                size: 30.r,
                              ),
                            ),
                          ),
                          bottomNavigationBar: GestureDetector(
                            onTap: () => initiateTransaction(),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 25.w, vertical: 20.h),
                              height: 50.h,
                              decoration: BoxDecoration(
                                color: ColorConstantsDark.buttonBackgroundColor,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Center(
                                child: kText(
                                  'Continue',
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          body: SingleChildScrollView(
                            child: Column(
                              children: [
                                kHeight(20.h),
                                CircleAvatar(
                                  radius: 40.r,
                                  backgroundColor:
                                      ColorConstantsDark.buttonBackgroundColor,
                                  child: kText(
                                    'R',
                                    fontSize: 35,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                kHeight(10.h),
                                kText(
                                  'Paying to Ramsheed Dilhan',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                kHeight(5.h),
                                kText(
                                  'UPI ID: ramshid.abc@okaxis',
                                  fontSize: 13,
                                ),
                                // const Spacer(),
                                kHeight(30.h),
                                Form(
                                  key: formkey,
                                  child: SizedBox(
                                    width: size.width * 0.5,
                                    child: TextFormField(
                                      controller: amountTextController,
                                      focusNode: amountFocusNode,
                                      cursorColor: ColorConstantsDark
                                          .buttonBackgroundColor,
                                      showCursor: false,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d*\.?\d*')),
                                      ],
                                      style: GoogleFonts.getFont(
                                        'Poppins',
                                        fontSize: 40.sp,
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: '0.00 ₹',
                                        hintStyle: GoogleFonts.getFont(
                                          'Poppins',
                                          fontSize: 40.sp,
                                          color: Colors.grey.withOpacity(0.5),
                                        ),
                                        border: border(
                                          color: ColorConstantsDark
                                              .buttonBackgroundColor
                                              .withOpacity(0.5),
                                        ),
                                        focusedErrorBorder:
                                            border(color: Colors.red),
                                        disabledBorder: border(),
                                        errorBorder: border(color: Colors.red),
                                        enabledBorder: border(
                                          color: ColorConstantsDark
                                              .buttonBackgroundColor
                                              .withOpacity(0.5),
                                        ),
                                        focusedBorder: border(
                                            color: ColorConstantsDark
                                                .buttonBackgroundColor),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return '';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                kHeight(40.h),
                                SizedBox(
                                  width: size.width * 0.4,
                                  child: TextFormField(
                                    controller: noteTextController,
                                    focusNode: noteFocusNode,
                                    cursorColor: ColorConstantsDark
                                        .buttonBackgroundColor,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText: 'Note',
                                    ),
                                  ),
                                ),
                                kHeight(30.h),

                                // const Spacer(),
                                for (var app in apps) payAppButton(app: app),
                                kHeight(50.h),
                              ],
                            ),
                          ),
                        ),
                      )),
          );
        });
  }

  Widget payAppButton({required UpiApp app}) {
    return ValueListenableBuilder(
        valueListenable: selectedUpiApp,
        builder: (context, value, _) {
          return GestureDetector(
            // onTap: () async => await initiateTransaction(app),
            onTap: () => selectedUpiApp.value = app,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 25.w),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: ColorConstantsDark.iconsColor.withOpacity(0.3),
                  width: 2.r,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.memory(
                    app.icon,
                    height: 45.r,
                    width: 45.r,
                  ),
                  kWidth(20.w),
                  kText(
                    app.name,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  const Spacer(),
                  Radio(
                    value: selectedUpiApp.value,
                    groupValue: app,
                    fillColor: const WidgetStatePropertyAll(
                        ColorConstantsDark.buttonBackgroundColor),
                    onChanged: (value) => selectedUpiApp.value = app,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
