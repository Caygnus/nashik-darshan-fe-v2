import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Hotel Card Widget
/// Custom card for hotel listings with detailed information
class HotelCardWidget extends StatelessWidget {
  final String imagePath;
  final String name;
  final String price;
  final String priceUnit;
  final double rating;
  final int reviewCount;
  final String location;
  final String nearbyInfo;
  final List<String> amenities;
  final List<IconData> amenityIcons;
  final String? dealText;
  final VoidCallback? onViewDetails;

  const HotelCardWidget({
    super.key,
    required this.imagePath,
    required this.name,
    required this.price,
    this.priceUnit = 'per night',
    required this.rating,
    required this.reviewCount,
    required this.location,
    required this.nearbyInfo,
    required this.amenities,
    required this.amenityIcons,
    this.dealText,
    this.onViewDetails,
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
          // Image Section
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
          // Details Section
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Price Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hotel Name
                    Expanded(
                      child: Text(
                        name,
                        style: GoogleFonts.montserrat(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Price Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹$price',
                          style: GoogleFonts.montserrat(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFF6B35),
                          ),
                        ),
                        Text(
                          priceUnit,
                          style: GoogleFonts.montserrat(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // Rating Section
                Row(
                  children: [
                    // Star Rating
                    ...List.generate(5, (index) {
                      return Icon(
                        index < rating.floor()
                            ? Icons.star
                            : (index < rating
                                  ? Icons.star_half
                                  : Icons.star_border),
                        color: const Color(0xFFFFA201),
                        size: 16.sp,
                      );
                    }),
                    SizedBox(width: 6.w),
                    // Rating Text
                    Text(
                      '$rating ($reviewCount reviews)',
                      style: GoogleFonts.montserrat(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // Location Row
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16.sp,
                      color: const Color(0xFF6B7280),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        location,
                        style: GoogleFonts.montserrat(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // Nearby Info Box
                Container(
                  width: 237.w,
                  height: 24.h,
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(9999.r),
                  ),
                  child: Center(
                    child: Text(
                      nearbyInfo,
                      style: GoogleFonts.montserrat(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF1F2937),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                // Amenities Row
                Wrap(
                  spacing: 16.w,
                  runSpacing: 8.h,
                  children: List.generate(
                    amenities.length > 4 ? 4 : amenities.length,
                    (index) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            amenityIcons[index],
                            size: 16.sp,
                            color: const Color(0xFF6B7280),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            amenities[index],
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Deal Box (if available)
                if (dealText != null) ...[
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF5FF),
                      border: Border.all(
                        color: const Color(0xFFE9D5FF),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 20.sp,
                          color: const Color(0xFF7E22CE),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            dealText!,
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF7E22CE),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // View Details Button
                  Center(
                    child: GestureDetector(
                      onTap: onViewDetails,
                      child: Container(
                        width: 326.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF914D),
                          borderRadius: BorderRadius.circular(9999.r),
                        ),
                        child: Center(
                          child: Text(
                            'View Details',
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
