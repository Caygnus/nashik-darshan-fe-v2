import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable Listing Card Widget
/// Used for both Restaurant and Hotel cards with flexible customization
class ListingCardWidget extends StatelessWidget {
  final String imagePath;
  final String category;
  final String name;
  final String rating;
  final Color ratingColor;
  final String type; // e.g., "Continental • Wine Tasting"
  final String description;
  final String price;
  final String location;
  final String feature;
  final IconData featureIcon;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;

  const ListingCardWidget({
    super.key,
    required this.imagePath,
    required this.category,
    required this.name,
    required this.rating,
    required this.ratingColor,
    required this.type,
    required this.description,
    required this.price,
    required this.location,
    required this.feature,
    required this.featureIcon,
    required this.buttonText,
    this.onButtonPressed,
    this.onFavoriteTap,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358.w,
      decoration: BoxDecoration(
        color: Colors.white,
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
          // Image Section with Category and Favorite Button
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
                child: Image.asset(
                  imagePath,
                  width: 358.w,
                  height: 192.h,
                  fit: BoxFit.cover,
                ),
              ),
              // Category Badge (Top Left)
              Positioned(
                top: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9999.r),
                  ),
                  child: Text(
                    category,
                    style: GoogleFonts.montserrat(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ),
              ),
              // Favorite Button (Top Right)
              Positioned(
                top: 12.h,
                right: 12.w,
                child: GestureDetector(
                  onTap: onFavoriteTap,
                  child: Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite
                          ? const Color(0xFFFF6B35)
                          : const Color(0xFF4B5563),
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Details Section
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Rating Row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: GoogleFonts.montserrat(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2937),
                          height: 28 / 18,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: ratingColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.white, size: 14.sp),
                          SizedBox(width: 4.w),
                          Text(
                            rating,
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                // Type (Cuisine/Room Type)
                Text(
                  type,
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF6B7280),
                    height: 20 / 14,
                  ),
                ),
                SizedBox(height: 8.h),
                // Description
                Text(
                  description,
                  style: GoogleFonts.montserrat(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF4B5563),
                    height: 20 / 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12.h),
                // Price, Location, Feature Row
                Row(
                  children: [
                    Icon(
                      Icons.currency_rupee,
                      size: 16.sp,
                      color: const Color(0xFF6B7280),
                    ),
                    Text(
                      price,
                      style: GoogleFonts.montserrat(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Icon(
                      Icons.location_on_outlined,
                      size: 16.sp,
                      color: const Color(0xFF6B7280),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      location,
                      style: GoogleFonts.montserrat(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Icon(
                      featureIcon,
                      size: 16.sp,
                      color: const Color(0xFF6B7280),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        feature,
                        style: GoogleFonts.montserrat(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF6B7280),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // Action Button
                GestureDetector(
                  onTap: onButtonPressed,
                  child: Container(
                    width: 326.w,
                    height: 46.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF914D),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text(
                        buttonText,
                        style: GoogleFonts.montserrat(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
