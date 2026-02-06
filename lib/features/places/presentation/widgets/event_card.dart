import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Event Card Widget
/// Displays upcoming events with wine icon and booking button
class EventCard extends StatelessWidget {
  final VoidCallback? onBookNow;

  const EventCard({
    super.key,
    this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 352.w,
      height: 135.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFC5C5C5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            // Left side - Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Wine icon and "Upcoming Event" text
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/svg/wine.svg',
                        width: 16.w,
                        height: 16.h,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF9333EA),
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Upcoming Event',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500, // Medium
                          color: const Color(0xFF9333EA),
                          height: 16 / 12, // Line height 16
                          fontFamily: 'Roboto',
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  // "Sula-fest" title
                  Text(
                    'Sula-fest',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700, // Bold
                      color: const Color(0xFF1F2937),
                      height: 20 / 14, // Line height 20
                      fontFamily: 'Roboto',
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 4.h),
                  // Description
                  Flexible(
                    child: Text(
                      'Experience premium wines & local culture',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400, // Regular
                        color: const Color(0xFF4B5563),
                        height: 16 / 11, // Line height 16
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Book Now button
                  InkWell(
                    onTap: onBookNow,
                    borderRadius: BorderRadius.circular(9999.r),
                    child: Container(
                      width: 82.86.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF9333EA),
                        borderRadius: BorderRadius.circular(9999.r),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Book Now',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500, // Medium
                            color: Colors.white,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            // Right side - Gradient rounded square with wine bottle
            Container(
              width: 64.w,
              height: 64.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r), // Rounded square instead of circle
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFC084FC), // C084FC
                    Color(0xFFF472B6), // F472B6
                  ],
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/svg/wine.svg',
                  width: 32.w,
                  height: 32.h,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
