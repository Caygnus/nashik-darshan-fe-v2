import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nashik/core/router/route_names.dart';
import 'package:nashik/core/theme/colors.dart';

/// Category for wishlist filter and card tag.
enum _WishlistCategory { all, temples, foodSpots, vineyards, natureGhats }

class _WishlistItem {
  const _WishlistItem({
    required this.id,
    required this.name,
    required this.location,
    required this.category,
    required this.distanceKm,
    required this.imagePath,
    required this.aiInsight,
    required this.insightBgColor,
    required this.insightTextColor,
  });

  final String id;
  final String name;
  final String location;
  final _WishlistCategory category;
  final String distanceKm;
  final String imagePath;
  final String aiInsight;
  final Color insightBgColor;
  final Color insightTextColor;
}

/// Wish List page: header, filters, Smart Suggestion banner, list of wishlisted places, Plan My Trip.
class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  static const routeName = 'WishlistPage';
  static const routePath = '/wishlist';

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  _WishlistCategory _selectedFilter = _WishlistCategory.all;
  static const List<String> _filterLabels = ['All', 'Temples', 'Food Spots', 'Vineyards'];

  final List<_WishlistItem> _items = [
    _WishlistItem(
      id: 'trimbakeshwar',
      name: 'Trimbakeshwar Temple',
      location: 'Near Trimbak Town',
      category: _WishlistCategory.temples,
      distanceKm: '8.2 km',
      imagePath: 'assets/png/trambak.png',
      aiInsight: 'Best visited in morning (6-9 AM). Crowded on Mondays.',
      insightBgColor: const Color(0xFFDBEAFE),
      insightTextColor: const Color(0xFF1E40AF),
    ),
    _WishlistItem(
      id: 'ramkund',
      name: 'Ramkund Ghat',
      location: 'Panchavati Area',
      category: _WishlistCategory.natureGhats,
      distanceKm: '2.1 km',
      imagePath: 'assets/png/herohome-bg.png',
      aiInsight: 'Popular at sunset. Pairs well with nearby temples.',
      insightBgColor: const Color(0xFFEDE9FE),
      insightTextColor: const Color(0xFF5B21B6),
    ),
    _WishlistItem(
      id: 'sula',
      name: 'Sula Vineyards',
      location: 'Gangapur Dam Road',
      category: _WishlistCategory.vineyards,
      distanceKm: '15.4 km',
      imagePath: 'assets/png/trambak.png',
      aiInsight: 'Best during harvest season (Jan-Mar).',
      insightBgColor: const Color(0xFFFFF7ED),
      insightTextColor: const Color(0xFFC2410C),
    ),
  ];

  List<_WishlistItem> get _filteredItems {
    if (_selectedFilter == _WishlistCategory.all) return _items;
    return _items.where((e) => e.category == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20.sp, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Wish List',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
            fontFamily: GoogleFonts.roboto().fontFamily,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 8.h),
            Text(
              'Your Wishlist',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
                fontFamily: GoogleFonts.roboto().fontFamily,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Places you want to visit in Nashik',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.grey,
                fontFamily: GoogleFonts.roboto().fontFamily,
              ),
            ),
            SizedBox(height: 20.h),
            _buildFilterChips(),
            SizedBox(height: 20.h),
            _buildSmartSuggestionBanner(),
            SizedBox(height: 24.h),
            ...items.map((item) => Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: _WishlistCard(
                    item: item,
                    onExplore: () => context.pushNamed(
                      AppRouteNames.placeDetail,
                      pathParameters: {'placeId': item.id},
                    ),
                    onMap: () {},
                    onRemove: () {
                      setState(() {
                        _items.removeWhere((e) => e.id == item.id);
                      });
                    },
                  ),
                )),
            SizedBox(height: 24.h),
            _buildPlanMyTripButton(),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_filterLabels.length, (i) {
          final category = _WishlistCategory.values[i];
          final label = _filterLabels[i];
          final isSelected = _selectedFilter == category;
          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = category),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.white : AppColors.black,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSmartSuggestionBanner() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFFED7AA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, size: 24.sp, color: AppColors.primary),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Smart Suggestion',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '3 places in your wishlist are within 2 km',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.grey,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => context.pushNamed(AppRouteNames.customizeTrip),
              child: Text(
                'Create Mini Itinerary →',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanMyTripButton() {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: FilledButton(
        onPressed: () => context.pushNamed(AppRouteNames.customizeTrip),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          elevation: 0,
        ),
        child: Text(
          'Plan My Trip',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            fontFamily: GoogleFonts.roboto().fontFamily,
          ),
        ),
      ),
    );
  }
}

class _WishlistCard extends StatelessWidget {
  const _WishlistCard({
    required this.item,
    required this.onExplore,
    required this.onMap,
    required this.onRemove,
  });

  final _WishlistItem item;
  final VoidCallback onExplore;
  final VoidCallback onMap;
  final VoidCallback onRemove;

  static String _categoryLabel(_WishlistCategory c) {
    switch (c) {
      case _WishlistCategory.temples:
        return 'Temple';
      case _WishlistCategory.foodSpots:
        return 'Food Spots';
      case _WishlistCategory.vineyards:
        return 'Vineyards';
      case _WishlistCategory.natureGhats:
        return 'Nature & Ghats';
      case _WishlistCategory.all:
        return 'Place';
    }
  }

  static Color _categoryColor(_WishlistCategory c) {
    switch (c) {
      case _WishlistCategory.temples:
        return AppColors.primary;
      case _WishlistCategory.foodSpots:
        return const Color(0xFF16A34A);
      case _WishlistCategory.vineyards:
        return AppColors.darkPurple;
      case _WishlistCategory.natureGhats:
        return const Color(0xFF16A34A);
      case _WishlistCategory.all:
        return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _categoryColor(item.category);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: SizedBox(
              height: 180.h,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    item.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.lightGrey,
                      child: Icon(Icons.image_not_supported, size: 40.sp, color: AppColors.grey),
                    ),
                  ),
                  Positioned(
                    top: 12.h,
                    left: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: categoryColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        _categoryLabel(item.category),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on, size: 14.sp, color: AppColors.grey),
                          SizedBox(width: 4.w),
                          Text(
                            item.distanceKm,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.darkText,
                              fontFamily: GoogleFonts.roboto().fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16.sp, color: AppColors.primary),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        item.location,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.grey,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: item.insightBgColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'AI Insight: ${item.aiInsight}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: item.insightTextColor,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48.h,
                        child: FilledButton(
                          onPressed: onExplore,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Explore More',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: GoogleFonts.roboto().fontFamily,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    _ActionIconButton(
                      onTap: onMap,
                      icon: Icons.map_outlined,
                      backgroundColor: AppColors.lightGrey,
                      iconColor: AppColors.darkText,
                    ),
                    SizedBox(width: 10.w),
                    _ActionIconButton(
                      onTap: onRemove,
                      icon: Icons.favorite,
                      backgroundColor: const Color(0xFFFCE7F3),
                      iconColor: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  const _ActionIconButton({
    required this.onTap,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  final VoidCallback onTap;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: SizedBox(
          width: 48.w,
          height: 48.h,
          child: Icon(icon, size: 22.sp, color: iconColor),
        ),
      ),
    );
  }
}
