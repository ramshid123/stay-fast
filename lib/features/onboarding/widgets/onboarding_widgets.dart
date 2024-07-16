import 'package:fasting_app/core/theme/palette.dart';
import 'package:fasting_app/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingListViewItem extends StatefulWidget {
  final ScrollDirection scrollDirection;
  const OnBoardingListViewItem({super.key, required this.scrollDirection});

  @override
  State<OnBoardingListViewItem> createState() => _OnBoardingListViewItemState();
}

class _OnBoardingListViewItemState extends State<OnBoardingListViewItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    // TODO: implement initState
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    // _animationController.value = 1;
    _animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    // _animationController.reverse();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
                0,
                (widget.scrollDirection == ScrollDirection.forward ? -1 : 1) *
                    _animation.value *
                    200.h),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              decoration: BoxDecoration(
                color: ColorConstantsDark.container2Color,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  kText(
                    'Title',
                    fontSize: 20,
                  ),
                  kHeight(5.h),
                  kText(
                    'This is a test description ' * 5,
                    maxLines: 10,
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class CustomScrollPhysics extends ScrollPhysics {
  final double velocityFactor;

  CustomScrollPhysics({ScrollPhysics? parent, required this.velocityFactor})
      : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(
        parent: buildParent(ancestor), velocityFactor: velocityFactor);
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // Modify the offset based on the velocity factor
    return offset * velocityFactor;
  }
}
