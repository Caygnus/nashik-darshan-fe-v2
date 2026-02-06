import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/place.dart';

/// Place Card Widget
/// Displays a place in a card format
class PlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback? onTap;

  const PlaceCard({
    super.key,
    required this.place,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
              child: Image.asset(
                place.imageUrls.isNotEmpty
                    ? place.imageUrls.first
                    : 'assets/png/trambak.png',
                width: 120.w,
                height: 120.h,
                fit: BoxFit.cover,
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: GoogleFonts.montserrat(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      place.description,
                      style: GoogleFonts.montserrat(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF6B7280),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (place.openingHours != null) ...[
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14.sp,
                            color: const Color(0xFF6B7280),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            place.openingHours!,
                            style: GoogleFonts.montserrat(
                              fontSize: 12.sp,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
