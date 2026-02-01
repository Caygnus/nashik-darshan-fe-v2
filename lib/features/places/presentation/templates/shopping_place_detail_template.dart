import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/place.dart';

/// Shopping Place Detail Template
/// Matches design: transparent app bar over hero, purple Shopping tag,
/// tabs (About, How To Reach, Stores), sections for Stores & Shopping,
/// You Might Also Like, Visitor Checklist, Visitor Information, Leave No Trace.
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
  final ScrollController _scrollController = ScrollController();
  final ScrollController _navScrollController = ScrollController();
  int _activeSectionIndex = 0;
  bool _showStickyNav = false;
  bool _isScrollingToSection = false;
  final Map<int, GlobalKey> _sectionKeys = {};

  List<String> get _sections => [
        'About $_shortName',
        'How to Reach',
        'Stores & Shopping',
        'You Might Also Like',
        'Visitor Checklist',
        'Visitor Information',
        'Leave No Trace',
      ];

  String get _shortName {
    final name = widget.place.name;
    if (name.toLowerCase().contains('city centre') || name.toLowerCase().contains('city center')) return 'CCM';
    return name.replaceAll(' Mall', '').replaceAll(' Shopping', '');
  }

  String get _marathiName =>
      widget.place.additionalInfo?['marathiName'] as String? ?? 'नाशिक सिटी सेंटर मॉल';
  String get _subtitle =>
      widget.place.additionalInfo?['subtitle'] as String? ?? 'Family and Shopping · Nashik, Maharashtra';

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
      });
      _scrollNavToActiveTab(index);
    }
  }

  static const Color _contentTitleColor = Color(0xFF1F2937);
  static const Color _contentTextColor = Color(0xFF4B5563);
  static const Color _contentCardBg = Color(0xFFF5F5F5);
  static const Color _contentBorder = Color(0xFFE5E7EB);
  static const Color _contentSubdued = Color(0xFF6B7280);
  static const Color _orange = Color(0xFFFF994D);
  static const Color _shoppingPurple = Color(0xFF8F00FF);

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
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 12.h,
          bottom: 8.h,
        ),
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
            _buildPeakHoursAndCrowdCards(),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Stores & Shopping'),
            _buildStoresGrid(),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('You Might Also Like'),
            _buildYouMightAlsoLikeCards(),
          ],
        );
      case 4:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Visitor Checklist'),
            _buildVisitorChecklistCard(),
          ],
        );
      case 5:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Visitor Information'),
            _buildVisitorInfoCards(),
          ],
        );
      case 6:
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
    final imageUrl =
        widget.place.imageUrls.isNotEmpty ? widget.place.imageUrls.first : 'assets/png/trambak.png';
    return Stack(
      children: [
        // Image section - 400.h to match spiritual
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
        // Headphone icon - 48x48, gradient, border (image section starts below page app bar)
        Positioned(
          top: 16.h,
          right: 16.w,
          child: Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFF974D), Color(0xFFFFB047)],
              ),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
            ),
            child: IconButton(
              icon: const Icon(Icons.headphones, color: Colors.white, size: 24),
              onPressed: () {},
              padding: EdgeInsets.zero,
              style: IconButton.styleFrom(
                minimumSize: Size(48.w, 48.h),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
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
        _buildVisitorInfoCard(
          icon: Icons.confirmation_num_outlined,
          title: 'Entry Fee',
          content: 'Free entry · No parking charges',
          color: const Color(0xFF16A34A),
        ),
        SizedBox(height: 12.h),
        _buildVisitorInfoCardSafetyTips(),
        SizedBox(height: 12.h),
        _buildVisitorInfoCard(
          icon: Icons.restaurant_outlined,
          title: 'Facilities',
          content: 'Local food stalls · Parking available · Local guides on request',
          color: const Color(0xFF3B82F6),
        ),
      ],
    );
  }

  /// White card with rounded corners and subtle shadow (matches image).
  Widget _buildVisitorInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _contentBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: _contentTitleColor,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: _contentSubdued,
                    height: 1.4,
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

  /// Safety Tips card with bullet list using middle dots (·).
  Widget _buildVisitorInfoCardSafetyTips() {
    const bullet = '· ';
    final tips = [
      'Watch for slippery rocks during monsoon',
      'Follow park rules and timings',
      'Cap or sunglasses for sun protection',
    ];
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _contentBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, size: 28.sp, color: _orange),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Safety Tips',
                  style: GoogleFonts.montserrat(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: _contentTitleColor,
                  ),
                ),
                SizedBox(height: 10.h),
                ...tips.map(
                  (tip) => Padding(
                    padding: EdgeInsets.only(bottom: 6.h),
                    child: Text(
                      '$bullet$tip',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: _contentSubdued,
                        height: 1.4,
                        fontFamily: 'Roboto',
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
