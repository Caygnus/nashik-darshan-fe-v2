import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/place.dart';

/// Culture Place Detail Template
/// Template for displaying cultural places with comprehensive details
class CulturePlaceDetailTemplate extends StatefulWidget {
  final Place place;

  const CulturePlaceDetailTemplate({
    super.key,
    required this.place,
  });

  @override
  State<CulturePlaceDetailTemplate> createState() => _CulturePlaceDetailTemplateState();
}

class _CulturePlaceDetailTemplateState extends State<CulturePlaceDetailTemplate> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _navScrollController = ScrollController();
  final ScrollController _nearbyPlacesScrollController = ScrollController();
  int _activeSectionIndex = 0;
  bool _showStickyNav = false;
  final Map<int, GlobalKey> _sectionKeys = {};
  bool _isScrollingToSection = false;

  final List<String> _sections = [
    'About Goda Park',
    'How To Reach',
    'Things',
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _sections.length; i++) {
      _sectionKeys[i] = GlobalKey();
    }
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _onScroll();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _navScrollController.dispose();
    _nearbyPlacesScrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    
    final scrollOffset = _scrollController.offset;
    final imageSectionHeight = 350.h;
    final overlapHeight = 20.h;
    final navBarHeight = 61.h;
    
    final shouldShowNav = scrollOffset > (imageSectionHeight - overlapHeight - navBarHeight);
    
    if (_showStickyNav != shouldShowNav) {
      setState(() {
        _showStickyNav = shouldShowNav;
      });
    }
    
    final threshold = 61.0;
    
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
      setState(() {
        _activeSectionIndex = newActiveIndex!;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollNavToActiveTab(newActiveIndex!);
      });
    }
  }

  void _scrollNavToActiveTab(int index) {
    if (!_navScrollController.hasClients) return;
    
    final estimatedTabWidth = 110.0;
    final estimatedSpacing = 8.0;
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
      
      setState(() {
        _activeSectionIndex = index;
      });
      
      final stickyNavHeight = 61.0;
      
      if (!_showStickyNav) {
        setState(() {
          _showStickyNav = true;
        });
      }
      
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
                  if (mounted) {
                    setState(() {
                      _isScrollingToSection = false;
                    });
                  }
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
            if (_scrollController.hasClients && _showStickyNav) {
              Future.delayed(const Duration(milliseconds: 100), () {
                if (_scrollController.hasClients && mounted) {
                  final currentOffset = _scrollController.offset;
                  final adjustedOffset = currentOffset + stickyNavHeight;
                  _scrollController.animateTo(
                    adjustedOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  ).then((_) {
                    Future.delayed(const Duration(milliseconds: 200), () {
                      if (mounted) {
                        setState(() {
                          _isScrollingToSection = false;
                        });
                      }
                    });
                  });
                } else {
                  if (mounted) {
                    setState(() {
                      _isScrollingToSection = false;
                    });
                  }
                }
              });
            } else {
              Future.delayed(const Duration(milliseconds: 400), () {
                if (mounted) {
                  setState(() {
                    _isScrollingToSection = false;
                  });
                }
              });
            }
          });
        } else {
          if (mounted) {
            setState(() {
              _isScrollingToSection = false;
            });
          }
        }
      });
      
      _scrollNavToActiveTab(index);
    }
  }

  TextStyle _getTextStyle({
    required double fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    return GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Extract place name and get Devanagari name
    final placeName = widget.place.name;
    final devanagariName = (widget.place.additionalInfo?['devanagari'] as String?) ?? 'गोदा पार्क';
    final subtitle = (widget.place.additionalInfo?['subtitle'] as String?) ?? 'Family and Riverside View - Nashik, Maharashtra';
    
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeroSection(devanagariName, placeName, subtitle),
              Transform.translate(
                offset: Offset(0, -20.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
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
                            controller: _navScrollController,
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
                        Container(height: 1.h, color: const Color(0xFFE5E7EB)),
                        SizedBox(height: 24.h),
                        Column(
                          key: _sectionKeys[0],
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAboutSection(),
                          ],
                        ),
                        SizedBox(height: 32.h),
                        Column(
                          key: _sectionKeys[1],
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHowToReachSection(),
                          ],
                        ),
                        SizedBox(height: 32.h),
                        Column(
                          key: _sectionKeys[2],
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildThingsToDoSection(),
                            SizedBox(height: 32.h),
                            _buildExploreNearbySection(),
                            SizedBox(height: 32.h),
                            _buildYouMightAlsoLikeSection(),
                            SizedBox(height: 32.h),
                            _buildAdventureChecklistSection(),
                            SizedBox(height: 32.h),
                            _buildVisitorInformationSection(),
                            SizedBox(height: 32.h),
                            _buildLeaveNoTraceSection(),
                          ],
                        ),
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

  Widget _buildHeroSection(String devanagariName, String englishName, String subtitle) {
    return Container(
      width: double.infinity,
      height: 350.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            widget.place.imageUrls.isNotEmpty
                ? widget.place.imageUrls.first
                : 'assets/png/trambak.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.2),
                  Colors.black.withValues(alpha: 0.5),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 40.h,
            left: 20.w,
            right: 20.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  devanagariName,
                  style: _getTextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  englishName,
                  style: _getTextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  subtitle,
                  style: _getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF8A02),
                    borderRadius: BorderRadius.circular(9999.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.family_restroom, color: Colors.white, size: 16.sp),
                      SizedBox(width: 6.w),
                      Text(
                        'Family',
                        style: _getTextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 16.h,
            right: 16.w,
            child: Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: const Color(0xFFFF8A02),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.headphones, color: Colors.white, size: 24.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTab(String title, bool isActive, int index) {
    return Container(
      child: InkWell(
        onTap: () {
          _scrollToSection(index);
        },
        borderRadius: BorderRadius.circular(9999.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFFFF8A02)
                : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(9999.r),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: _getTextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? Colors.white
                    : const Color(0xFF374151),
              ),
              textAlign: TextAlign.center,
            ),
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
              height: 44.h,
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
            Container(
              height: 1.h,
              color: const Color(0xFFE5E7EB),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About ${widget.place.name}',
          style: _getTextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          widget.place.description.isNotEmpty
              ? widget.place.description
              : 'Goda Park is a serene riverside haven nestled along the banks of the sacred Godavari river. This peaceful green space offers breathtaking river views, well-maintained walking paths, and tranquil spots perfect for meditation & relaxation.',
          style: _getTextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6B7280),
            height: 1.5,
          ),
        ),
        SizedBox(height: 20.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFF10B981), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today, color: const Color(0xFF10B981), size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Best Time to Visit',
                    style: _getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              _buildBestTimeItem(
                'Morning & Evening',
                'Best for peaceful walks and stunning sunset views over the Godavari',
              ),
              SizedBox(height: 12.h),
              _buildBestTimeItem(
                'Monsoon Season',
                'Lush greenery and the river at its most majestic',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBestTimeItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: _getTextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          description,
          style: _getTextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6B7280),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildHowToReachSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How To Reach',
          style: _getTextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: const Color(0xFFEF4444), size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'From Nashik City',
                    style: _getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                'Route: Nashik - Pahine',
                style: _getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Distance: ~25 km (40-50 mins drive)',
                style: _getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            _buildTransportOption(Icons.directions_car, 'Auto', const Color(0xFFFBBF24)),
            SizedBox(width: 12.w),
            _buildTransportOption(Icons.two_wheeler, 'Self Drive', const Color(0xFF8B5CF6)),
            SizedBox(width: 12.w),
            _buildTransportOption(Icons.local_taxi, 'Private Cab', const Color(0xFF3B82F6)),
          ],
        ),
      ],
    );
  }

  Widget _buildTransportOption(IconData icon, String label, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24.sp),
            SizedBox(height: 4.h),
            Text(
              label,
              style: _getTextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThingsToDoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Things to Do',
          style: _getTextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildActivityCard(
                Icons.directions_walk,
                'Morning Walks',
                'Scenic paths along the river',
                const Color(0xFF10B981),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildActivityCard(
                Icons.camera_alt,
                'Photography',
                'Instagram-worthy shots',
                const Color(0xFF8B5CF6),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildActivityCard(
                Icons.self_improvement,
                'Meditation',
                'Peaceful spots for relaxation',
                const Color(0xFF3B82F6),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildActivityCard(
                Icons.family_restroom,
                'Family Time',
                'Picnics & quality moments',
                const Color(0xFFFF8A02),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityCard(IconData icon, String title, String description, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: _getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            description,
            style: _getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6B7280),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExploreNearbySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explore Nearby',
          style: _getTextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 16.h),
        _buildNearbyPlaceCard(
          'Godavari Ghats',
          'River Godavari AKA Dakshin g',
          '8 km away',
        ),
        SizedBox(height: 12.h),
        _buildNearbyPlaceCard(
          'Panchvati',
          'Where Lord Rama Stayed',
          '12 km away',
        ),
        SizedBox(height: 12.h),
        _buildNearbyPlaceCard(
          'Kalaram mandir',
          'Idol of Lord rama in Black Stone',
          '15 km away',
        ),
      ],
    );
  }

  Widget _buildNearbyPlaceCard(String name, String description, String distance) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.asset(
              'assets/png/trambak.png',
              width: 80.w,
              height: 80.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80.w,
                height: 80.h,
                color: const Color(0xFFF3F4F6),
                child: Icon(Icons.image, size: 32.sp),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: _getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: _getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B7280),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14.sp, color: const Color(0xFF9CA3AF)),
                    SizedBox(width: 4.w),
                    Text(
                      distance,
                      style: _getTextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B7280),
                      ),
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

  Widget _buildYouMightAlsoLikeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You Might Also Like',
          style: _getTextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 16.h),
        _buildRecommendationCard(
          'Somehshwar Garden',
          'Popular monsoon destination',
          '25 km From Nashik',
          4.6,
        ),
        SizedBox(height: 12.h),
        _buildRecommendationCard(
          'Pandit Nehru Udyan',
          'Adventure & rappelling hub',
          '35 km from Nashik',
          4.4,
        ),
      ],
    );
  }

  Widget _buildRecommendationCard(String name, String description, String distance, double rating) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
            ),
            child: Image.asset(
              'assets/png/trambak.png',
              width: double.infinity,
              height: 160.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 160.h,
                color: const Color(0xFFF3F4F6),
                child: Icon(Icons.image, size: 40.sp),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: _getTextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  description,
                  style: _getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B7280),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14.sp, color: const Color(0xFF9CA3AF)),
                        SizedBox(width: 4.w),
                        Text(
                          distance,
                          style: _getTextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < rating.toInt()
                                ? Icons.star
                                : Icons.star_border,
                            size: 16.sp,
                            color: const Color(0xFFFBBF24),
                          );
                        }),
                        SizedBox(width: 4.w),
                        Text(
                          '$rating',
                          style: _getTextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
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

  Widget _buildAdventureChecklistSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Adventure Checklist',
          style: _getTextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: [
            _buildChecklistItem(Icons.shopping_bag, 'Comfortable walking footwear', const Color(0xFF10B981)),
            _buildChecklistItem(Icons.water_drop, 'Water Bottle', const Color(0xFF3B82F6)),
            _buildChecklistItem(Icons.fastfood, 'Snacks', const Color(0xFFFF8A02)),
            _buildChecklistItem(Icons.medical_services, 'First Aid', const Color(0xFFEF4444)),
            _buildChecklistItem(Icons.camera_alt, 'Camera', const Color(0xFF8B5CF6)),
          ],
        ),
      ],
    );
  }

  Widget _buildChecklistItem(IconData icon, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20.sp),
          SizedBox(width: 8.w),
          Text(
            text,
            style: _getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitorInformationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Visitor Information',
          style: _getTextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFF10B981), width: 1.5),
          ),
          child: Row(
            children: [
              Icon(Icons.account_balance_wallet, color: const Color(0xFF10B981), size: 24.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Entry Fee: Free entry - No parking charges',
                  style: _getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFFF8A02).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFFF8A02), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning, color: const Color(0xFFFF8A02), size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Safety Tips',
                    style: _getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              _buildSafetyTip('Watch for slippery rocks during monsoon'),
              SizedBox(height: 8.h),
              _buildSafetyTip('Follow park rules and timings'),
              SizedBox(height: 8.h),
              _buildSafetyTip('Cap or sunglasses for sun protection'),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFF3B82F6), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.local_offer, color: const Color(0xFF3B82F6), size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Facilities',
                    style: _getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                'Local food stalls - Parking available - Local guides on request',
                style: _getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSafetyTip(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 6.h),
          width: 6.w,
          height: 6.h,
          decoration: const BoxDecoration(
            color: Color(0xFFFF8A02),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: _getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1F2937),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaveNoTraceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF10B981).withValues(alpha: 0.1),
                const Color(0xFF10B981).withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFF10B981), width: 1.5),
          ),
          child: Column(
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.eco, color: const Color(0xFF10B981), size: 32.sp),
              ),
              SizedBox(height: 16.h),
              Text(
                'Leave No Trace',
                style: _getTextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Help preserve this natural wonder for future generations. Take only memories, leave only footprints.',
                style: _getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Support Local Communities',
                    style: _getTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Choose local homestays - Buy from local vendors',
                style: _getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
