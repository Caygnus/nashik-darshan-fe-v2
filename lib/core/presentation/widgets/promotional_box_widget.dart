import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable Promotional Box Widget
/// Used for highlighting special offers or features
class PromotionalBoxWidget extends StatelessWidget {
  final String heading;
  final String subheading;
  final String? iconPath;

  const PromotionalBoxWidget({
    super.key,
    required this.heading,
    required this.subheading,
    this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF944D), Color(0xFFFFB247)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          // Left side - Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  heading,
                  style: GoogleFonts.montserrat(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 28 / 18,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subheading,
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    height: 20 / 14,
                  ),
                ),
              ],
            ),
          ),
          // Right side - Icon
          if (iconPath != null)
            SvgPicture.asset(
              iconPath!,
              width: 40.w,
              height: 40.h,
              colorFilter: const ColorFilter.mode(
                Color(0xFFFFFFFF),
                BlendMode.srcIn,
              ),
            ),
        ],
      ),
    );
  }
}
