import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable Search Bar Widget
/// Used in Eatery, Hotels, and other listing screens
class SearchBarWidget extends StatelessWidget {
  final String hintText;
  final VoidCallback? onFilterTap;

  const SearchBarWidget({super.key, required this.hintText, this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 355.w,
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        children: [
          // Search Icon
          Icon(Icons.search, color: const Color(0xFF9CA3AF), size: 20.sp),
          SizedBox(width: 12.w),
          // Search Input
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xFFADAEBC),
                  height: 24 / 14,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              style: GoogleFonts.montserrat(
                fontSize: 14.sp,
                fontWeight: FontWeight.normal,
                color: Colors.black,
                height: 24 / 14,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Filter Icon
          GestureDetector(
            onTap: onFilterTap,
            child: Icon(
              Icons.tune,
              color: const Color(0xFFFF7B00),
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}
