import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable View All Button Widget
/// Displays a centered "View All" button
class ViewAllButtonWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;

  const ViewAllButtonWidget({super.key, this.onTap, this.text = 'View All'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFFF8400),
          ),
        ),
      ),
    );
  }
}
