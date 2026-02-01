import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nashik/core/router/route_names.dart';

/// My Itineraries Page
/// View and manage personal itineraries: create custom, use templates, search, and browse.
class MyItinerariesPage extends StatefulWidget {
  const MyItinerariesPage({super.key});

  @override
  State<MyItinerariesPage> createState() => _MyItinerariesPageState();
}

class _MyItinerariesPageState extends State<MyItinerariesPage> {
  String _selectedTab = 'All';
  final List<String> _tabs = ['All', 'Recent', 'Saved', 'Shared', 'Recommended'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20.sp, color: const Color(0xFF111827)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'My Itineraries',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, size: 24.sp, color: const Color(0xFF111827)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              _buildCreateCustomButton(),
              SizedBox(height: 12.h),
              _buildUseSmartTemplateButton(),
              SizedBox(height: 16.h),
              Text(
                'Plan your perfect Nashik journey your way',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xFF6B7280),
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 20.h),
              _buildTabsRow(),
              SizedBox(height: 12.h),
              _buildSearchBar(),
              SizedBox(height: 20.h),
              _buildSuggestedBanner(),
              SizedBox(height: 20.h),
              _buildItineraryCard(
                imagePath: 'assets/png/trambak.png',
                title: 'Spiritual Circuit',
                duration: '2 Days',
                badgeText: 'High crowd expected',
                badgeColor: const Color(0xFFDC2626),
                badgeTextColor: Colors.white,
                isFavorited: false,
                onViewFullPlan: () => context.pushNamed(
                  AppRouteNames.itineraryDetail,
                  pathParameters: {'itineraryId': 'spiritual-circuit'},
                  queryParameters: {'title': 'Spiritual Circuit'},
                ),
              ),
              SizedBox(height: 16.h),
              _buildItineraryCard(
                imagePath: 'assets/png/trambak.png',
                title: 'Winery Tour',
                duration: '2 Days',
                badgeText: 'Wine & Food Trail',
                badgeColor: const Color(0xFFEDE9FE),
                badgeTextColor: const Color(0xFF6D28D9),
                isFavorited: true,
                onViewFullPlan: () => context.pushNamed(
                  AppRouteNames.itineraryDetail,
                  pathParameters: {'itineraryId': 'winery-tour'},
                  queryParameters: {'title': 'Winery Tour'},
                ),
              ),
              SizedBox(height: 24.h),
              _buildPopularTemplatesSection(),
              SizedBox(height: 80.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateCustomButton() {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: Material(
        color: const Color(0xFFFF9820),
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: () => context.pushNamed(AppRouteNames.customizeTrip),
          borderRadius: BorderRadius.circular(12.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 22.sp, color: Colors.white),
              SizedBox(width: 8.w),
              Text(
                'Create Custom Itinerary',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUseSmartTemplateButton() {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome, size: 22.sp, color: const Color(0xFFFF9820)),
                SizedBox(width: 8.w),
                Text(
                  'Use Smart Template',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFF9820),
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _tabs.map((tab) {
          final isSelected = _selectedTab == tab;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = tab),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFF9820) : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(9999.r),
                ),
                child: Text(
                  tab,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF4B5563),
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 20.sp, color: const Color(0xFF9CA3AF)),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Search places, temples, vineyards...',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF9CA3AF),
                fontFamily: 'Roboto',
              ),
            ),
          ),
          Icon(Icons.tune, size: 22.sp, color: const Color(0xFF6B7280)),
        ],
      ),
    );
  }

  Widget _buildSuggestedBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, size: 28.sp, color: const Color(0xFF16A34A)),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Suggested for you',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF16A34A),
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '2-Day Spiritual Circuit covering Trimbakeshwar, Bramhagiri & Anjaneri',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF4B5563),
                    height: 1.35,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItineraryCard({
    required String imagePath,
    required String title,
    required String duration,
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
    required bool isFavorited,
    VoidCallback? onViewFullPlan,
  }) {
    const tags = ['Trimbakeshwar Temple', 'Panchavati', 'Kalaram Temple'];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: 180.h,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180.h,
                    color: const Color(0xFFF3F4F6),
                    child: Icon(Icons.image_not_supported, size: 40.sp, color: Colors.grey),
                  ),
                ),
              ),
              Positioned(
                top: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(9999.r),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: badgeTextColor,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorited ? Icons.favorite : Icons.favorite_border,
                    size: 20.sp,
                    color: isFavorited ? Colors.red : Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12.r),
                bottomRight: Radius.circular(12.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F2937),
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE9FE),
                        borderRadius: BorderRadius.circular(9999.r),
                      ),
                      child: Text(
                        duration,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF7C3AED),
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  '2 - 3 Hours per Spot',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF6B7280),
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Key Spots',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    ...tags.map((t) => _buildTag(t)),
                    _buildTag('+ 4 more'),
                  ],
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  height: 44.h,
                  child: Material(
                    color: const Color(0xFFFF9820),
                    borderRadius: BorderRadius.circular(12.r),
                    child: InkWell(
                      onTap: onViewFullPlan ?? () {},
                      borderRadius: BorderRadius.circular(12.r),
                      child: Center(
                        child: Text(
                          'View Full Plan',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'Roboto',
                          ),
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

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(9999.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.normal,
          color: const Color(0xFF4B5563),
          fontFamily: 'Roboto',
        ),
      ),
    );
  }

  Widget _buildPopularTemplatesSection() {
    final templates = [
      ('Spiritual Pilgrimage', '3 Days · 12 temples', Icons.account_balance, const Color(0xFFFFF7ED), const Color(0xFFEA580C)),
      ('Wine & Food Tour', '2 Days · 6 vineyards', Icons.wine_bar, const Color(0xFFF3E8FF), const Color(0xFF7C3AED)),
      ('Adventure + Trekking', '1 Day · 4 trails', Icons.terrain, const Color(0xFFDCFCE7), const Color(0xFF16A34A)),
      ('Family Darshan Circuit', '5 Days · 20 locations', Icons.family_restroom, const Color(0xFFDBEAFE), const Color(0xFF2563EB)),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Popular Templates',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F2937),
                fontFamily: 'Roboto',
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'View All',
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFF9820),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ...templates.map((t) => Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: _buildTemplateCard(
            title: t.$1,
            subtitle: t.$2,
            icon: t.$3,
            iconBgColor: t.$4,
            iconColor: t.$5,
          ),
        )),
      ],
    );
  }

  Widget _buildTemplateCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, size: 26.sp, color: iconColor),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2937),
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF6B7280),
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 14.sp, color: const Color(0xFF9CA3AF)),
        ],
      ),
    );
  }
}
