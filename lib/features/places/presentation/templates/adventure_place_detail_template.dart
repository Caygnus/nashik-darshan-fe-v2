import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/place.dart';

/// Adventure Place Detail Template
/// Template for displaying adventure places with comprehensive details
class AdventurePlaceDetailTemplate extends StatefulWidget {
  final Place place;

  const AdventurePlaceDetailTemplate({
    super.key,
    required this.place,
  });

  @override
  State<AdventurePlaceDetailTemplate> createState() => _AdventurePlaceDetailTemplateState();
}

class _AdventurePlaceDetailTemplateState extends State<AdventurePlaceDetailTemplate> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _navScrollController = ScrollController();
  final ScrollController _nearbyPlacesScrollController = ScrollController();
  int _activeSectionIndex = 0;
  bool _showStickyNav = false;
  final Map<int, GlobalKey> _sectionKeys = {};
  bool _isScrollingToSection = false;

  final List<String> _sections = [
    'About Parvat',
    'How to reach',
    'Tourist Facilities',
    'Spiritual Significance',
    'Explore More',
    'Plans',
    'Nearby Sacred Places',
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _sections.length; i++) {
      _sectionKeys[i] = GlobalKey();
    }
    _scrollController.addListener(_onScroll);
    // Set initial active section after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _onScroll(); // Initial scroll detection
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
    final imageSectionHeight = 350.h; // Image section height
    final overlapHeight = 20.h; // Overlap amount
    final navBarHeight = 61.h; // Navigation bar height (44 + 12 top + 8 spacing + 1 HR + 8 bottom)
    
    // Show sticky nav when scrolled past image section
    final shouldShowNav = scrollOffset > (imageSectionHeight - overlapHeight - navBarHeight);
    
    if (_showStickyNav != shouldShowNav) {
      setState(() {
        _showStickyNav = shouldShowNav;
      });
    }
    
    // Find which section is currently in view
    // Threshold accounts for sticky navigation bar (approximately 61px from top)
    final threshold = 61.0;
    
    int? newActiveIndex;
    double minDistance = double.infinity;
    
    for (int i = 0; i < _sections.length; i++) {
      final key = _sectionKeys[i];
      if (key?.currentContext != null) {
        final RenderBox? renderBox = key?.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          // Get position relative to the scrollable viewport
          final position = renderBox.localToGlobal(Offset.zero);
          final sectionTop = position.dy;
          final sectionBottom = sectionTop + renderBox.size.height;
          
          // Check if section is in the threshold area (below sticky nav)
          if (sectionTop <= threshold && sectionBottom >= threshold) {
            newActiveIndex = i;
            break;
          }
          
          // Track closest section to threshold
          final distance = (sectionTop - threshold).abs();
          if (distance < minDistance) {
            minDistance = distance;
            newActiveIndex = i;
          }
        }
      }
    }
    
    // Only update active index if not manually scrolling to a section
    if (!_isScrollingToSection && newActiveIndex != null && _activeSectionIndex != newActiveIndex) {
      setState(() {
        _activeSectionIndex = newActiveIndex!;
      });
      // Auto-scroll navigation bar to show active tab
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollNavToActiveTab(newActiveIndex!);
      });
    }
  }

  void _scrollNavToActiveTab(int index) {
    if (!_navScrollController.hasClients) return;
    
    // Simplified scroll - estimate tab width and scroll to approximate position
    // Average tab width is approximately 100-120 pixels, with 8px spacing
    final estimatedTabWidth = 110.0;
    final estimatedSpacing = 8.0;
    final estimatedTabLeft = index * (estimatedTabWidth + estimatedSpacing);
    
    final navPosition = _navScrollController.position;
    final navViewportWidth = navPosition.viewportDimension;
    
    // Scroll to center the active tab
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
      // Set flag to prevent scroll detection from overriding
      _isScrollingToSection = true;
      
      // Update active section index first
      setState(() {
        _activeSectionIndex = index;
      });
      
      // Calculate sticky nav bar height: ~61.h (12.h top + 44.h nav + 8.h spacing + 1.h HR + 8.h bottom)
      final stickyNavHeight = 61.0;
      
      // Also ensure sticky nav is shown when scrolling to a section
      if (!_showStickyNav) {
        setState(() {
          _showStickyNav = true;
        });
      }
      
      // Wait a frame to ensure sticky nav is rendered, then scroll
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = key?.currentContext;
        if (context != null && _scrollController.hasClients) {
          final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            // Get the scrollable's render box
            final scrollable = Scrollable.of(context);
            final scrollablePosition = scrollable.position;
            final scrollableRenderObject = scrollablePosition.context.storageContext.findRenderObject();
            if (scrollableRenderObject != null) {
              final scrollableBox = scrollableRenderObject as RenderBox;
              
              // Get section position relative to scrollable
              final sectionTop = renderBox.localToGlobal(Offset.zero, ancestor: scrollableBox).dy;
              
              // Calculate target scroll offset: section position minus sticky nav height
              final currentScrollOffset = scrollablePosition.pixels;
              final sectionAbsolutePosition = currentScrollOffset + sectionTop;
              final targetOffset = sectionAbsolutePosition - stickyNavHeight;
              
              // Animate to target position
              scrollablePosition.animateTo(
                targetOffset.clamp(0.0, scrollablePosition.maxScrollExtent),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ).then((_) {
                // Reset flag after scrolling completes
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
        
        // Fallback: Use ensureVisible if calculation fails
        if (key?.currentContext != null) {
          Scrollable.ensureVisible(
            key!.currentContext!,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: 0.0,
            alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
          ).then((_) {
            // Adjust for sticky nav after initial scroll
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
      
      // Scroll nav to show active tab
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
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeroSection(),
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
                            _buildTouristFacilitiesSection(),
                          ],
                        ),
                        SizedBox(height: 32.h),
                        Column(
                          key: _sectionKeys[3],
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSpiritualSignificanceSection(),
                          ],
                        ),
                        SizedBox(height: 32.h),
                        Column(
                          key: _sectionKeys[4],
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildExploreMoreSection(),
                          ],
                        ),
                        SizedBox(height: 32.h),
                        Column(
                          key: _sectionKeys[5],
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPlansSection(),
                          ],
                        ),
                        SizedBox(height: 32.h),
                        Column(
                          key: _sectionKeys[6],
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildNearbySacredPlacesSection(),
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

  Widget _buildHeroSection() {
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
                Row(
                  children: [
                    Text(
                      'ॐ',
                      style: _getTextStyle(
                        fontSize: 48.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ब्रह्मगिरी पर्वत',
                            style: _getTextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            widget.place.name,
                            style: _getTextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  'First peak of Sahyadri - Nashik, Maharashtra.',
                  style: _getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
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
          Positioned(
            bottom: 20.h,
            right: 20.w,
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16.sp),
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
                ? const Color(0xFFFF8A02) // Active: #FF8A02
                : const Color(0xFFF3F4F6), // Inactive: #F3F4F6
            borderRadius: BorderRadius.circular(9999.r),
            border: Border.all(
              color: const Color(0xFFE5E7EB), // Stroke E5E7EB
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: _getTextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500, // Medium
                color: isActive
                    ? Colors.white // Active: white
                    : const Color(0xFF374151), // Inactive: #374151
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
            // Horizontal Navigation Section
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
            // HR Line
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
          'About Bramhagiri',
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
              : 'Bramhagiri Hills offers an incredible blend of adventure and spirituality. Trek through scenic trails to reach the birthplace of the sacred Godavari River, where panoramic views and ancient temples await.',
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
            color: const Color(0xFFFF8A02).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFFF8A02), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: const Color(0xFFFF8A02), size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Spiritual Significance',
                    style: _getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                'Origin of Godavari, sacred temples, mythological importance.',
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
        SizedBox(height: 12.h),
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
                  Icon(Icons.eco, color: const Color(0xFF10B981), size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Adventure Appeal',
                    style: _getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                'Trekking trails, panoramic views, natural beauty.',
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

  Widget _buildHowToReachSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How to Reach',
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
                'Route: Nashik → Trimbak → Bramhagiri Base',
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
            _buildTransportOption(Icons.local_taxi, 'Private Cab', const Color(0xFF3B82F6)),
            SizedBox(width: 12.w),
            _buildTransportOption(Icons.directions_bus, 'Local Bus', const Color(0xFF10B981)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFF10B981), width: 1.5),
                ),
                child: Column(
                  children: [
                    Icon(Icons.wb_sunny, color: const Color(0xFF10B981), size: 32.sp),
                    SizedBox(height: 8.h),
                    Text(
                      'Best Time',
                      style: _getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Early morning, Winter months',
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
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFF3B82F6), width: 1.5),
                ),
                child: Column(
                  children: [
                    Icon(Icons.trending_up, color: const Color(0xFF3B82F6), size: 32.sp),
                    SizedBox(height: 8.h),
                    Text(
                      'Difficulty',
                      style: _getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Moderate trek',
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
            ),
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

  Widget _buildTouristFacilitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tourist Facilities',
          style: _getTextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 16.h),
        _buildFacilityCard(Icons.hotel, 'Accommodation', 'Budget & mid-range hotels nearby.'),
        SizedBox(height: 12.h),
        _buildFacilityCard(Icons.restaurant, 'Food & Dining', 'Food courts & local eateries at Trimbak.'),
        SizedBox(height: 12.h),
        _buildFacilityCard(Icons.local_parking, 'Parking', 'Available at base area.'),
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
              _buildSafetyTip('Wear proper trekking shoes'),
              SizedBox(height: 8.h),
              _buildSafetyTip('Carry sufficient water'),
              SizedBox(height: 8.h),
              _buildSafetyTip('Avoid during monsoon season'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFacilityCard(IconData icon, String title, String description) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: const Color(0xFF6B7280), size: 24.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
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
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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

  Widget _buildSpiritualSignificanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Spiritual Significance',
          style: _getTextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 16.h),
        _buildSpiritualCard(
          Icons.water_drop,
          'Sacred Godavari Origin',
          'The holy Godavari River originates from this hill, making it sacred for Hindus across India.',
          const Color(0xFF3B82F6),
        ),
        SizedBox(height: 12.h),
        _buildSpiritualCard(
          Icons.temple_buddhist,
          'Hilltop Temples',
          'Ancient temples atop the hill offer spiritual solace and breathtaking views.',
          const Color(0xFFFF8A02),
        ),
        SizedBox(height: 12.h),
        _buildSpiritualCard(
          Icons.auto_awesome,
          'Trimbakeshwar Circuit',
          'Part of the sacred Trimbakeshwar pilgrimage circuit.',
          const Color(0xFF8B5CF6),
        ),
      ],
    );
  }

  Widget _buildSpiritualCard(IconData icon, String title, String description, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
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
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExploreMoreSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explore More',
          style: _getTextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 16.h),
        // Video Thumbnail
        Container(
          width: double.infinity,
          height: 200.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: const Color(0xFF1F2937),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  'assets/png/trambak.png',
                  width: double.infinity,
                  height: 200.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFF1F2937),
                    child: Icon(Icons.play_circle_filled, size: 60.sp, color: Colors.white),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.play_arrow, size: 32.sp, color: const Color(0xFF1F2937)),
                ),
              ),
              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    '1M+ VIEWS',
                    style: _getTextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12.h,
                left: 12.w,
                right: 12.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AKAAL MRITYU KE BAAD...',
                      style: _getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 12.h,
                right: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    '01:07',
                    style: _getTextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        // Image Gallery
        SizedBox(
          height: 80.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: index < 4 ? 8.w : 0),
                child: Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: const Color(0xFFF3F4F6),
                  ),
                  child: index == 4
                      ? Center(
                          child: Text(
                            'More Media',
                            style: _getTextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF6B7280),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.asset(
                            'assets/png/trambak.png',
                            width: 80.w,
                            height: 80.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: const Color(0xFFF3F4F6),
                              child: Icon(Icons.image, size: 24.sp, color: const Color(0xFF9CA3AF)),
                            ),
                          ),
                        ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlansSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plans',
          style: _getTextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 16.h),
        _buildPlanCard(
          image: 'assets/png/trambak.png',
          tag: 'SPIRITUAL',
          tagColor: const Color(0xFF8B5CF6),
          title: 'Pilgrimage Circuit Package',
          description: 'Trimbakeshwar + Brahmagiri + Anjaneri spiritual journey',
          details: ['2 Days', 'Max 12 people', 'Meals included'],
        ),
        SizedBox(height: 12.h),
        _buildPlanCard(
          image: 'assets/png/trambak.png',
          tag: 'COMPLETE',
          tagColor: const Color(0xFF10B981),
          title: 'All-in-One Nashik Journey',
          description: 'Complete spiritual + adventure experience covering all 4 destinations',
          details: ['4 Days', 'Accommodation', 'Transport'],
          isPopular: true,
        ),
      ],
    );
  }

  Widget _buildPlanCard({
    required String image,
    required String tag,
    required Color tagColor,
    required String title,
    required String description,
    required List<String> details,
    bool isPopular = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        color: Colors.white,
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
                  image,
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
              Positioned(
                top: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: tagColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    tag,
                    style: _getTextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (isPopular)
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBBF24),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      'MOST POPULAR',
                      style: _getTextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
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
                Wrap(
                  spacing: 16.w,
                  runSpacing: 8.h,
                  children: details.map((detail) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, size: 16.sp, color: const Color(0xFF10B981)),
                        SizedBox(width: 4.w),
                        Text(
                          detail,
                          style: _getTextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8A02),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Explore More',
                      style: _getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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

  Widget _buildNearbySacredPlacesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nearby Sacred Places',
          style: _getTextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'Holy Spots',
          style: _getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6B7280),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 200.h,
          child: ListView.builder(
            controller: _nearbyPlacesScrollController,
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            itemBuilder: (context, index) {
              final places = [
                {
                  'name': 'Kushavarta Kund',
                  'description': 'Sacred origin of River Godavari',
                  'distance': '2 min walk',
                  'icon': Icons.directions_walk,
                  'rating': 4.5,
                },
                {
                  'name': 'Anjaneri',
                  'description': 'Lord Hanuman\'s birthplace',
                  'distance': '20 min drive',
                  'icon': Icons.directions_car,
                  'rating': 4.8,
                },
              ];
              final place = places[index];
              return Padding(
                padding: EdgeInsets.only(right: index < 1 ? 12.w : 0),
                child: _buildNearbyPlaceCard(place),
              );
            },
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          'Recommended',
          style: _getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6B7280),
          ),
        ),
        SizedBox(height: 12.h),
        _buildRecommendedPlaceCard(
          'Pandavleni Caves',
          'Ancient Buddhist caves dating back to 3rd century BCE',
          'Start point, 1 hr visit',
          Icons.directions_walk,
        ),
        SizedBox(height: 12.h),
        _buildRecommendedPlaceCard(
          'Kalaram Temple',
          'Sacred temple dedicated to Lord Rama with black stone idol',
          '15 min drive - 45 min visit',
          Icons.directions_car,
        ),
        SizedBox(height: 12.h),
        _buildRecommendedPlaceCard(
          'Ramkund',
          'Holy bathing ghat on river Godavari',
          '10 min walk - 30 min visit',
          Icons.directions_walk,
        ),
      ],
    );
  }

  Widget _buildNearbyPlaceCard(Map<String, dynamic> place) {
    return Container(
      width: 167.w,
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
            ),
            child: Image.asset(
              'assets/png/trambak.png',
              width: double.infinity,
              height: 85.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 85.h,
                color: const Color(0xFFF3F4F6),
                child: Icon(Icons.image, size: 32.sp),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < (place['rating'] as num).toInt()
                              ? Icons.star
                              : Icons.star_border,
                          size: 9.sp,
                          color: const Color(0xFFFBBF24),
                        );
                      }),
                      SizedBox(width: 3.w),
                      Text(
                        '${place['rating']}',
                        style: _getTextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    place['name'] as String,
                    style: _getTextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3.h),
                  Flexible(
                    child: Text(
                      place['description'] as String,
                      style: _getTextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B7280),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(place['icon'] as IconData, size: 11.sp, color: const Color(0xFF9CA3AF)),
                      SizedBox(width: 3.w),
                      Flexible(
                        child: Text(
                          place['distance'] as String,
                          style: _getTextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF6B7280),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedPlaceCard(String name, String description, String details, IconData icon) {
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
                    Icon(icon, size: 14.sp, color: const Color(0xFF9CA3AF)),
                    SizedBox(width: 4.w),
                    Text(
                      details,
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
          Icon(Icons.arrow_forward_ios, size: 16.sp, color: const Color(0xFF9CA3AF)),
        ],
      ),
    );
  }

}
