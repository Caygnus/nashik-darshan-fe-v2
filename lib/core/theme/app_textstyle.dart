import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nashik/core/theme/colors.dart';

class AppTextStyle {
  // H1 - Large Heading
  static TextStyle h1({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    color: color ?? AppColors.darkText,
    letterSpacing: -0.3,
    height: 1.2,
  );

  // H2 - Medium Heading
  static TextStyle h2({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: color ?? AppColors.darkText,
    letterSpacing: -0.2,
    height: 1.3,
  );

  // H3 - Small Heading
  static TextStyle h3({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.darkText,
    height: 1.4,
  );

  // Body - Regular text
  static TextStyle body({Color? color, FontWeight? fontWeight}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 14.sp,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? AppColors.darkText,
        height: 1.5,
      );

  // Body Large - Slightly larger body text
  static TextStyle bodyLarge({Color? color, FontWeight? fontWeight}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 15.sp,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? AppColors.darkText,
        height: 1.5,
      );

  // Subtitle - Secondary text
  static TextStyle subtitle({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    color: color ?? AppColors.grey,
    height: 1.4,
  );

  // Caption - Small text
  static TextStyle caption({Color? color, FontWeight? fontWeight}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 12.sp,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? AppColors.grey,
        height: 1.4,
      );

  // Button Text
  static TextStyle button({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: color ?? Colors.white,
    height: 1.4,
  );

  // Label - For form labels, etc.
  static TextStyle label({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: color ?? AppColors.grey,
    height: 1.4,
  );

  // Overline - Very small text
  static TextStyle overline({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.grey,
    letterSpacing: 0.5,
    height: 1.4,
  );
}
