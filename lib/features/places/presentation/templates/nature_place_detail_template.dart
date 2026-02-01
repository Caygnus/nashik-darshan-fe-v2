import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/place.dart';

/// Nature Place Detail Template
/// Dark-theme detail page for nature places (e.g. Pahine Waterfall).
/// Matches design: hero with back/audio, tabs, About, Best Time, How to Reach,
/// Things to Do, Explore Nearby, You Might Also Like, Checklist, Visitor Info,
/// Facilities, Reviews, Leave No Trace.
class NaturePlaceDetailTemplate extends StatefulWidget {
  final Place place;

  const NaturePlaceDetailTemplate({
    super.key,
    required this.place,
  });

  @override
  State<NaturePlaceDetailTemplate> createState() => _NaturePlaceDetailTemplateState();
}

class _NaturePlaceDetailTemplateState extends State<NaturePlaceDetailTemplate> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['About', 'How To Reach', 'Facilities'];

  String get _shortName => widget.place.name.replaceAll(' Waterfall', '').replaceAll(' Hills', '');
  String get _marathiName => widget.place.additionalInfo?['marathiName'] as String? ?? 'पहिने धबधबा';
  String get _subtitle => widget.place.additionalInfo?['subtitle'] as String? ?? 'Waterfall and Trek • Nashik, Maharashtra';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHero(),
          Container(
            width: double.infinity,
            color: const Color(0xFF121212),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  _buildTabs(),
                  SizedBox(height: 24.h),
                  _buildAboutSection(),
                  _buildBestTimeCard(),
                  _buildSectionTitle('How to Reach'),
                  _buildHowToReachCard(),
                  _buildTransportButtons(),
                  _buildSectionTitle('Things to Do'),
                  _buildThingsToDoGrid(),
                  _buildSectionTitle('Explore Nearby'),
                  _buildExploreNearbyCards(),
                  _buildSectionTitle('You Might Also Like'),
                  _buildYouMightAlsoLikeCards(),
                  _buildSectionTitle('Checklist'),
                  _buildChecklistCard(),
                  _buildSectionTitle('Visitor Information'),
                  _buildVisitorInfoCards(),
                  _buildSectionTitle('Facilities'),
                  _buildFacilitiesCard(),
                  _buildSectionTitle('Reviews & Experiences'),
                  _buildReviewsSection(),
                  _buildSectionTitle('Leave No Trace'),
                  _buildLeaveNoTraceSection(),
                  SizedBox(height: 80.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    final imageUrl = widget.place.imageUrls.isNotEmpty ? widget.place.imageUrls.first : 'assets/png/trambak.png';
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 320.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 320.h,
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
        Positioned(
          top: MediaQuery.of(context).padding.top + 8.h,
          left: 12.w,
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, size: 22.sp, color: Colors.white),
            onPressed: () => context.pop(),
            style: IconButton.styleFrom(backgroundColor: Colors.black26),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 8.h,
          right: 12.w,
          child: Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: const Color(0xFFFF9933),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Icon(Icons.headphones, color: Colors.white, size: 22.sp),
          ),
        ),
        Positioned(
          bottom: 20.h,
          right: 16.w,
          child: Icon(Icons.chevron_right, size: 28.sp, color: Colors.white70),
        ),
        Positioned(
          left: 20.w,
          right: 60.w,
          bottom: 24.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF16A34A),
                  borderRadius: BorderRadius.circular(9999.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.park, size: 18.sp, color: Colors.white),
                    SizedBox(width: 6.w),
                    Text('Nature', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Roboto')),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                _marathiName,
                style: GoogleFonts.montserrat(fontSize: 26.sp, fontWeight: FontWeight.w700, color: Colors.white, height: 1.2),
              ),
              SizedBox(height: 4.h),
              Text(
                widget.place.name,
                style: GoogleFonts.montserrat(fontSize: 20.sp, fontWeight: FontWeight.w600, color: Colors.white, height: 1.2),
              ),
              SizedBox(height: 6.h),
              Text(
                _subtitle,
                style: TextStyle(fontSize: 14.sp, color: Colors.white.withValues(alpha: 0.9), fontFamily: 'Roboto'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Row(
      children: List.generate(_tabs.length, (i) {
        final isSelected = _selectedTabIndex == i;
        final label = i == 0 ? 'About $_shortName' : _tabs[i];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < _tabs.length - 1 ? 10.w : 0),
            child: Material(
              color: isSelected ? const Color(0xFFFF9933) : Colors.transparent,
              borderRadius: BorderRadius.circular(10.r),
              child: InkWell(
                onTap: () => setState(() => _selectedTabIndex = i),
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: isSelected ? null : Border.all(color: Colors.white24),
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.white,
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 28.h, bottom: 14.h),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('About $_shortName'),
        Text(
          widget.place.description,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white.withValues(alpha: 0.9),
            height: 1.5,
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }

  Widget _buildBestTimeCard() {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0D9488).withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF0D9488).withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, size: 22.sp, color: const Color(0xFF5EEAD4)),
              SizedBox(width: 10.w),
              Text(
                'Best Time to Visit',
                style: GoogleFonts.montserrat(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _bullet('June-September: Monsoon magic with full flow'),
          SizedBox(height: 6.h),
          _bullet('October-February: Perfect for picnics & photography'),
        ],
      ),
    );
  }

  Widget _bullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: TextStyle(fontSize: 14.sp, color: Colors.white, fontFamily: 'Roboto')),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14.sp, color: Colors.white.withValues(alpha: 0.9), height: 1.4, fontFamily: 'Roboto'),
          ),
        ),
      ],
    );
  }

  Widget _buildHowToReachCard() {
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, size: 22.sp, color: const Color(0xFFEF4444)),
              SizedBox(width: 10.w),
              Text(
                'From Nashik City',
                style: GoogleFonts.montserrat(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            'Route: Nashik + $_shortName',
            style: TextStyle(fontSize: 14.sp, color: Colors.white.withValues(alpha: 0.9), fontFamily: 'Roboto'),
          ),
          SizedBox(height: 4.h),
          Text(
            'Distance: ~25 km (40-50 mins drive)',
            style: TextStyle(fontSize: 14.sp, color: Colors.white.withValues(alpha: 0.9), fontFamily: 'Roboto'),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportButtons() {
    final options = [
      {'icon': Icons.directions_car, 'label': 'Auto', 'color': const Color(0xFFEAB308)},
      {'icon': Icons.two_wheeler, 'label': 'Self Drive', 'color': const Color(0xFFEC4899)},
      {'icon': Icons.local_taxi, 'label': 'Private Cab', 'color': const Color(0xFF3B82F6)},
    ];
    return Padding(
      padding: EdgeInsets.only(top: 14.h),
      child: Row(
        children: options.map((o) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  children: [
                    Icon(o['icon'] as IconData, size: 28.sp, color: o['color'] as Color),
                    SizedBox(height: 8.h),
                    Text(
                      o['label'] as String,
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Roboto'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildThingsToDoGrid() {
    final items = [
      {'icon': Icons.directions_walk, 'title': 'Trekking', 'subtitle': 'Scenic nature trails', 'color': const Color(0xFF16A34A)},
      {'icon': Icons.camera_alt, 'title': 'Photography', 'subtitle': 'Instagram-worthy shots', 'color': const Color(0xFF9333EA)},
      {'icon': Icons.air, 'title': 'Relaxation', 'subtitle': 'Perfect picnic spots', 'color': const Color(0xFF3B82F6)},
      {'icon': Icons.wb_sunny_outlined, 'title': 'Seasonal', 'subtitle': 'Monsoon specials', 'color': const Color(0xFFFF9933)},
    ];
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12.h,
      crossAxisSpacing: 12.w,
      childAspectRatio: 1.0,
      children: items.map((e) {
        final color = e['color'] as Color;
        return Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(e['icon'] as IconData, size: 32.sp, color: color),
              SizedBox(height: 10.h),
              Text(
                e['title'] as String,
                style: GoogleFonts.montserrat(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),
              Text(
                e['subtitle'] as String,
                style: TextStyle(fontSize: 12.sp, color: Colors.white.withValues(alpha: 0.85), fontFamily: 'Roboto'),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExploreNearbyCards() {
    final nearby = [
      {'title': 'Anjaneri Hills', 'desc': 'Birthplace of Lord Hanuman', 'distance': '8 km away', 'image': 'assets/png/trambak.png'},
      {'title': 'Trimbakeshwar Temple', 'desc': 'Sacred Jyotirlinga shrine', 'distance': '12 km away', 'image': 'assets/png/trambak.png'},
      {'title': 'Brahmagiri Hill', 'desc': 'Origin of Godavari River', 'distance': '5 km away', 'image': 'assets/png/trambak.png'},
    ];
    return Column(
      children: nearby.map((e) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.asset(
                  e['image'] as String,
                  width: 80.w,
                  height: 80.w,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(width: 80.w, height: 80.w, color: Colors.white12, child: Icon(Icons.image, color: Colors.white54)),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e['title'] as String,
                      style: GoogleFonts.montserrat(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      e['desc'] as String,
                      style: TextStyle(fontSize: 13.sp, color: Colors.white70, fontFamily: 'Roboto'),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14.sp, color: const Color(0xFFFF9933)),
                        SizedBox(width: 4.w),
                        Text(e['distance'] as String, style: TextStyle(fontSize: 12.sp, color: Colors.white70, fontFamily: 'Roboto')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildYouMightAlsoLikeCards() {
    final items = [
      {'title': 'Dugarwadi Waterfall', 'desc': 'Popular monsoon destination', 'distance': '25 km from Nashik', 'rating': 4.6, 'image': 'assets/png/trambak.png'},
      {'title': 'Vihigaon Waterfall', 'desc': 'Adventure & rappelling hub', 'distance': '35 km from Nashik', 'rating': 4.4, 'image': 'assets/png/trambak.png'},
    ];
    return Column(
      children: items.map((e) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(11.r)),
                child: Image.asset(
                  e['image'] as String,
                  width: double.infinity,
                  height: 140.h,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(height: 140.h, color: Colors.white12),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e['title'] as String,
                      style: GoogleFonts.montserrat(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      e['desc'] as String,
                      style: TextStyle(fontSize: 13.sp, color: Colors.white70, fontFamily: 'Roboto'),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Text(
                          e['distance'] as String,
                          style: TextStyle(fontSize: 12.sp, color: Colors.white70, fontFamily: 'Roboto'),
                        ),
                        SizedBox(width: 12.w),
                        Row(
                          children: List.generate(5, (i) {
                            final filled = i < (e['rating'] as num).round();
                            return Icon(
                              filled ? Icons.star : Icons.star_border,
                              size: 16.sp,
                              color: const Color(0xFFFBBF24),
                            );
                          }),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${e['rating']}',
                          style: TextStyle(fontSize: 12.sp, color: Colors.white70, fontFamily: 'Roboto'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChecklistCard() {
    final items = [
      {'icon': Icons.hiking, 'label': 'Trekking Shoes', 'color': const Color(0xFF16A34A)},
      {'icon': Icons.beach_access, 'label': 'Raincoat', 'color': const Color(0xFF3B82F6)},
      {'icon': Icons.restaurant, 'label': 'Snacks', 'color': const Color(0xFFFF9933)},
      {'icon': Icons.water_drop_outlined, 'label': 'Water Bottle', 'color': const Color(0xFF0EA5E9)},
      {'icon': Icons.camera_alt, 'label': 'Camera', 'color': const Color(0xFF9333EA)},
      {'icon': Icons.medical_services_outlined, 'label': 'First Aid', 'color': const Color(0xFFEF4444)},
    ];
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white12),
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 0.85,
        children: items.map((e) {
          final color = e['color'] as Color;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(e['icon'] as IconData, size: 28.sp, color: color),
              SizedBox(height: 8.h),
              Text(
                e['label'] as String,
                style: TextStyle(fontSize: 12.sp, color: Colors.white, fontFamily: 'Roboto'),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildVisitorInfoCards() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            children: [
              Icon(Icons.attach_money, size: 28.sp, color: const Color(0xFF16A34A)),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Entry Fee', style: GoogleFonts.montserrat(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.white)),
                    Text('Free entry • No parking charges', style: TextStyle(fontSize: 13.sp, color: Colors.white70, fontFamily: 'Roboto')),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded, size: 28.sp, color: const Color(0xFFFF9933)),
                  SizedBox(width: 14.w),
                  Text('Safety Tips', style: GoogleFonts.montserrat(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.white)),
                ],
              ),
              SizedBox(height: 12.h),
              _bullet('Watch for slippery rocks during monsoon'),
              SizedBox(height: 6.h),
              _bullet('Carry first-aid kit for emergencies'),
              SizedBox(height: 6.h),
              _bullet('Stay away from waterfall edge'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFacilitiesCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Icon(Icons.apartment, size: 28.sp, color: const Color(0xFF16A34A)),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Facilities', style: GoogleFonts.montserrat(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.white)),
                Text('Local food stalls • Parking available • Local guides on request', style: TextStyle(fontSize: 13.sp, color: Colors.white70, fontFamily: 'Roboto')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(5, (_) => Icon(Icons.star, size: 28.sp, color: const Color(0xFFFBBF24))),
        ),
        SizedBox(height: 16.h),
        _buildReviewSnippet('The views from the top are absolutely breathtaking. Perfect for adventure lovers.', 'Rahul M.', const Color(0xFF16A34A)),
        SizedBox(height: 12.h),
        _buildReviewSnippet('The origin of Godavari is truly divine. Felt peaceful and connected.', 'Priya S.', const Color(0xFFFF9933)),
        SizedBox(height: 20.h),
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: Material(
            color: const Color(0xFFFF9933),
            borderRadius: BorderRadius.circular(12.r),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12.r),
              child: Center(
                child: Text(
                  'Add Review',
                  style: GoogleFonts.montserrat(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewSnippet(String text, String author, Color lineColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: lineColor,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(fontSize: 14.sp, color: Colors.white.withValues(alpha: 0.9), height: 1.4, fontFamily: 'Roboto'),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  CircleAvatar(radius: 12.r, backgroundColor: Colors.white24),
                  SizedBox(width: 8.w),
                  Text(author, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Roboto')),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeaveNoTraceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: const Color(0xFF16A34A).withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.eco, size: 44.sp, color: const Color(0xFF16A34A)),
          ),
        ),
        SizedBox(height: 16.h),
        Center(
          child: Text(
            'Help preserve this natural wonder for future generations. Take only memories, leave only footprints.',
            style: TextStyle(fontSize: 14.sp, color: Colors.white.withValues(alpha: 0.9), height: 1.5, fontFamily: 'Roboto'),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 20.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Support Local Communities',
                style: GoogleFonts.montserrat(fontSize: 15.sp, fontWeight: FontWeight.w600, color: const Color(0xFF16A34A)),
              ),
              SizedBox(height: 6.h),
              Text(
                'Choose local homestays • Buy from local vendors',
                style: TextStyle(fontSize: 13.sp, color: Colors.white70, fontFamily: 'Roboto'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
