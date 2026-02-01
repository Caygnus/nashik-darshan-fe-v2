import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Event Detail Page
/// Displays detailed information about a specific event
class EventDetailPage extends StatelessWidget {
  final String eventId;
  final String eventTitle;

  const EventDetailPage({
    super.key,
    required this.eventId,
    required this.eventTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color(0xFF1F2937), size: 24.sp),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Event detail',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 80.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Banner Section
            _buildEventBanner(),
            // Key Event Information
            _buildKeyEventInfo(),
            SizedBox(height: 16.h),
            // Live Status
            _buildLiveStatus(),
            SizedBox(height: 24.h),
            // About This Spiritual Event
            _buildAboutSection(),
            SizedBox(height: 24.h),
            // Spiritual Significance
            _buildSpiritualSignificance(),
            SizedBox(height: 24.h),
            // Schedule & Ritual Flow
            _buildScheduleSection(),
            SizedBox(height: 24.h),
            // Temple Authority
            _buildTempleAuthority(),
            SizedBox(height: 24.h),
            // Visitor Guidelines
            _buildVisitorGuidelines(),
            SizedBox(height: 24.h),
            // Nearby Places
            _buildNearbyPlaces(),
            SizedBox(height: 24.h),
            // Plan Your Visit Smartly
            _buildAISuggestions(),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildEventBanner() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 300.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/home-hero.png'),
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
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),
        ),
        // Event Title and Date with Tags above
        Positioned(
          bottom: 24.h,
          left: 16.w,
          right: 16.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tags above title
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9933),
                      borderRadius: BorderRadius.circular(9999.r),
                    ),
                    child: Text(
                      'Spiritual',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9333EA),
                      borderRadius: BorderRadius.circular(9999.r),
                    ),
                    child: Text(
                      'Annual Event',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                'Shravan Somvar Mahapuja',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Mon, Jul 22, 2024 · 5:00 AM - 8:00 PM',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKeyEventInfo() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: const Color(0xFFE5E7EB), width: 1),
          bottom: BorderSide(color: const Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoItem(Icons.location_on, 'Trimbakeshwar', const Color(0xFFFF9933)),
            Container(width: 1, height: 40.h, color: const Color(0xFFE5E7EB)),
            _buildInfoItem(Icons.access_time, '15 Hours', const Color(0xFFFFB048)),
            Container(width: 1, height: 40.h, color: const Color(0xFFE5E7EB)),
            _buildInfoItem(Icons.people, 'High Crowd', const Color(0xFFFF9933)),
            Container(width: 1, height: 40.h, color: const Color(0xFFE5E7EB)),
            _buildInfoItem(Icons.confirmation_number, 'Free Entry', const Color(0xFF10B981)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, Color color) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
              fontFamily: 'Roboto',
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLiveStatus() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: 343.w,
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFEF4444), // Red
              Color(0xFFF97316), // Orange
            ],
          ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'Event Ongoing Now',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
            Text(
              'View Live',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9933).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.self_improvement,
                  color: const Color(0xFFFF9933),
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'About This Spiritual Event',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'Shravan Somvar Mahapuja is a sacred Monday ritual during the holy month of Shravan, dedicated to Lord Shiva at Trimbakeshwar Temple. Devotees gather to perform Rudrabhishek, offering milk, water, and bilva leaves to seek divine blessings.',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.normal,
              color: const Color(0xFF4B5563),
              fontFamily: 'Roboto',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpiritualSignificance() {
    final items = [
      {
        'icon': Icons.temple_hindu,
        'title': 'Religious Importance',
        'description': 'Shravan month is most auspicious for Lord Shiva worship. Mondays hold special significance for devotees seeking blessings.',
      },
      {
        'icon': Icons.whatshot,
        'title': 'Associated Deity',
        'description': 'Lord Shiva - One of the 12 Jyotirlingas. Trimbakeshwar is believed to fulfill wishes and grant moksha.',
      },
      {
        'icon': Icons.wb_sunny,
        'title': 'Best Time for Blessings',
        'description': 'Early morning Abhishek (5-7 AM) and evening Mahaarti (7 PM) are most powerful for spiritual connection.',
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spiritual Significance',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
              fontFamily: 'Roboto',
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            width: 343.w,
            height: 359.5.h,
            padding: EdgeInsets.fromLTRB(12.w, 12.w, 12.w, 8.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFEDD5), // FFEDD5
                  Color(0xFFFFFBEB), // FFFBEB
                ],
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ...items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(bottom: index < items.length - 1 ? 12.h : 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF9933).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            color: const Color(0xFFFF9933),
                            size: 22.sp,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item['title'] as String,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1F2937),
                                  fontFamily: 'Roboto',
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                item['description'] as String,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.normal,
                                  color: const Color(0xFF4B5563),
                                  fontFamily: 'Roboto',
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection() {
    final scheduleItems = [
      {
        'time': '5:00 AM - Rudrabhishek',
        'icon': Icons.water_drop,
        'description': 'Sacred water and milk offering to Shivalinga',
      },
      {
        'time': '7:00 AM - Mahapuja',
        'icon': Icons.notifications,
        'description': 'Grand worship ceremony with mantras and offerings',
      },
      {
        'time': '12:00 PM - Prasad Distribution',
        'icon': Icons.restaurant,
        'description': 'Blessed food offering to all devotees',
      },
      {
        'time': '7:00 PM - Evening Mahaarti',
        'icon': Icons.light_mode,
        'description': 'Grand aarti with lamps, bells, and devotional songs',
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.access_time, color: const Color(0xFFFF9933), size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                'Schedule & Ritual Flow',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...scheduleItems.map((item) => Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9933).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: const Color(0xFFFF9933),
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['time'] as String,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1F2937),
                              fontFamily: 'Roboto',
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            item['description'] as String,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF4B5563),
                              fontFamily: 'Roboto',
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTempleAuthority() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Temple Authority',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
              fontFamily: 'Roboto',
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF3F4F6),
                    image: DecorationImage(
                      image: AssetImage('assets/images/home-hero.png'),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {},
                    ),
                  ),
                  child: Icon(Icons.person, size: 32.sp, color: const Color(0xFF6B7280)),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pandit Shankar Maharaj',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F2937),
                          fontFamily: 'Roboto',
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Head Priest, Trimbakeshwar Temple',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF6B7280),
                          fontFamily: 'Roboto',
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Serving the temple for 35+ years. Renowned scholar of Vedic rituals and spiritual guidance.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF4B5563),
                          fontFamily: 'Roboto',
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitorGuidelines() {
    final guidelines = [
      {
        'icon': Icons.checkroom,
        'iconColor': const Color(0xFF9333EA),
        'title': 'Dress Code',
        'description': 'Traditional attire recommended. Avoid shorts and sleeveless clothing.',
      },
      {
        'icon': Icons.block,
        'iconColor': Colors.red,
        'title': 'Not Allowed',
        'description': 'Mobile phones inside sanctum, leather items, outside food.',
      },
      {
        'icon': Icons.access_time,
        'iconColor': const Color(0xFF3B82F6),
        'title': 'Arrival Time',
        'description': 'Reach by 4:30 AM to avoid crowds and secure good darshan spot.',
      },
      {
        'icon': Icons.accessible,
        'iconColor': const Color(0xFF10B981),
        'title': 'Senior Citizens',
        'description': 'Separate queue available. Wheelchair assistance on request.',
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: const Color(0xFF3B82F6), size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                'Visitor Guidelines',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...guidelines.map((guideline) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Container(
                  width: 343.w,
                  height: 90.h,
                  padding: EdgeInsets.fromLTRB(12.w, 10.w, 12.w, 10.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFFF3F4F6), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42.w,
                        height: 42.w,
                        decoration: BoxDecoration(
                          color: (guideline['iconColor'] as Color).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          guideline['icon'] as IconData,
                          color: guideline['iconColor'] as Color,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              guideline['title'] as String,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1F2937),
                                fontFamily: 'Roboto',
                                height: 1.1,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              guideline['description'] as String,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF4B5563),
                                fontFamily: 'Roboto',
                                height: 1.25,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildNearbyPlaces() {
    final places = [
      {
        'image': 'assets/images/home-hero.png',
        'name': 'Kushavarta Kund',
        'description': 'Sacred bathing ghat',
        'distance': '0.5 km',
        'time': '5 min walk',
      },
      {
        'image': 'assets/images/home-hero.png',
        'name': 'Prasad Bhojanalaya',
        'description': 'Temple prasad',
        'distance': '0.1 km',
        'time': '2 min walk',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nearby Places',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                  fontFamily: 'Roboto',
                ),
              ),
              InkWell(
                onTap: () {
                  // TODO: Navigate to all nearby places
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFF9933),
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 140.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: places.length,
            itemBuilder: (context, index) {
              final place = places[index];
              return Container(
                width: 280.w,
                margin: EdgeInsets.only(right: 12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.r),
                        bottomLeft: Radius.circular(12.r),
                      ),
                      child: Image.asset(
                        place['image'] as String,
                        width: 100.w,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 100.w,
                            height: double.infinity,
                            color: const Color(0xFFF3F4F6),
                            child: Icon(Icons.image_not_supported, size: 24.sp, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              place['name'] as String,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1F2937),
                                fontFamily: 'Roboto',
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              place['description'] as String,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF6B7280),
                                fontFamily: 'Roboto',
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 12.sp, color: const Color(0xFF6B7280)),
                                SizedBox(width: 4.w),
                                Text(
                                  '${place['distance']} · ${place['time']}',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xFF6B7280),
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            InkWell(
                              onTap: () {
                                // TODO: Show directions
                              },
                              child: Text(
                                'Directions',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFFF9933),
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAISuggestions() {
    final suggestions = [
      {
        'icon': Icons.lightbulb_outline,
        'iconColor': const Color(0xFFFFB800), // Yellow
        'text': 'Best time: Arrive at 4:30 AM for peaceful darshan',
      },
      {
        'icon': Icons.link,
        'iconColor': const Color(0xFF3B82F6), // Blue
        'text': 'Combine with Kushavarta Kund visit for full experience',
      },
      {
        'icon': Icons.eco,
        'iconColor': const Color(0xFF10B981), // Green
        'text': 'Avoid 6-9 AM slot when crowd peaks',
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFF7ED),
              const Color(0xFFFFF4E6),
            ],
          ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFFFE4CC), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF3B82F6),
                        Color(0xFF9333EA),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Plan Your Visit Smartly',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F2937),
                          fontFamily: 'Roboto',
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'AI-powered personalized suggestions',
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
            SizedBox(height: 16.h),
            ...suggestions.map((suggestion) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          suggestion['icon'] as IconData,
                          color: suggestion['iconColor'] as Color,
                          size: 20.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            suggestion['text'] as String,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF1F2937),
                              fontFamily: 'Roboto',
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            SizedBox(height: 16.h),
            Center(
              child: Container(
                width: 307.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF97316),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                ),
                child: Center(
                  child: Text(
                    'Get AI Suggestions',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600, // SemiBold
                      color: Colors.white,
                      fontFamily: 'Roboto', // Using Roboto as Montserrat alternative
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
