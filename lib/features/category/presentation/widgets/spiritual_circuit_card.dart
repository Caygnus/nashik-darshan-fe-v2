import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Spiritual Circuit Card Widget
/// Displays a promotional card for spiritual circuit tours
class SpiritualCircuitCard extends StatelessWidget {
  final VoidCallback? onBookTour;

  const SpiritualCircuitCard({
    super.key,
    this.onBookTour,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 348.w,
      height: 80.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF9933), // FF9933 100%
            Color(0xFFF97316), // F97316 100%
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h), // Reduced vertical padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left side - Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // "Spiritual Circuit" title
                  Text(
                    'Spiritual Circuit',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600, // Semibold
                      color: Colors.white,
                      height: 1.2, // Reduced line height to prevent overflow
                      fontFamily: 'Roboto',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h), // Reduced spacing
                  // "Trimbakeshwar + Pandavleni" subtitle
                  Text(
                    'Trimbakeshwar + Pandavleni',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400, // Regular
                      color: Colors.white,
                      height: 1.0, // Reduced line height to prevent overflow
                      fontFamily: 'Roboto',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            // Right side - Book tour button
            Semantics(
              label: 'Book tour',
              button: true,
              child: InkWell(
                onTap: onBookTour,
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  width: 99.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: const Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Book tour',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500, // Medium
                        color: const Color(0xFF8B2635),
                        fontFamily: 'Roboto',
                      ),
                    ),
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
