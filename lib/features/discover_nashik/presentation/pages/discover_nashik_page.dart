import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nashik/core/router/route_paths.dart';

/// Discover Nashik Page
/// Comprehensive guide and overview of Nashik with hero, about, history,
/// spiritual heritage, temples, culture, attractions, experiences, and events.
class DiscoverNashikPage extends StatelessWidget {
  const DiscoverNashikPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1F2937)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Discover Nashik',
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(context),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAboutNashikSection(),
                  SizedBox(height: 24.h),
                  _buildRichHistorySection(),
                  SizedBox(height: 24.h),
                  _buildSpiritualHeritageSection(),
                  SizedBox(height: 24.h),
                  _buildFeaturedTemplesSection(),
                  SizedBox(height: 24.h),
                  _buildCulturalRichnessSection(),
                  SizedBox(height: 24.h),
                  _buildExploreAttractionsSection(),
                  SizedBox(height: 24.h),
                  _buildLocalExperiencesSection(),
                  SizedBox(height: 24.h),
                  _buildUpcomingEventsSection(),
                  SizedBox(height: 24.h),
                  _buildPlanYourVisitButton(context),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24.r),
            bottomRight: Radius.circular(24.r),
          ),
          child: Image.asset(
            'assets/images/home-hero.png',
            width: double.infinity,
            height: 280.h,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: double.infinity,
          height: 280.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24.r),
              bottomRight: Radius.circular(24.r),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.2),
                Colors.black.withValues(alpha: 0.6),
              ],
            ),
          ),
        ),
        Positioned(
          left: 20.w,
          bottom: 80.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nashik',
                style: GoogleFonts.montserrat(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Explore the Routes of India',
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 20.w,
          bottom: 16.h,
          child: Row(
            children: [
              _buildHeroTagCard(
                subtitle: 'Holy Godavari',
                title: 'Bathing & Ritual',
              ),
              SizedBox(width: 12.w),
              _buildHeroTagCard(
                subtitle: 'Jyotirlinga',
                title: 'Trimbakeshwar',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeroTagCard({
    required String subtitle,
    required String title,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            subtitle,
            style: GoogleFonts.montserrat(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.montserrat(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1F2937),
      ),
    );
  }

  Widget _buildAboutNashikSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('About Nashik'),
        SizedBox(height: 12.h),
        Text(
          'Nashik is a sacred city where spirituality meets modernity. Known for the holy Godavari River, ancient temples, and the legendary Kumbh Mela, it offers a unique blend of devotion, history, and natural beauty.',
          style: GoogleFonts.montserrat(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF4B5563),
            height: 1.5,
          ),
        ),
        SizedBox(height: 16.h),
        _buildInfoCard(
          icon: Icons.self_improvement,
          iconColor: const Color(0xFFFF934D),
          title: 'Spiritual Significance',
          subtitle: 'Origin of Godavari, sacred temples, Historical importance',
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                icon: Icons.location_on,
                iconColor: const Color(0xFFFF934D),
                title: 'Location',
                subtitle: 'Maharashtra, India',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildInfoCard(
                icon: Icons.translate,
                iconColor: const Color(0xFF3B82F6),
                title: 'Languages',
                subtitle: 'Marathi, Hindi, English',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24.r, color: iconColor),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: GoogleFonts.montserrat(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF4B5563),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRichHistorySection() {
    const orange = Color(0xFFFF934D);
    final circleSize = 44.0.r;
    final gapBetweenCircles = 20.0.h;
    // Line touches bottom of one circle and top of next (no gap)
    final lineHeight = gapBetweenCircles;

    final items = [
      ('Ancient Origins', 'Connected to Ramayana, Lord Rama\'s exile journey'),
      ('Medieval Period', 'Yadavas, Mughals, and Maratha empires'),
      ('Modern Nashik', 'Blending Heritage with Progress'),
    ];
    final icons = [
      Icons.account_balance,   // temple / pagoda
      Icons.workspace_premium, // crown
      Icons.location_city,    // cityscape
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF8F5),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Rich History'),
          SizedBox(height: 20.h),
          ...List.generate(items.length, (i) {
            final (title, subtitle) = items[i];
            final isLast = i == items.length - 1;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: circleSize,
                      height: circleSize,
                      decoration: const BoxDecoration(
                        color: orange,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        icons[i],
                        size: 22.r,
                        color: Colors.white,
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 3.w,
                        height: lineHeight,
                        decoration: BoxDecoration(
                          color: orange,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.montserrat(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF222222),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: GoogleFonts.montserrat(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF666666),
                          height: 1.4,
                        ),
                      ),
                      if (!isLast) SizedBox(height: gapBetweenCircles),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSpiritualHeritageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Spiritual Heritage'),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF934D), Color(0xFFFFB247)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF934D).withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kumbh Mela',
                style: GoogleFonts.montserrat(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  height: 28 / 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'World\'s largest religious gathering',
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next Occurrence',
                      style: GoogleFonts.montserrat(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '2027',
                      style: GoogleFonts.montserrat(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedTemplesSection() {
    final temples = [
      ('Trimbakeshwar Temple', 'One of 12 Jyotirlingas', 'assets/png/trambak.png'),
      ('Kalaram Temple', 'Black stone Lord Rama', 'assets/png/trambak.png'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Featured Temples'),
        SizedBox(height: 12.h),
        ...temples.map((t) => Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: _buildTempleCard(name: t.$1, subtitle: t.$2, imagePath: t.$3),
        )),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) => Container(
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            width: 6.w,
            height: 6.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == 0 ? const Color(0xFFFF934D) : Colors.grey.shade300,
            ),
          )),
        ),
      ],
    );
  }

  Widget _buildTempleCard({
    required String name,
    required String subtitle,
    required String imagePath,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              imagePath,
              width: 64.w,
              height: 64.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: GoogleFonts.montserrat(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 14.r, color: const Color(0xFF9CA3AF)),
        ],
      ),
    );
  }

  Widget _buildCulturalRichnessSection() {
    final items = [
      ('Classical Dance', Icons.music_note, 'assets/png/trambak.png'),
      ('Festivals &\nCelebrations', Icons.calendar_today, 'assets/png/trambak.png'),
      ('Food Culture', Icons.restaurant, 'assets/png/trambak.png'),
      ('Handicrafts & Art', Icons.palette, 'assets/png/trambak.png'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Cultural Richness'),
        SizedBox(height: 12.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildCulturalRichnessCard(title: items[0].$1, icon: items[0].$2, imagePath: items[0].$3)),
            SizedBox(width: 10.w),
            Expanded(child: _buildCulturalRichnessCard(title: items[1].$1, icon: items[1].$2, imagePath: items[1].$3)),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildCulturalRichnessCard(title: items[2].$1, icon: items[2].$2, imagePath: items[2].$3)),
            SizedBox(width: 10.w),
            Expanded(child: _buildCulturalRichnessCard(title: items[3].$1, icon: items[3].$2, imagePath: items[3].$3)),
          ],
        ),
      ],
    );
  }

  /// Cultural Richness card: aspect 163x100, border radius 12, icon + title on all cards.
  /// Width fills available space (e.g. inside Expanded); height fixed at 100.
  Widget _buildCulturalRichnessCard({
    required String title,
    required IconData icon,
    required String imagePath,
  }) {
    return SizedBox(
      height: 100.h,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(imagePath, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.25),
                    Colors.black.withValues(alpha: 0.65),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 26.r, color: Colors.white),
                  SizedBox(height: 6.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreAttractionsSection() {
    final attractions = [
      ('Shree Trimbakeshwar', 'assets/png/trambak.png'),
      ('Godavari River', 'assets/png/trambak.png'),
      ('Pandavleni Caves', 'assets/png/trambak.png'),
      ('Sula Vineyards', 'assets/png/trambak.png'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Explore Attractions'),
        SizedBox(height: 12.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildExploreAttractionCard(title: attractions[0].$1, imagePath: attractions[0].$2)),
            SizedBox(width: 10.w),
            Expanded(child: _buildExploreAttractionCard(title: attractions[1].$1, imagePath: attractions[1].$2)),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildExploreAttractionCard(title: attractions[2].$1, imagePath: attractions[2].$2)),
            SizedBox(width: 10.w),
            Expanded(child: _buildExploreAttractionCard(title: attractions[3].$1, imagePath: attractions[3].$2)),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) => Container(
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            width: 6.w,
            height: 6.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == 0 ? const Color(0xFFFF934D) : Colors.grey.shade300,
            ),
          )),
        ),
      ],
    );
  }

  /// Explore Attraction card: aspect 165x128, corner radius 12.
  /// Full-bleed image with semi-transparent dark overlay at bottom; title left-aligned in white.
  Widget _buildExploreAttractionCard({
    required String title,
    required String imagePath,
  }) {
    return SizedBox(
      height: 128.h,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(imagePath, fit: BoxFit.cover),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 40.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.75),
                    ],
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalExperiencesSection() {
    final experiences = [
      ('Temple Aartis', 'Sacred evening ceremonies', Icons.self_improvement, const Color(0xFFFED7AA)),
      ('Godavari River Cycling', 'Scenic riverside trails', Icons.directions_bike, const Color(0xFFBBF7D0)),
      ('Wine Tasting Tours', 'Premium vineyard experiences', Icons.wine_bar, const Color(0xFFE9D5FF)),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Local Experiences'),
        SizedBox(height: 12.h),
        ...experiences.map((e) => Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: e.$4.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.$1,
                        style: GoogleFonts.montserrat(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        e.$2,
                        style: GoogleFonts.montserrat(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF4B5563),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(e.$3, size: 32.r, color: const Color(0xFFFF934D)),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildUpcomingEventsSection() {
    final events = [
      ('Nashik Music Festival', 'April 2024'),
      ('Grape Harvest Festival', 'March 2024'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Upcoming Events'),
        SizedBox(height: 12.h),
        ...events.map((e) => Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.$1,
                        style: GoogleFonts.montserrat(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        e.$2,
                        style: GoogleFonts.montserrat(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF4B5563),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 14.r, color: const Color(0xFF9CA3AF)),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildPlanYourVisitButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(AppRoutePaths.itinerary),
      child: Container(
        width: double.infinity,
        height: 52.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF934D), Color(0xFFFFB247)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF934D).withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          'Plan Your Visit',
          style: GoogleFonts.montserrat(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
