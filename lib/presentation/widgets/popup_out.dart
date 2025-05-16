import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';
import 'package:foreglyc/presentation/widgets/button.dart';

void showPopupOutBottomSheet(
  BuildContext context, {
  required String title,
  required String content,
  required VoidCallback onClicked,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: ColorStyles.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (BuildContext context) {
      return PopupOutBottomSheet(
        title: title,
        content: content,
        onClicked: onClicked,
      );
    },
  );
}

class PopupOutBottomSheet extends StatefulWidget {
  final String title;
  final String content;
  final VoidCallback onClicked;

  const PopupOutBottomSheet({
    super.key,
    required this.title,
    required this.content,
    required this.onClicked,
  });

  @override
  State<PopupOutBottomSheet> createState() => _PopupOutBottomSheetState();
}

class _PopupOutBottomSheetState extends State<PopupOutBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 32.h, left: 24.w, right: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.title,
                style: TextStyles.heading2(color: ColorStyles.error500),
              ),
              SizedBox(height: 16.h),
              Text(
                widget.content,
                textAlign: TextAlign.center,
                style: TextStyles.body1(
                  weight: FontWeightOption.regular,
                  color: ColorStyles.neutral600,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(150.w, 48.h),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      side: BorderSide(
                        color: ColorStyles.error500,
                        width: 1.5.w,
                      ),
                    ),
                    child: Text(
                      'No',
                      style: TextStyles.body1(
                        color: ColorStyles.error500,
                        weight: FontWeightOption.semiBold,
                      ),
                    ),
                  ),
                  Buttons(
                    text: 'Yes',
                    width: 150,
                    height: 48,
                    bColor: ColorStyles.error500,
                    tColor: Colors.white,
                    onClicked: () {
                      widget.onClicked();
                    },
                  ),
                ],
              ),
              SizedBox(height: 48.h),
            ],
          ),
        ),
      ],
    );
  }
}
