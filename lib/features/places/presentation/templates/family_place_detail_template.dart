import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/place.dart';

/// Family Place Detail Template
/// Matches design: transparent app bar over hero, orange Family tag,
/// tabs (About, How To Reach, Things To Do), sections for Facilities,
/// Things to Do, Explore Nearby, You Might Also Like, Checklist,
/// Visitor Information, Reviews, Leave No Trace.
class FamilyPlaceDetailTemplate extends StatefulWidget {
  final Place place;

  const FamilyPlaceDetailTemplate({
    super.key,
    required this.place,
  });

  @override
  State<FamilyPlaceDetailTemplate> createState() => _FamilyPlaceDetailTemplateState();
}

class _FamilyPlaceDetailTemplateState extends State<FamilyPlaceDetailTemplate> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _navScrollController = ScrollController();
  int _activeSectionIndex = 0;
  bool _showStickyNav = false;
  bool _isScrollingToSection = false;
  final Map<int, GlobalKey> _sectionKeys = {};

  static const List<String> _sections = [
    'About',
    'How to Reach',
    'Facilities',
    'Things to Do',
    'Explore Nearby',
    'You Might Also Like',
    'Checklist',
    'Visitor Information',
    'Reviews & Experiences',
    'Leave No Trace',
  ];

  String get _shortName => widget.place.name.replaceAll(' Park', '').replaceAll(' Garden', '');
  String get _marathiName => widget.place.additionalInfo?['marathiName'] as String? ?? 'गोदा पार्क';
  String get _subtitle => widget.place.additionalInfo?['subtitle'] as String? ?? 'Family and Riverside View · Nashik, Maharashtra';

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _sections.length; i++) {
      _sectionKeys[i] = GlobalKey();
    }
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _onScroll();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _navScrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final scrollOffset = _scrollController.offset;
    final imageSectionHeight = 400.h;
    final overlapHeight = 20.h;
    final navBarHeight = 61.h;
    final shouldShowNav = scrollOffset > (imageSectionHeight - overlapHeight - navBarHeight);
    if (_showStickyNav != shouldShowNav) {
      setState(() => _showStickyNav = shouldShowNav);
    }
    const threshold = 61.0;
    int? newActiveIndex;
    double minDistance = double.infinity;
    for (int i = 0; i < _sections.length; i++) {
      final key = _sectionKeys[i];
      if (key?.currentContext != null) {
        final RenderBox? renderBox = key?.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final position = renderBox.localToGlobal(Offset.zero);
          final sectionTop = position.dy;
          final sectionBottom = sectionTop + renderBox.size.height;
          if (sectionTop <= threshold && sectionBottom >= threshold) {
            newActiveIndex = i;
            break;
          }
          final distance = (sectionTop - threshold).abs();
          if (distance < minDistance) {
            minDistance = distance;
            newActiveIndex = i;
          }
        }
      }
    }
    if (!_isScrollingToSection && newActiveIndex != null && _activeSectionIndex != newActiveIndex) {
      setState(() => _activeSectionIndex = newActiveIndex!);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollNavToActiveTab(newActiveIndex!);
      });
    }
  }

  void _scrollNavToActiveTab(int index) {
    if (!_navScrollController.hasClients) return;
    const estimatedTabWidth = 110.0;
    const estimatedSpacing = 8.0;
    final estimatedTabLeft = index * (estimatedTabWidth + estimatedSpacing);
    final navPosition = _navScrollController.position;
    final navViewportWidth = navPosition.viewportDimension;
    final targetOffset = (estimatedTabLeft + estimatedTabWidth / 2) - (navViewportWidth / 2);
    _navScrollController.animateTo(
      targetOffset.clamp(0.0, navPosition.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToSection(int index) {
    final key = _sectionKeys[index];
    if (key?.currentContext != null) {
      _isScrollingToSection = true;
      setState(() => _activeSectionIndex = index);
      const stickyNavHeight = 61.0;
      if (!_showStickyNav) setState(() => _showStickyNav = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = key?.currentContext;
        if (context != null && _scrollController.hasClients) {
          final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            final scrollable = Scrollable.of(context);
            final scrollablePosition = scrollable.position;
            final scrollableRenderObject = scrollablePosition.context.storageContext.findRenderObject();
            if (scrollableRenderObject != null) {
              final scrollableBox = scrollableRenderObject as RenderBox;
              final sectionTop = renderBox.localToGlobal(Offset.zero, ancestor: scrollableBox).dy;
              final currentScrollOffset = scrollablePosition.pixels;
              final sectionAbsolutePosition = currentScrollOffset + sectionTop;
              final targetOffset = sectionAbsolutePosition - stickyNavHeight;
              scrollablePosition.animateTo(
                targetOffset.clamp(0.0, scrollablePosition.maxScrollExtent),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ).then((_) {
                Future.delayed(const Duration(milliseconds: 200), () {
                  if (mounted) setState(() => _isScrollingToSection = false);
                });
              });
              _scrollNavToActiveTab(index);
              return;
            }
          }
        }
        if (key?.currentContext != null) {
          Scrollable.ensureVisible(
            key!.currentContext!,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: 0.0,
            alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
          ).then((_) {
            Future.delayed(const Duration(milliseconds: 400), () {
              if (mounted) setState(() => _isScrollingToSection = false);
            });
          });
        } else {
          if (mounted) setState(() => _isScrollingToSection = false);
        }
        _scrollNavToActiveTab(index);
      });
    }
  }

  static const Color _contentTitleColor = Color(0xFF1F2937);
  static const Color _contentTextColor = Color(0xFF4B5563);
  static const Color _contentCardBg = Color(0xFFF9FAFB);
  static const Color _contentBorder = Color(0xFFE5E7EB);
  static const Color _contentSubdued = Color(0xFF6B7280);
  static const Color _orange = Color(0xFFFF9933);
  static const Color _orangeGradientStart = Color(0xFFFF934D);
  static const Color _orangeGradientEnd = Color(0xFFFFB247);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHero(),
              Transform.translate(
                offset: Offset(0, -20.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: _contentBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 44.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _sections.length,
                            itemBuilder: (context, index) {
                              final isActive = index == _activeSectionIndex;
                              return Padding(
                                key: ValueKey('nav-tab-$index'),
                                padding: EdgeInsets.only(
                                  right: index < _sections.length - 1 ? 8.w : 0,
                                ),
                                child: _buildNavigationTab(_sections[index], isActive, index),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Container(height: 1.h, color: _contentBorder),
                        SizedBox(height: 24.h),
                        ...List.generate(_sections.length, (index) {
                          return Column(
                            key: _sectionKeys[index],
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionContent(index),
                              if (index < _sections.length - 1) SizedBox(height: 32.h),
                            ],
                          );
                        }),
                        SizedBox(height: 80.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_showStickyNav) _buildStickyNavigationBar(),
      ],
    );
  }

  Widget _buildNavigationTab(String title, bool isActive, int index) {
    return InkWell(
      onTap: () => _scrollToSection(index),
      borderRadius: BorderRadius.circular(9999.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFF8A02) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(9999.r),
          border: Border.all(color: _contentBorder),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.white : const Color(0xFF374151),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildStickyNavigationBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
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
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 12.h, bottom: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40.h,
              child: ListView.builder(
                controller: _navScrollController,
                scrollDirection: Axis.horizontal,
                itemCount: _sections.length,
                itemBuilder: (context, index) {
                  final isActive = index == _activeSectionIndex;
                  return Padding(
                    key: ValueKey('sticky-nav-tab-$index'),
                    padding: EdgeInsets.only(
                      right: index < _sections.length - 1 ? 8.w : 0,
                    ),
                    child: _buildNavigationTab(_sections[index], isActive, index),
                  );
                },
              ),
            ),
            SizedBox(height: 8.h),
            Container(height: 1.h, color: _contentBorder),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContent(int index) {
    switch (index) {
      case 0:
        return _buildAboutSection();
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('How to Reach'),
            _buildHowToReachCard(),
            _buildTransportButtons(),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Facilities'),
            _buildFacilitiesGrid(),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Things to Do'),
            _buildThingsToDoGrid(),
          ],
        );
      case 4:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Explore Nearby'),
            _buildExploreNearbyCards(),
          ],
        );
      case 5:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('You Might Also Like'),
            _buildYouMightAlsoLikeCards(),
          ],
        );
      case 6:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Checklist'),
            _buildChecklistCard(),
          ],
        );
      case 7:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Visitor Information'),
            _buildVisitorInfoCards(),
          ],
        );
      case 8:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Reviews & Experiences'),
            _buildReviewsSection(),
          ],
        );
      case 9:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Leave No Trace'),
            _buildLeaveNoTraceSection(),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildHero() {
    final imageUrl = widget.place.imageUrls.isNotEmpty ? widget.place.imageUrls.first : 'assets/png/trambak.png';
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 400.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 400.h,
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
        // Audio guide button - top right (image section starts below page app bar)
        Positioned(
          top: 16.h,
          right: 16.w,
          child: Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: _orange,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Icon(Icons.headphones, color: Colors.white, size: 22.sp),
          ),
        ),
        // Category tag (orange gradient) + names - bottom left
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
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [_orangeGradientStart, _orangeGradientEnd],
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.groups, size: 18.sp, color: Colors.white),
                    SizedBox(width: 6.w),
                    Text('Family', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Roboto')),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
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
                style: TextStyle(fontSize: 14.sp, color: Colors.white.withValues(alpha: 0.95), fontFamily: 'Roboto'),
              ),
            ],
          ),
        ),
      ],
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
          color: _contentTitleColor,
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
              Icon(Icons.location_on, size: 22.sp, color: const Color(0xFFEF4444)),
              SizedBox(width: 10.w),
              Text(
                'From Nashik City',
                style: GoogleFonts.montserrat(fontSize: 16.sp, fontWeight: FontWeight.w600, color: _contentTitleColor),
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
            'Distance: ~25 km (40-50 mins drive)',
            style: TextStyle(fontSize: 14.sp, color: _contentTextColor, fontFamily: 'Roboto'),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportButtons() {
    final options = [
      {'icon': Icons.local_taxi, 'label': 'Auto', 'color': const Color(0xFFEAB308), 'bg': const Color(0xFFFEF9C3)},
      {'icon': Icons.directions_bike, 'label': 'Self Drive', 'color': const Color(0xFF9333EA), 'bg': const Color(0xFFEDE9FE)},
      {'icon': Icons.car_rental, 'label': 'Private Cab', 'color': const Color(0xFF3B82F6), 'bg': const Color(0xFFDBEAFE)},
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
                ),
                child: Column(
                  children: [
                    Icon(o['icon'] as IconData, size: 28.sp, color: o['color'] as Color),
                    SizedBox(height: 8.h),
                    Text(
                      o['label'] as String,
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: _contentTitleColor, fontFamily: 'Roboto'),
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

  Widget _buildFacilitiesGrid() {
    final items = [
      {'icon': Icons.restaurant, 'title': 'Dining', 'subtitle': "Dhaba's Near Temple", 'color': const Color(0xFF16A34A), 'bg': const Color(0xFFD1FAE5)},
      {'icon': Icons.hotel, 'title': 'Stays', 'subtitle': 'Luxury & nearby options', 'color': const Color(0xFF3B82F6), 'bg': const Color(0xFFDBEAFE)},
      {'icon': Icons.shopping_bag_outlined, 'title': 'Shop', 'subtitle': 'Local souvenirs', 'color': const Color(0xFFEC4899), 'bg': const Color(0xFFFCE7F3)},
      {'icon': Icons.local_parking, 'title': 'Parking', 'subtitle': 'Available on site', 'color': const Color(0xFFEAB308), 'bg': const Color(0xFFFEF9C3)},
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
                style: GoogleFonts.montserrat(fontSize: 15.sp, fontWeight: FontWeight.w600, color: _contentTitleColor),
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

  Widget _buildThingsToDoGrid() {
    final items = [
      {'icon': Icons.directions_walk, 'title': 'Morning Walks', 'subtitle': 'Scenic paths along the river', 'color': const Color(0xFF16A34A), 'bg': const Color(0xFFD1FAE5)},
      {'icon': Icons.camera_alt, 'title': 'Photography', 'subtitle': 'Instagram-worthy shots', 'color': const Color(0xFF9333EA), 'bg': const Color(0xFFEDE9FE)},
      {'icon': Icons.self_improvement, 'title': 'Meditation', 'subtitle': 'Peaceful spots for relaxation', 'color': const Color(0xFF3B82F6), 'bg': const Color(0xFFDBEAFE)},
      {'icon': Icons.groups, 'title': 'Family Time', 'subtitle': 'Picnics & quality moments', 'color': _orange, 'bg': const Color(0xFFFFEDD5)},
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
                style: GoogleFonts.montserrat(fontSize: 15.sp, fontWeight: FontWeight.w600, color: _contentTitleColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),
              Text(
                e['subtitle'] as String,
                style: TextStyle(fontSize: 12.sp, color: _contentTextColor, fontFamily: 'Roboto'),
                textAlign: TextAlign.center,
                maxLines: 2,
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
      {'title': 'Godavari Ghats', 'desc': 'River Godavari AKA Dakshin Ganga', 'distance': '8 km away', 'image': 'assets/png/trambak.png'},
      {'title': 'Someshwar Temple', 'desc': 'Ancient Shiva temple', 'distance': '5 km away', 'image': 'assets/png/trambak.png'},
      {'title': 'Nashik Darshan Park', 'desc': 'Family park with gardens', 'distance': '3 km away', 'image': 'assets/png/trambak.png'},
    ];
    return Column(
      children: nearby.map((e) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: _contentCardBg,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: _contentBorder),
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
                  errorBuilder: (_, __, ___) => Container(width: 80.w, height: 80.w, color: _contentBorder, child: Icon(Icons.image, color: _contentSubdued)),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e['title'] as String,
                      style: GoogleFonts.montserrat(fontSize: 16.sp, fontWeight: FontWeight.w600, color: _contentTitleColor),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      e['desc'] as String,
                      style: TextStyle(fontSize: 13.sp, color: _contentSubdued, fontFamily: 'Roboto'),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14.sp, color: _orange),
                        SizedBox(width: 4.w),
                        Text(e['distance'] as String, style: TextStyle(fontSize: 12.sp, color: _contentSubdued, fontFamily: 'Roboto')),
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
      {'title': 'Someshwar Garden', 'desc': 'Riverside garden & walks', 'distance': '25 km from Nashik', 'rating': 4.6, 'image': 'assets/png/trambak.png'},
      {'title': 'Nashik Darshan Park', 'desc': 'Family park with activities', 'distance': '3 km from Nashik', 'rating': 4.4, 'image': 'assets/png/trambak.png'},
    ];
    return Column(
      children: items.map((e) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: _contentBorder),
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
                  errorBuilder: (_, __, ___) => Container(height: 140.h, color: _contentBorder),
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
                            style: GoogleFonts.montserrat(fontSize: 16.sp, fontWeight: FontWeight.w600, color: _contentTitleColor),
                          ),
                        ),
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
                          style: TextStyle(fontSize: 12.sp, color: _contentSubdued, fontFamily: 'Roboto'),
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

  Widget _buildChecklistCard() {
    final items = [
      {'icon': Icons.directions_walk, 'label': 'Comfortable footwear', 'color': const Color(0xFF16A34A)},
      {'icon': Icons.water_drop_outlined, 'label': 'Water Bottle', 'color': const Color(0xFF0EA5E9)},
      {'icon': Icons.restaurant, 'label': 'Snacks', 'color': _orange},
      {'icon': Icons.medical_services_outlined, 'label': 'First Aid', 'color': const Color(0xFFEF4444)},
      {'icon': Icons.camera_alt, 'label': 'Camera', 'color': const Color(0xFF9333EA)},
      {'icon': Icons.wb_sunny_outlined, 'label': 'Sunscreen', 'color': const Color(0xFFEAB308)},
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
        crossAxisCount: 3,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 0.9,
        children: items.map((e) {
          final color = e['color'] as Color;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(e['icon'] as IconData, size: 24.sp, color: color),
              ),
              SizedBox(height: 8.h),
              Text(
                e['label'] as String,
                style: TextStyle(fontSize: 11.sp, color: _contentTitleColor, fontFamily: 'Roboto'),
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
        _buildVisitorCard(Icons.confirmation_num, 'Entry Fee', 'Free entry - No parking charges', const Color(0xFF16A34A)),
        SizedBox(height: 12.h),
        Container(
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
                  Icon(Icons.warning_amber_rounded, size: 28.sp, color: _orange),
                  SizedBox(width: 14.w),
                  Text('Safety Tips', style: GoogleFonts.montserrat(fontSize: 15.sp, fontWeight: FontWeight.w600, color: _contentTitleColor)),
                ],
              ),
              SizedBox(height: 12.h),
              _bullet('Keep children supervised near water'),
              SizedBox(height: 6.h),
              _bullet('Carry first-aid kit'),
              SizedBox(height: 6.h),
              _bullet('Stay in designated picnic areas'),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        _buildVisitorCard(Icons.restaurant, 'Facilities', 'Food stalls • Restrooms • Parking', const Color(0xFF3B82F6)),
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
                Text(title, style: GoogleFonts.montserrat(fontSize: 15.sp, fontWeight: FontWeight.w600, color: _contentTitleColor)),
                Text(detail, style: TextStyle(fontSize: 13.sp, color: _contentSubdued, fontFamily: 'Roboto')),
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
                Text('4.6', style: GoogleFonts.montserrat(fontSize: 18.sp, fontWeight: FontWeight.w700, color: _contentTitleColor)),
                SizedBox(width: 8.w),
                ...List.generate(5, (_) => Icon(Icons.star, size: 24.sp, color: const Color(0xFFFBBF24))),
              ],
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildReviewSnippet('Amazing Wine Tasting experience!', 'Rahul M.', const Color(0xFF16A34A)),
        SizedBox(height: 12.h),
        _buildReviewSnippet('Perfect for a family weekend. Kids loved the park.', 'Priya S.', _orange),
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
                    style: GoogleFonts.montserrat(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white),
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
                  Text(author, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: _contentTitleColor, fontFamily: 'Roboto')),
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
            child: Icon(Icons.eco, size: 44.sp, color: const Color(0xFF16A34A)),
          ),
        ),
        SizedBox(height: 16.h),
        Center(
          child: Text(
            'Leave No Trace',
            style: GoogleFonts.montserrat(fontSize: 18.sp, fontWeight: FontWeight.w700, color: _contentTitleColor),
          ),
        ),
        SizedBox(height: 12.h),
        Center(
          child: Text(
            'Help preserve this place for future generations. Take only memories, leave only footprints.',
            style: TextStyle(fontSize: 14.sp, color: _contentTextColor, height: 1.5, fontFamily: 'Roboto'),
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
              side: BorderSide(color: _contentBorder),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              backgroundColor: Colors.white,
            ),
            child: Text(
              'Support Local Communities',
              style: GoogleFonts.montserrat(fontSize: 15.sp, fontWeight: FontWeight.w600, color: _contentTitleColor),
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
