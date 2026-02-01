import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/place.dart';

/// Family Place Detail Template
/// Template for displaying family-friendly places
class FamilyPlaceDetailTemplate extends StatelessWidget {
  final Place place;

  const FamilyPlaceDetailTemplate({
    super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Image
          Container(
            width: double.infinity,
            height: 250.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  place.imageUrls.isNotEmpty
                      ? place.imageUrls.first
                      : 'assets/png/trambak.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.name,
                  style: GoogleFonts.montserrat(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  place.description,
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    color: const Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
                if (place.openingHours != null) ...[
                  SizedBox(height: 20.h),
                  _buildInfoSection('Opening Hours', place.openingHours!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: 14.sp,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}
