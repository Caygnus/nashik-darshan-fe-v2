import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nashik/core/router/route_names.dart';
import 'package:nashik/core/utils/snackbar.dart';

/// Itinerary Page
/// Main page for planning and viewing itineraries
class ItineraryPage extends StatefulWidget {
  const ItineraryPage({super.key});

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  String _selectedDuration = '1-Day';
  String _selectedType = 'Family';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          PreferredSize(
            preferredSize: Size.fromHeight(56.h),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, size: 20.sp, color: const Color(0xFF111827)),
                  onPressed: () => context.pop(),
                ),
                title: Text(
                  'Itineraries',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                    height: 28 / 18,
                    fontFamily: 'Roboto',
                  ),
                  textAlign: TextAlign.center,
                ),
                centerTitle: true,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Image Section with Search Card overlapping
            _buildBannerWithCard(),
            SizedBox(height: 20.h),
            // AI Suggestion Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: _buildAISuggestionCard(),
            ),
            SizedBox(height: 16.h),
            // Festive Highlight Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: _buildFestiveHighlightCard(),
            ),
            SizedBox(height: 24.h),
            // Recommended Itineraries Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: _buildRecommendedSection(),
            ),
            SizedBox(height: 24.h),
            // Action Cards (Share Plans & Customize)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: _buildActionCards(),
            ),
            SizedBox(height: 80.h), // Bottom padding
          ],
        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerWithCard() {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Banner Image Section
            _buildBannerSection(),
            // Search Card - positioned half on image, half on white
            Positioned(
              bottom: -78.h, // Negative to position half on banner, half below
              left: 20.w,
              right: 20.w,
              child: _buildSearchCardContent(),
            ),
          ],
        ),
        // Add spacing to account for the card's bottom half
        SizedBox(height: 78.h),
      ],
    );
  }

  Widget _buildBannerSection() {
    return Container(
      width: double.infinity,
      height: 280.h, // Increased from 200.h
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/home-hero.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.3),
              Colors.black.withValues(alpha: 0.6),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your Personalized Nashik Darshan Itinerary',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'Roboto',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Explore. Experience. Remember.',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontFamily: 'Roboto',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildAISuggestionCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2FE),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF0284C7),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.smart_toy_outlined,
                  size: 22.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'AI Suggestion',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0369A1),
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'Since you\'re visiting Sula Vineyards, do you also want to explore York Winery nearby?',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.normal,
              color: const Color(0xFF0C4A6E),
              height: 1.4,
              fontFamily: 'Roboto',
            ),
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: Material(
              color: const Color(0xFF0284C7),
              borderRadius: BorderRadius.circular(12.r),
              child: InkWell(
                onTap: () => context.pushNamed(AppRouteNames.myItineraries),
                borderRadius: BorderRadius.circular(12.r),
                child: Center(
                  child: Text(
                    'View My Itineraries',
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
    );
  }

  Widget _buildFestiveHighlightCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_fire_department_outlined, size: 24.sp, color: const Color(0xFFC2410C)),
              SizedBox(width: 12.w),
              Text(
                'Festive Highlight',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF9A3412),
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Kumbh Mela is happening this month! Special darshan timings and crowd management tips included.',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.normal,
              color: const Color(0xFF4B5563),
              fontFamily: 'Roboto',
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: Material(
              color: const Color(0xFFF97316),
              borderRadius: BorderRadius.circular(12.r),
              child: InkWell(
                onTap: () {
                  // TODO: Navigate to festival itineraries when route/screen is available
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Center(
                  child: Text(
                    'View Festival Itineraries',
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
    );
  }

  Widget _buildRecommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended Itineraries',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
            fontFamily: 'Roboto',
          ),
        ),
        SizedBox(height: 16.h),
        // Spiritual Circuit Card
        _buildItineraryCard(
          imagePath: 'assets/png/trambak.png',
          title: 'Spiritual Circuit',
          duration: '2 Days',
          timePerSpot: '2 - 3 Hours per Spot',
          tags: const ['Trimbakeshwar Temple', 'Panchavati', 'Kalaram Temple'],
          moreCount: 4,
          badgeText: 'High crowd expected',
          badgeColor: const Color(0xFFF472B6),
          badgeTextColor: Colors.white,
          onTap: () => context.pushNamed(
            AppRouteNames.itineraryDetail,
            pathParameters: {'itineraryId': 'spiritual-circuit'},
            queryParameters: {'title': 'Spiritual Circuit'},
          ),
        ),
        SizedBox(height: 16.h),
        // Winery Tour Card
        _buildItineraryCard(
          imagePath: 'assets/png/trambak.png',
          title: 'Winery Tour',
          duration: '2 Days',
          timePerSpot: '2 - 3 Hours per Spot',
          tags: const ['Trimbakeshwar Temple', 'Panchavati', 'Kalaram Temple'],
          moreCount: 4,
          badgeText: 'Wine & Food Trail',
          badgeColor: const Color(0xFFEDE9FE),
          badgeTextColor: const Color(0xFF6D28D9),
          onTap: () => context.pushNamed(
            AppRouteNames.itineraryDetail,
            pathParameters: {'itineraryId': 'winery-tour'},
            queryParameters: {'title': 'Winery Tour'},
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          'Popular from Users',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
            fontFamily: 'Roboto',
          ),
        ),
        SizedBox(height: 16.h),
        _buildUserGeneratedCard(),
        SizedBox(height: 16.h),
        _buildAddReviewButton(),
      ],
    );
  }

  Widget _buildAddReviewButton() {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF994D), Color(0xFFFFB049)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Snackbar.showInfo('Add review coming soon'),
            borderRadius: BorderRadius.circular(8.r),
            child: Center(
              child: Text(
                'Add Review',
                style: GoogleFonts.montserrat(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserGeneratedCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
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
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: const Color(0xFFE5E7EB),
                child: Text(
                  'PS',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6B7280),
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Priya Sharma',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                        fontFamily: 'Roboto',
                      ),
                    ),
                    Text(
                      'Mumbai',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF6B7280),
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'Solo Spiritual Journey',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
              fontFamily: 'Roboto',
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Perfect 1-day plan for peaceful darshan and meditation',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.normal,
              color: const Color(0xFF6B7280),
              height: 1.35,
              fontFamily: 'Roboto',
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(Icons.star, size: 16.sp, color: const Color(0xFFF97316)),
              SizedBox(width: 4.w),
              Text(
                '4.8 (124 reviews)',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                  fontFamily: 'Roboto',
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => context.pushNamed(AppRouteNames.customizeTrip),
                child: Text(
                  'Use Plan',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFF97316),
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCards() {
    return Row(
      children: [
        // Share Plans Card
        Expanded(
          child: _buildActionCard(
            icon: Icons.share,
            iconColor: const Color(0xFF9333EA), // Dark purple
            iconBackgroundColor: const Color(0xFFF3E8FF), // Light lavender purple
            title: 'Share Plans',
            subtitle: 'WhatsApp ready format',
            onTap: () => Snackbar.showInfo('Share plans coming soon'),
          ),
        ),
        SizedBox(width: 12.w),
        // Customize Card
        Expanded(
          child: _buildActionCard(
            icon: Icons.edit,
            iconColor: const Color(0xFF10B981), // Dark green
            iconBackgroundColor: const Color(0xFFD1FAE5), // Light pastel green
            title: 'Customize',
            subtitle: 'Add/remove places',
            onTap: () => context.pushNamed(AppRouteNames.customizeTrip),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBackgroundColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 28.sp,
              ),
            ),
            SizedBox(height: 12.h),
            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F2937),
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            // Subtitle
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.normal,
                color: const Color(0xFF6B7280),
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItineraryCard({
    required String imagePath,
    required String title,
    required String duration,
    required String timePerSpot,
    required List<String> tags,
    required int moreCount,
    required String badgeText,
    required Color badgeColor,
    Color? badgeTextColor,
    required VoidCallback onTap,
  }) {
    final defaultBadgeTextColor = badgeTextColor ?? Colors.white;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with badges
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
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 180.h,
                        color: const Color(0xFFF3F4F6),
                        child: Icon(Icons.image_not_supported, size: 40.sp, color: Colors.grey),
                      );
                    },
                  ),
                ),
                // Badge (top left)
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
                        color: defaultBadgeTextColor,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
                // Favorite icon (top right)
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF1F2937).withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      size: 20.sp,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ),
              ],
            ),
            // Content
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          color: const Color(0xFF9333EA).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(9999.r),
                        ),
                        child: Text(
                          duration,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF9333EA),
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    timePerSpot,
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
                      ...tags.take(3).map((tag) => _buildTag(tag)),
                      if (moreCount > 0) _buildTag('+ $moreCount more'),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9820),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
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
                  ],
                ),
              ),
            ),
          ],
        ),
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

  Widget _buildSearchCardContent() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search field
          Container(
            height: 44.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: const Color(0xFF9CA3AF), size: 18.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search destinations, activities...',
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFFADAEBC),
                        fontFamily: 'Roboto',
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          // Filter: Duration and Type only (as per design)
          Row(
            children: [
              Expanded(child: _buildFilterItem('Duration', _selectedDuration)),
              SizedBox(width: 12.w),
              Expanded(child: _buildFilterItem('Type', _selectedType)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6B7280),
            fontFamily: 'Roboto',
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          width: double.infinity,
          height: 36.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, size: 18.sp, color: const Color(0xFF6B7280)),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1F2937),
                fontFamily: 'Roboto',
              ),
              items: _getFilterItems(label).map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  if (label == 'Duration') {
                    _selectedDuration = newValue!;
                  } else if (label == 'Type') {
                    _selectedType = newValue!;
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  List<String> _getFilterItems(String label) {
    switch (label) {
      case 'Duration':
        return const ['1-Day', '2-Days', '3-Days', 'Week'];
      case 'Budget':
        return const ['Low', 'Medium', 'High', 'Premium'];
      case 'Type':
        return const ['Family', 'Solo', 'Couple', 'Group'];
      default:
        return [];
    }
  }
}
