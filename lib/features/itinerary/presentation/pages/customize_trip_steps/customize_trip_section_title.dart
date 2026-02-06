import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shared section title for customize-trip wizard steps.
class CustomizeTripSectionTitle extends StatelessWidget {
  const CustomizeTripSectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24.h, bottom: 12.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF111827),
          fontFamily: 'Roboto',
        ),
      ),
    );
  }
}
