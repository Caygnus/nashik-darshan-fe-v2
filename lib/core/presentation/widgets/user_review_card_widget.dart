import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable User Review Card Widget
/// Displays user-generated travel plans and reviews
class UserReviewCardWidget extends StatelessWidget {
  final String profileImage;
  final String name;
  final String city;
  final String planTitle;
  final String planDescription;
  final String rating;
  final String reviewCount;
  final VoidCallback? onUsePlanTap;

  const UserReviewCardWidget({
    super.key,
    required this.profileImage,
    required this.name,
    required this.city,
    required this.planTitle,
    required this.planDescription,
    required this.rating,
    required this.reviewCount,
    this.onUsePlanTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 366.55.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Section
          Row(
            children: [
              // Profile Picture
              ClipOval(
                child: Image.asset(
                  profileImage,
                  width: 40.w,
                  height: 40.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12.w),
              // Name and City
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.montserrat(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF000000),
                      height: 20 / 14,
                    ),
                  ),
                  Text(
                    city,
                    style: GoogleFonts.montserrat(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF6B7280),
                      height: 16 / 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Plan Title
          Text(
            planTitle,
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF000000),
            ),
          ),
          SizedBox(height: 4.h),
          // Plan Description
          Text(
            planDescription,
            style: GoogleFonts.montserrat(
              fontSize: 12.sp,
              fontWeight: FontWeight.normal,
              color: const Color(0xFF4B5563),
            ),
          ),
          SizedBox(height: 12.h),
          // Rating and Use Plan Row
          Row(
            children: [
              // Rating Star
              Icon(Icons.star, color: const Color(0xFFFFA201), size: 16.sp),
              SizedBox(width: 4.w),
              // Rating and Reviews
              Text(
                '$rating ($reviewCount reviews)',
                style: GoogleFonts.montserrat(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xFF4B5563),
                ),
              ),
              const Spacer(),
              // Use Plan Button
              GestureDetector(
                onTap: onUsePlanTap,
                child: Text(
                  'Use Plan',
                  style: GoogleFonts.montserrat(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFFF6B35),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
