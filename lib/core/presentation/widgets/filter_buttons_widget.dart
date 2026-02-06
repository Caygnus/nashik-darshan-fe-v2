import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable Filter Buttons Widget
/// Used for filtering results (All, Veg Only, Budget, etc.)
class FilterButtonsWidget extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const FilterButtonsWidget({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: filters.map((filter) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: filter == filters.last ? 0 : 8.w),
            child: _buildFilterButton(filter),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFilterButton(String filter) {
    final isSelected = selectedFilter == filter;
    return GestureDetector(
      onTap: () => onFilterSelected(filter),
      child: Container(
        height: 44.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF914D) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        ),
        child: Center(
          child: Text(
            filter,
            style: GoogleFonts.montserrat(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
