import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable Result Count Widget
/// Displays the number of results found
class ResultCountWidget extends StatelessWidget {
  final int count;
  final String itemType;

  const ResultCountWidget({
    super.key,
    required this.count,
    required this.itemType,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$count $itemType found',
      style: GoogleFonts.poppins(
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
        color: const Color(0xFF4B5563),
        height: 20 / 12,
      ),
    );
  }
}
