import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/place.dart';

/// Shopping Place Detail Template
/// Matches design: transparent app bar over hero, purple Shopping tag,
/// tabs (About, How To Reach, Stores), sections for Stores & Shopping,
/// You Might Also Like, Visitor Checklist, Visitor Information,
/// Reviews, Leave No Trace.
class ShoppingPlaceDetailTemplate extends StatefulWidget {
  final Place place;

  const ShoppingPlaceDetailTemplate({
    super.key,
    required this.place,
  });

  @override
  State<ShoppingPlaceDetailTemplate> createState() => _ShoppingPlaceDetailTemplateState();
}

class _ShoppingPlaceDetailTemplateState extends State<ShoppingPlaceDetailTemplate> {
  int _selectedTabIndex = 0;
  bool _isFavorite = false;
  final List<String> _tabs = ['About', 'How To Reach', 'Stores'];

  String get _shortName {
    final name = widget.place.name;
    if (name.toLowerCase().contains('city centre') || name.toLowerCase().contains('city center')) return 'CCM';
    return name.replaceAll(' Mall', '').replaceAll(' Shopping', '');
  }

  String get _marathiName =>
      widget.place.additionalInfo?['marathiName'] as String? ?? 'नाशिक सिटी सेंटर मॉल';
  String get _subtitle =>
      widget.place.additionalInfo?['subtitle'] as String? ?? 'Family and Shopping · Nashik, Maharashtra';

  static const Color _contentTitleColor = Color(0xFF1F2937);
  static const Color _contentTextColor = Color(0xFF4B5563);
  static const Color _contentCardBg = Color(0xFFF5F5F5);
  static const Color _contentBorder = Color(0xFFE5E7EB);
  static const Color _contentSubdued = Color(0xFF6B7280);
  static const Color _orange = Color(0xFFFF994D);
  static const Color _orangeGradientStart = Color(0xFFFF994D);
  static const Color _orangeGradientEnd = Color(0xFFFFB049);
  static const Color _shoppingPurple = Color(0xFF8F00FF);

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
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  _buildTabs(),
                  SizedBox(height: 24.h),
                  _buildAboutSection(),
                  _buildSectionTitle('How to Reach'),
                  _buildHowToReachCard(),
                  _buildTransportButtons(),
                  _buildPeakHoursAndCrowdCards(),
                  _buildSectionTitle('Stores & Shopping'),
                  _buildStoresGrid(),
                  _buildSectionTitle('You Might Also Like'),
                  _buildYouMightAlsoLikeCards(),
                  _buildSectionTitle('Visitor Checklist'),
                  _buildVisitorChecklistCard(),
                  _buildSectionTitle('Visitor Information'),
                  _buildVisitorInfoCards(),
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
    final imageUrl =
        widget.place.imageUrls.isNotEmpty ? widget.place.imageUrls.first : 'assets/png/trambak.png';
    final topPadding = MediaQuery.of(context).padding.top;
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
                Colors.black.withValues(alpha: 0.2),
                Colors.black.withValues(alpha: 0.7),
              ],
            ),
          ),
        ),
        // Transparent app bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new, size: 22.sp, color: _contentTitleColor),
                    onPressed: () => context.pop(),
                    style: IconButton.styleFrom(backgroundColor: Colors.white.withValues(alpha: 0.9)),
                  ),
                  Expanded(
                    child: Text(
                      widget.place.name,
                      style: GoogleFonts.montserrat(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: _contentTitleColor,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 26.sp,
                      color: _isFavorite ? Colors.red : _contentTitleColor,
                    ),
                    onPressed: () => setState(() => _isFavorite = !_isFavorite),
                    style: IconButton.styleFrom(backgroundColor: Colors.white.withValues(alpha: 0.9)),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Audio button - top right
        Positioned(
          top: topPadding + 8.h,
          right: 16.w,
          child: Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: _orange,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Icon(Icons.headphones_outlined, color: Colors.white, size: 22.sp),
          ),
        ),
        // Category tag (purple) + names - bottom left
        Positioned(
          left: 20.w,
          right: 20.w,
          bottom: 24.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: _shoppingPurple,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_bag_outlined, size: 18.sp, color: Colors.white),
                    SizedBox(width: 6.w),
                    Text(
                      'Shopping',
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: 'Roboto'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                _marathiName,
                style: GoogleFonts.montserrat(
                    fontSize: 24.sp, fontWeight: FontWeight.w700, color: Colors.white, height: 1.2),
              ),
              SizedBox(height: 4.h),
              Text(
                widget.place.name,
                style: GoogleFonts.montserrat(
                    fontSize: 20.sp, fontWeight: FontWeight.w600, color: Colors.white, height: 1.2),
              ),
              SizedBox(height: 6.h),
              Text(
                _subtitle,
                style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white.withValues(alpha: 0.95),
                    fontFamily: 'Roboto'),
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
              color: isSelected ? _orange : _contentCardBg,
              borderRadius: BorderRadius.circular(10.r),
              child: InkWell(
                onTap: () => setState(() => _selectedTabIndex = i),
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: isSelected ? null : Border.all(color: _contentBorder),
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? Colors.white : _contentSubdued,
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
          fontWeight: FontWeight.w600,
          color: _contentTitleColor,
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('About ${widget.place.name}'),
        Text(
          widget.place.description,
          style: TextStyle(
            fontSize: 14.sp,
            color: _contentTextColor,
            height: 1.5,
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }

  Widget _buildHowToReachCard() {
    return Container(
      margin: EdgeInsets.only(top: 4.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: _contentCardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _contentBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 22.sp, color: const Color(0xFFEF4444)),
              SizedBox(width: 10.w),
              Text(
                'From Nashik City',
                style: GoogleFonts.montserrat(
                    fontSize: 16.sp, fontWeight: FontWeight.w600, color: _contentTitleColor),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            'Route: Nashik + $_shortName',
            style: TextStyle(fontSize: 14.sp, color: _contentTextColor, fontFamily: 'Roboto'),
          ),
          SizedBox(height: 4.h),
          Text(
            'Distance: ~2.5 km (40-50 mins drive)',
            style: TextStyle(fontSize: 14.sp, color: _contentTextColor, fontFamily: 'Roboto'),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportButtons() {
    final options = [
      {
        'icon': Icons.local_taxi_outlined,
        'label': 'Auto',
        'color': const Color(0xFFEAB308),
        'bg': const Color(0xFFFEF9C3),
      },
      {
        'icon': Icons.directions_car_outlined,
        'label': 'Self Drive',
        'color': const Color(0xFF9333EA),
        'bg': const Color(0xFFEDE9FE),
      },
      {
        'icon': Icons.local_taxi_outlined,
        'label': 'Private Cab',
        'color': const Color(0xFF3B82F6),
        'bg': const Color(0xFFDBEAFE),
      },
    ];
    return Padding(
      padding: EdgeInsets.only(top: 14.h),
      child: Row(
        children: options.asMap().entries.map((entry) {
          final i = entry.key;
          final o = entry.value;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < options.length - 1 ? 10.w : 0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: o['bg'] as Color,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: _contentBorder),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(o['icon'] as IconData, size: 28.sp, color: o['color'] as Color),
                    SizedBox(height: 8.h),
                    Text(
                      o['label'] as String,
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: _contentTitleColor,
                          fontFamily: 'Roboto'),
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

  Widget _buildPeakHoursAndCrowdCards() {
    return Padding(
      padding: EdgeInsets.only(top: 14.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFF16A34A).withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.calendar_today_outlined, size: 24.sp, color: const Color(0xFF16A34A)),
                  SizedBox(height: 8.h),
                  Text(
                    'Best Time',
                    style: GoogleFonts.montserrat(
                        fontSize: 14.sp, fontWeight: FontWeight.w600, color: _contentTitleColor),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Early morning, Winter months',
                    style: TextStyle(fontSize: 12.sp, color: _contentTextColor, fontFamily: 'Roboto'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: const Color(0xFFDBEAFE),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.people_outline, size: 24.sp, color: const Color(0xFF3B82F6)),
                  SizedBox(height: 8.h),
                  Text(
                    'Crowd Level',
                    style: GoogleFonts.montserrat(
                        fontSize: 14.sp, fontWeight: FontWeight.w600, color: _contentTitleColor),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Moderate on weekends',
                    style: TextStyle(fontSize: 12.sp, color: _contentTextColor, fontFamily: 'Roboto'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoresGrid() {
    final items = [
      {
        'icon': Icons.checkroom_outlined,
        'title': 'Fashion & App..',
        'subtitle': 'Floor 1-2',
        'color': const Color(0xFFEC4899),
        'bg': const Color(0xFFFCE7F3),
      },
      {
        'icon': Icons.spa_outlined,
        'title': 'Beauty & well...',
        'subtitle': 'Floor 1',
        'color': const Color(0xFF9333EA),
        'bg': const Color(0xFFEDE9FE),
      },
      {
        'icon': Icons.phone_android_outlined,
        'title': 'Electronics',
        'subtitle': 'Floor 2',
        'color': const Color(0xFF3B82F6),
        'bg': const Color(0xFFDBEAFE),
      },
      {
        'icon': Icons.card_giftcard_outlined,
        'title': 'Lifestyle',
        'subtitle': 'Floor no 1,2,3',
        'color': _orange,
        'bg': const Color(0xFFFFEDD5),
      },
    ];
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12.h,
      crossAxisSpacing: 12.w,
      childAspectRatio: 1.05,
      children: items.map((e) {
        final color = e['color'] as Color;
        final bg = e['bg'] as Color;
        return Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: _contentBorder),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(e['icon'] as IconData, size: 32.sp, color: color),
              SizedBox(height: 10.h),
              Text(
                e['title'] as String,
                style: GoogleFonts.montserrat(
                    fontSize: 14.sp, fontWeight: FontWeight.w600, color: _contentTitleColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),
              Text(
                e['subtitle'] as String,
                style: TextStyle(fontSize: 12.sp, color: _contentTextColor, fontFamily: 'Roboto'),
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

  Widget _buildYouMightAlsoLikeCards() {
    final items = [
      {
        'title': 'College Road',
        'desc': 'Popular Shopping destination',
        'distance': '2.5 km from Nashik',
        'rating': 4.6,
        'image': 'assets/png/trambak.png',
      },
      {
        'title': 'Big Bazzar',
        'desc': 'Mall & retail',
        'distance': '4.5 km from Nashik',
        'rating': 4.4,
        'image': 'assets/png/trambak.png',
      },
    ];
    return Column(
      children: items.map((e) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: _contentBorder),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(11.r)),
                child: Image.asset(
                  e['image'] as String,
                  width: double.infinity,
                  height: 120.h,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(height: 120.h, color: _contentBorder),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            e['title'] as String,
                            style: GoogleFonts.montserrat(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: _contentTitleColor),
                          ),
                        ),
                        Icon(Icons.star, size: 18.sp, color: const Color(0xFFFBBF24)),
                        SizedBox(width: 4.w),
                        Text(
                          '${e['rating']}',
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: _contentSubdued,
                              fontFamily: 'Roboto'),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      e['desc'] as String,
                      style: TextStyle(fontSize: 13.sp, color: _contentSubdued, fontFamily: 'Roboto'),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      e['distance'] as String,
                      style: TextStyle(fontSize: 12.sp, color: _contentSubdued, fontFamily: 'Roboto'),
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

  Widget _buildVisitorChecklistCard() {
    final items = [
      {'icon': Icons.local_parking, 'label': 'Parking Available', 'color': _orange},
      {'icon': Icons.accessible, 'label': 'Wheelchair Access', 'color': _orange},
      {'icon': Icons.family_restroom, 'label': 'Family Friendly', 'color': _orange},
      {'icon': Icons.wc, 'label': 'Washrooms', 'color': _orange},
      {'icon': Icons.atm, 'label': 'ATM Available', 'color': _orange},
      {'icon': Icons.phone_android, 'label': 'UPI Accepted', 'color': _orange},
    ];
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: _contentCardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _contentBorder),
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 14.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 2.2,
        children: items.map((e) {
          final color = e['color'] as Color;
          return Row(
            children: [
              Icon(e['icon'] as IconData, size: 24.sp, color: color),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  e['label'] as String,
                  style: TextStyle(
                      fontSize: 14.sp, color: _contentTitleColor, fontFamily: 'Roboto'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
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
        _buildVisitorCard(
            Icons.confirmation_num_outlined, 'Entry Fee', 'Free entry · No parking charges', const Color(0xFF16A34A)),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: _contentCardBg,
            borderRadius: BorderRadius.circular(12.r),
            border: Border(
              left: BorderSide(color: _orange, width: 3),
              top: BorderSide(color: _contentBorder),
              right: BorderSide(color: _contentBorder),
              bottom: BorderSide(color: _contentBorder),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded, size: 28.sp, color: _orange),
                  SizedBox(width: 14.w),
                  Text(
                    'Safety Tips',
                    style: GoogleFonts.montserrat(
                        fontSize: 15.sp, fontWeight: FontWeight.w600, color: _contentTitleColor),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              _bullet('Keep belongings secure'),
              SizedBox(height: 6.h),
              _bullet('Park in designated areas'),
              SizedBox(height: 6.h),
              _bullet('Follow mall guidelines'),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        _buildVisitorCard(
            Icons.restaurant_outlined, 'Facilities', 'Food court · Restrooms · Parking', const Color(0xFF3B82F6)),
      ],
    );
  }

  Widget _buildVisitorCard(IconData icon, String title, String detail, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: _contentCardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _contentBorder),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28.sp, color: color),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    title,
                    style: GoogleFonts.montserrat(
                        fontSize: 15.sp, fontWeight: FontWeight.w600, color: _contentTitleColor)),
                Text(
                    detail,
                    style: TextStyle(fontSize: 13.sp, color: _contentSubdued, fontFamily: 'Roboto')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: TextStyle(fontSize: 14.sp, color: _contentTitleColor, fontFamily: 'Roboto')),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14.sp, color: _contentTextColor, height: 1.4, fontFamily: 'Roboto'),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox.shrink(),
            Row(
              children: [
                Text(
                  '4.6',
                  style: GoogleFonts.montserrat(
                      fontSize: 18.sp, fontWeight: FontWeight.w700, color: _contentTitleColor),
                ),
                SizedBox(width: 8.w),
                ...List.generate(5, (_) => Icon(Icons.star, size: 24.sp, color: const Color(0xFFFBBF24))),
              ],
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildReviewSnippet('Great variety of stores. Clean and well maintained.', 'Rahul M.', const Color(0xFF16A34A)),
        SizedBox(height: 12.h),
        _buildReviewSnippet('Family-friendly mall with good food court.', 'Priya S.', _orange),
        SizedBox(height: 20.h),
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [_orangeGradientStart, _orangeGradientEnd],
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12.r),
                child: Center(
                  child: Text(
                    'Add Review',
                    style: GoogleFonts.montserrat(
                        fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
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
                style: TextStyle(fontSize: 14.sp, color: _contentTextColor, height: 1.4, fontFamily: 'Roboto'),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  CircleAvatar(radius: 12.r, backgroundColor: _contentBorder),
                  SizedBox(width: 8.w),
                  Text(
                      author,
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: _contentTitleColor,
                          fontFamily: 'Roboto')),
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
              color: const Color(0xFF16A34A).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.eco_outlined, size: 44.sp, color: const Color(0xFF16A34A)),
          ),
        ),
        SizedBox(height: 16.h),
        Center(
          child: Text(
            'Leave No Trace',
            style: GoogleFonts.montserrat(
                fontSize: 18.sp, fontWeight: FontWeight.w700, color: _contentTitleColor),
          ),
        ),
        SizedBox(height: 12.h),
        Center(
          child: Text(
            'Help preserve this place for future generations. Take only memories, leave only footprints.',
            style: TextStyle(
                fontSize: 14.sp, color: _contentTextColor, height: 1.5, fontFamily: 'Roboto'),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 20.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              side: const BorderSide(color: Color(0xFF16A34A)),
              foregroundColor: const Color(0xFF16A34A),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              backgroundColor: _contentCardBg,
            ),
            child: Text(
              'Support Local Communities',
              style: GoogleFonts.montserrat(
                  fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF16A34A)),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Center(
          child: Text(
            'Choose local homestays - Buy from local vendors',
            style: TextStyle(fontSize: 13.sp, color: _contentSubdued, fontFamily: 'Roboto'),
          ),
        ),
      ],
    );
  }
}
