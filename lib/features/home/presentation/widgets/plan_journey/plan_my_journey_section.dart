import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Plan My Journey Section Widget
/// Interactive section for users to plan their journey with AI assistance
class PlanMyJourneySection extends StatefulWidget {
  const PlanMyJourneySection({super.key});

  @override
  State<PlanMyJourneySection> createState() => _PlanMyJourneySectionState();
}

class _PlanMyJourneySectionState extends State<PlanMyJourneySection> {
  String? selectedBudget;
  String? selectedDays;
  int? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
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
            // Title
            Text(
              'Plan My Journey',
              style: GoogleFonts.montserrat(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
                height: 28 / 18,
              ),
            ),
            SizedBox(height: 4.h),
            // Subtitle
            Text(
              'Let AI create your perfect Nashik experience',
              style: GoogleFonts.montserrat(
                fontSize: 12.sp,
                fontWeight: FontWeight.normal,
                color: const Color(0xFF4B5563),
                height: 16 / 12,
              ),
            ),
            SizedBox(height: 16.h),
            // Budget Selection Row
            Row(
              children: [
                _buildBudgetButton('Low Budget'),
                SizedBox(width: 8.w),
                _buildBudgetButton('Medium'),
                SizedBox(width: 8.w),
                _buildBudgetButton('High Budget'),
              ],
            ),
            SizedBox(height: 12.h),
            // Days Selection Row
            Row(
              children: [
                _buildDaysButton('1 Day'),
                SizedBox(width: 8.w),
                _buildDaysButton('2 Days'),
                SizedBox(width: 8.w),
                _buildDaysButton('3 Days'),
              ],
            ),
            SizedBox(height: 16.h),
            // Option Boxes
            _buildOptionBox(
              index: 0,
              title: 'Spiritual Journey',
              subtitle: 'Temples, rituals & sacred sites',
            ),
            SizedBox(height: 10.h),
            _buildOptionBox(
              index: 1,
              title: 'Wine & Dine',
              subtitle: 'Vineyards, wineries & local cuisine',
            ),
            SizedBox(height: 10.h),
            _buildOptionBox(
              index: 2,
              title: 'Complete Experience',
              subtitle: 'Best of both spiritual & leisure',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetButton(String label) {
    final isSelected = selectedBudget == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedBudget = label;
          });
        },
        child: Container(
          height: 37.h,
          decoration: BoxDecoration(

            gradient: isSelected ? const LinearGradient(
                  colors: [Color(0xFFFF934D), Color(0xFFFFB247)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ) : null,
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
            borderRadius: BorderRadius.circular(9999.r),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 12.sp,
              fontWeight: FontWeight.normal,
              color: isSelected ? Colors.white : const Color(0xFF000000),
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildDaysButton(String label) {
    final isSelected = selectedDays == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedDays = label;
          });
        },
        child: Container(
          height: 37.h,
          decoration: BoxDecoration(
            gradient: isSelected ? const LinearGradient(
                  colors: [Color(0xFFFF934D), Color(0xFFFFB247)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ) : null,
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
            borderRadius: BorderRadius.circular(9999.r),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 12.sp,
              fontWeight: FontWeight.normal,
              color: isSelected ? Colors.white : const Color(0xFF000000),
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildOptionBox({
    required int index,
    required String title,
    required String subtitle,
  }) {
    final isSelected = selectedOption == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = index;
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFFF934D), Color(0xFFFFB247)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: isSelected ? null : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFFE5E7EB),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF000000),
                height: 1.2,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: GoogleFonts.montserrat(
                fontSize: 12.sp,
                fontWeight: FontWeight.normal,
                color: isSelected ? Colors.white : const Color(0xFF6B7280),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
