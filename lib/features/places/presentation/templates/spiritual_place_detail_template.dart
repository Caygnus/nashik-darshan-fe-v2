import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../domain/entities/place.dart';

/// Spiritual Place Detail Template
/// Template for displaying spiritual places with custom design
class SpiritualPlaceDetailTemplate extends StatefulWidget {
  final Place place;

  const SpiritualPlaceDetailTemplate({
    super.key,
    required this.place,
  });

  @override
  State<SpiritualPlaceDetailTemplate> createState() => _SpiritualPlaceDetailTemplateState();
}

class _SpiritualPlaceDetailTemplateState extends State<SpiritualPlaceDetailTemplate> {
  final PageController _imagePageController = PageController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _navScrollController = ScrollController();
  final ScrollController _nearbyPlacesScrollController = ScrollController();
  int _activeSectionIndex = 0;
  bool _showStickyNav = false;
  final Map<int, GlobalKey> _sectionKeys = {};
  int _currentNearbyPage = 0;
  final int _totalNearbyCards = 4;
  bool _isScrollingToSection = false; // Flag to prevent scroll detection override
  
  // Countdown timer
  Timer? _countdownTimer;
  int _days = 0;
  int _hours = 0;
  int _seconds = 0;

  final List<String> _sections = [
    'About Temple',
    'Aarti Timings',
    'How to Reach',
    'Explore More',
    'Pilgrimage Packages',
    'Nearby Sacred Places',
    'Recommended',
  ];

  @override
  void initState() {
    super.initState();
    // Create keys for each section
    for (int i = 0; i < _sections.length; i++) {
      _sectionKeys[i] = GlobalKey();
    }
    // Add scroll listener
    _scrollController.addListener(_onScroll);
    // Add nearby places scroll listener
    _nearbyPlacesScrollController.addListener(_onNearbyPlacesScroll);
    // Initialize countdown timer
    _startCountdown();
  }

  void _onNearbyPlacesScroll() {
    // Calculate which card is currently most visible
    final double cardWidth = 167.w + 12.w; // card width + spacing
    final double offset = _nearbyPlacesScrollController.offset;
    final int newPage = (offset / cardWidth).round();

    if (newPage != _currentNearbyPage && newPage >= 0 && newPage < _totalNearbyCards) {
      setState(() {
        _currentNearbyPage = newPage;
      });
    }
  }

  void _startCountdown() {
    // Set target date: Mahashivratri 2026 (example: February 26, 2026)
    final targetDate = DateTime(2026, 2, 26, 0, 0, 0);
    _updateCountdown(targetDate);
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateCountdown(targetDate);
    });
  }

  void _updateCountdown(DateTime targetDate) {
    if (!mounted) return; // Check if widget is still mounted
    
    final now = DateTime.now();
    final difference = targetDate.difference(now);
    
    if (difference.isNegative) {
      // Event has passed
      if (mounted) {
        setState(() {
          _days = 0;
          _hours = 0;
          _seconds = 0;
        });
      }
      _countdownTimer?.cancel();
      return;
    }
    
    final newDays = difference.inDays;
    final newHours = difference.inHours.remainder(24);
    final newSeconds = difference.inSeconds.remainder(60);
    
    // Only update if values have changed
    if (_days != newDays || _hours != newHours || _seconds != newSeconds) {
      if (mounted) {
        setState(() {
          _days = newDays;
          _hours = newHours;
          _seconds = newSeconds;
        });
      }
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    
    final scrollOffset = _scrollController.offset;
    final imageSectionHeight = 400.h; // Image section height
    final overlapHeight = 20.h; // Overlap amount
    final navBarHeight = 61.h; // Reduced navigation bar height (40 + 12 top + 8 spacing + 1 HR + 8 bottom)
    
    // Show sticky nav when scrolled past image section
    final shouldShowNav = scrollOffset > (imageSectionHeight - overlapHeight - navBarHeight);
    
    if (_showStickyNav != shouldShowNav) {
      setState(() {
        _showStickyNav = shouldShowNav;
      });
    }
    
    // Find which section is currently in view
    // Threshold accounts for sticky navigation bar (approximately 61px from top - reduced)
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
      
      // Calculate sticky nav bar height: ~61.h (12.h top + 40.h nav + 8.h spacing + 1.h HR + 8.h bottom)
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
                  _isScrollingToSection = false;
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
              if (_scrollController.hasClients) {
                final currentOffset = _scrollController.offset;
                final adjustedOffset = currentOffset + stickyNavHeight;
                _scrollController.animateTo(
                  adjustedOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                ).then((_) {
                  Future.delayed(const Duration(milliseconds: 200), () {
                    _isScrollingToSection = false;
                  });
                });
              } else {
                _isScrollingToSection = false;
              }
            });
          } else {
            Future.delayed(const Duration(milliseconds: 400), () {
              _isScrollingToSection = false;
            });
          }
        });
        } else {
          _isScrollingToSection = false;
        }
      });
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _imagePageController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _navScrollController.dispose();
    _nearbyPlacesScrollController.removeListener(_onNearbyPlacesScroll);
    _nearbyPlacesScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Extract place name (e.g., "Trimbakeshwar Temple" -> "Trimbakeshwar")
    final placeName = widget.place.name.replaceAll(' Temple', '').replaceAll(' Jyotirlinga', '');
    
    // Extract Devanagari and English names from additionalInfo or use defaults
    final devanagariName = (widget.place.additionalInfo?['devanagari'] as String?) ?? 'त्र्यंबकेश्वर ज्योतिर्लिंग';
    final englishName = (widget.place.additionalInfo?['english'] as String?) ?? '${placeName} Jyotirlinga';
    final subtitle = (widget.place.additionalInfo?['subtitle'] as String?) ?? 'One of the 12 Jyotirlingas • Nashik, Maharashtra';
    
    // Get images for horizontal scrolling
    final images = widget.place.imageUrls.isNotEmpty 
        ? widget.place.imageUrls 
        : ['assets/png/trambak.png'];
    
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          // Hero Image Section - 390x400 with horizontal scrolling
          SizedBox(
            width: double.infinity,
            height: 400.h,
            child: PageView.builder(
              controller: _imagePageController,
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  height: 400.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(images[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: const [0.0, 0.5, 1.0],
                        colors: [
                          Colors.black.withValues(alpha: 0.6), // 0% #000000 60% (dark on left)
                          Colors.black.withValues(alpha: 0.3), // 50% #000000 30%
                          Colors.black.withValues(alpha: 0.0), // 100% #000000 0% (bright on right)
                        ],
                      ),
                    ),
              child: Stack(
                children: [
                  // Top right - Headphone icon button
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
                          colors: [
                            Color(0xFFFF974D), // #FF974D 100%
                            Color(0xFFFFB047), // #FFB047 100%
                          ],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFE5E7EB), // Stroke E5E7EB
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.headphones,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () {
                          // Handle headphone icon tap
                        },
                      ),
                    ),
                  ),
                  // Bottom left content
                  Positioned(
                    bottom: 20.h,
                    left: 20.w,
                    right: 20.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Om icon and Jyotirlinga badge
                        Row(
                          children: [
                            // Om icon
                            SvgPicture.asset(
                              'assets/svg/om.svg',
                              width: 24.w,
                              height: 24.h,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            // Jyotirlinga badge - increased width
                            Container(
                              width: 120.w, // Increased from 83.31.w
                              height: 32.h,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFFFF8C00), // #FF8C00
                                    Color(0xFFFF6B35), // #FF6B35
                                    Color(0xFFD2691E), // #D2691E
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(9999.r),
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB), // Stroke E5E7EB
                                  width: 1,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Center(
                                child: Text(
                                  'Jyotirlinga',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400, // Regular
                                    color: Colors.white, // #FFFFFF
                                    height: 16 / 12, // Line height 16px for 12px font
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        // Devanagari text
                        Text(
                          devanagariName,
                          style: GoogleFonts.notoSansDevanagari(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w400, // Regular
                            color: Colors.white, // #FFFFFF
                            height: 32 / 24, // Line height 32px for 24px font
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 8.h),
                        // English text
                        Text(
                          englishName,
                          style: GoogleFonts.montserrat(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700, // Bold
                            color: Colors.white, // #FFFFFF
                            height: 28 / 18, // Line height 28px for 18px font
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 8.h),
                        // Subtitle with location
                        Text(
                          subtitle,
                          style: GoogleFonts.montserrat(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400, // Regular
                            color: Colors.white, // #FFFFFF
                            height: 20 / 14, // Line height 20px for 14px font
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
          ),
          // Additional content sections - overlapping on image section
          Transform.translate(
            offset: Offset(0, -20.h), // Overlap by 20 pixels
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r), // Corner radius 16
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: 1,
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
                    // Horizontal Navigation Section
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
                    // HR Line
                    Container(
                      height: 1.h,
                      color: const Color(0xFFE5E7EB),
                    ),
                    SizedBox(height: 24.h),
                    // All Sections - shown one below the other
                    ...List.generate(_sections.length, (index) {
                      return Column(
                        key: _sectionKeys[index],
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSection(_sections[index], index),
                          if (index < _sections.length - 1) SizedBox(height: 32.h),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
            ],
          ),
        ),
        // Sticky Navigation Bar - only shown when scrolled past image
        if (_showStickyNav) _buildStickyNavigationBar(),
      ],
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
          top: 12.h, // Reduced from 20.h
          bottom: 8.h, // Reduced from 20.h
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Horizontal Navigation Section
            SizedBox(
              height: 40.h, // Reduced from 44.h
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
            SizedBox(height: 8.h), // Reduced from 20.h
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

  Widget _buildNavigationTab(String title, bool isActive, int index) {
    return Container(
      child: InkWell(
        onTap: () {
          _scrollToSection(index);
        },
        borderRadius: BorderRadius.circular(9999.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h), // Reduced padding
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
              style: GoogleFonts.montserrat(
                fontSize: 13.sp, // Slightly reduced
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

  Widget _buildSection(String sectionTitle, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text(
          sectionTitle,
          style: GoogleFonts.montserrat(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700, // Bold
            color: const Color(0xFF4B5563), // #4B5563
            height: 28 / 20, // Line height 28px for 20px font
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 16.h),
        // Section Content
        _buildSectionBody(sectionTitle),
      ],
    );
  }

  Widget _buildSectionBody(String sectionTitle) {
    switch (sectionTitle) {
      case 'About Temple':
        return _buildAboutTempleSection();
      case 'Aarti Timings':
        return _buildAartiTimingsSection();
      case 'How to Reach':
        return _buildHowToReachSection();
      case 'Explore More':
        return _buildExploreMoreSection();
      case 'Pilgrimage Packages':
        return _buildPilgrimagePackagesSection();
      case 'Nearby Sacred Places':
        return _buildNearbySacredPlacesSection();
      case 'Recommended':
        return _buildRecommendedSection();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAboutTempleSection() {
    // Get description from place or use default
    final description = widget.place.description.isNotEmpty
        ? widget.place.description
        : 'Trimbakeshwar is one of the twelve sacred Jyotirlingas, where Lord Shiva manifests as Brahma, Vishnu, and Mahesh in a unique three-faced lingam. Located at the source of river Godavari, this ancient temple holds immense spiritual significance.';
    
    // Get fact of the day from additionalInfo or use default
    final factOfDay = (widget.place.additionalInfo?['factOfDay'] as String?) ??
        'The sacred Kushavarta Kund near the temple is believed to be the origin point of river Godavari, making it one of India\'s holiest water sources.';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description
        Text(
          description,
          style: GoogleFonts.montserrat(
            fontSize: 14.sp,
            color: const Color(0xFF6B7280),
            height: 1.5,
          ),
        ),
        SizedBox(height: 24.h),
        // 3 Cards - stacked vertically
        Column(
          children: [
            SizedBox(
              width: 351.w,
              height: 96.h,
              child: _buildInfoCard(
                icon: Icons.auto_awesome,
                title: 'Sacred Significance',
                subtitle: 'The only Jyotirlinga where Brahma, Vishnu & Shiva reside together',
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFF7ED), // #FFF7ED
                    Color(0xFFFEFCE8), // #FEFCE8
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: 351.w,
              height: 96.h,
              child: _buildInfoCard(
                icon: Icons.celebration,
                title: 'Puja Rituals',
                subtitle: 'Ancient Vedic puja rituals at Trimbakeshwar Jyotirlinga',
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFF7ED), // #FFF7ED
                    Color(0xFFFEFCE8), // #FEFCE8
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: 351.w,
              height: 96.h,
              child: _buildInfoCard(
                icon: Icons.info_outline,
                title: 'Special Info',
                subtitle: 'Trimbakeshwar Temple has an average elevation of 720 metres (2362 feet).',
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFE1FFEC), // #E1FFEC
                    Color(0xFFE1FFEC), // Same color for gradient
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        // Live Darshan Button
        Center(
          child: SizedBox(
            width: 358.w,
            height: 60.h,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFFF974D), // #FF974D
                  Color(0xFFFFB047), // #FFB047
                ],
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: const Color(0xFFE5E7EB), // Stroke E5E7EB
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Handle Live Darshan tap
                },
                borderRadius: BorderRadius.circular(16.r),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.videocam,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Live Darshan',
                        style: GoogleFonts.montserrat(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400, // Regular
                          color: Colors.white, // #FFFFFF
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        ),
        SizedBox(height: 24.h),
        // Spiritual Fact of the Day Card
        Center(
          child: Container(
            width: 358.w,
            height: 192.h,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFEDD5), // #FFEDD5
                Color(0xFFFEF9C3), // #FEF9C3
              ],
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8C00).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.lightbulb_outline,
                      size: 20.sp,
                      color: const Color(0xFFFF8C00),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Spiritual Fact of the Day',
                      style: GoogleFonts.montserrat(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500, // Medium
                        color: const Color(0xFF1F2937), // #1F2937
                        height: 24 / 16, // Line height 24px for 16px font
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              // Fact text
              Expanded(
                child: Text(
                  factOfDay,
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400, // Regular
                    color: const Color(0xFF4B5563), // #4B5563
                    height: 1.4,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 12.h),
              // Bottom row with Daily Wisdom and Next Fact
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '🌸 Daily Wisdom',
                    style: GoogleFonts.montserrat(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400, // Regular
                      color: const Color(0xFF4B5563), // #4B5563
                      height: 16 / 12, // Line height 16px for 12px font
                    ),
                    textAlign: TextAlign.left,
                  ),
                  InkWell(
                    onTap: () {
                      // Handle next fact tap
                    },
                    child: Text(
                      'Next Fact →',
                      style: GoogleFonts.montserrat(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400, // Regular
                        color: const Color(0xFFFF8C00), // #FF8C00
                        height: 16 / 12, // Line height 16px for 12px font
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required LinearGradient gradient,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: const Color(0xFFFF8C00).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              size: 20.sp,
              color: const Color(0xFFFF8C00),
            ),
          ),
          SizedBox(width: 12.w),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500, // Medium
                    color: const Color(0xFF1F2937), // #1F2937
                    height: 20 / 14, // Line height 20px for 14px font
                  ),
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                // Subtitle
                Text(
                  subtitle,
                  style: GoogleFonts.montserrat(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400, // Regular
                    color: const Color(0xFF4B5563), // #4B5563
                    height: 16 / 12, // Line height 16px for 12px font
                  ),
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAartiTimingsSection() {
    // Fixed aarti types for all temples
    final List<String> fixedAartiTypes = [
      'Morning Aarti',
      'Abhishek Pooja',
      'Evening Aarti',
      'Temple Closing',
    ];

    // Get aarti timings from place additionalInfo
    final aartiTimings = (widget.place.additionalInfo?['aartiTimings'] as List?) ?? [];
    
    // Default timings if not found
    final defaultTimings = [
      {'type': 'Morning Aarti', 'startTime': '5:30 AM', 'endTime': '7:00 AM', 'frequency': 'Daily'},
      {'type': 'Abhishek Pooja', 'startTime': '6:00 AM', 'endTime': '12:00 PM', 'frequency': 'Special slots'},
      {'type': 'Evening Aarti', 'startTime': '7:00 PM', 'endTime': '8:00 PM', 'frequency': 'Daily'},
      {'type': 'Temple Closing', 'startTime': '9:00 PM', 'endTime': '9:00 PM', 'frequency': 'Daily'},
    ];
    
    final timingsList = aartiTimings.isNotEmpty 
        ? aartiTimings.map((e) => e as Map<String, dynamic>).toList()
        : defaultTimings;

    return Column(
      children: [
        // Aarti Timing Card
        Center(
          child: Container(
            width: 358.w,
            height: 320.h, // Reduced from 385
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: const Color(0xFFFF9933), // #FF9933 solid stroke
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x1A000000), // #0000001A
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 12.h, // Reduced vertical padding
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Timing List - using fixed aarti types (removed temple name)
                  ...fixedAartiTypes.asMap().entries.map((entry) {
                    final index = entry.key;
                    final aartiType = entry.value;
                    final isLast = index == fixedAartiTypes.length - 1;
                    
                    // Find timing for this aarti type
                    Map<String, dynamic>? timing;
                    for (var t in timingsList) {
                      if (t['type'] == aartiType) {
                        timing = t;
                        break;
                      }
                    }
                    
                    if (timing == null) return const SizedBox.shrink();
                    
                    return Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 4.h), // Reduced spacing
                      child: _buildTimingItem(
                        timing['type'] as String,
                        timing['startTime'] as String,
                        timing['endTime'] as String,
                        timing['frequency'] as String,
                        showHrLine: !isLast,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        // Travel Guidelines Card
        Center(
          child: Container(
            width: 358.w,
            height: 400.h, // Increased from 320 to fit all text
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFEDD5), // #FFEDD5
                  Color(0xFFFEF9C3), // #FEF9C3
                ],
              ),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: const Color(0xFFE5E7EB), // #E5E7EB
                width: 1,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w), // Reduced padding from 20 to 16
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title with icon
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline, // Info icon before title
                        size: 20.sp,
                        color: const Color(0xFF1F2937),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Travel Guidelines',
                        style: GoogleFonts.montserrat(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700, // Bold - highlighted
                          color: const Color(0xFF1F2937),
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  // Subtitle - regular style (not highlighted)
                  Text(
                    'Follow temple protocols for a safe visit',
                    style: GoogleFonts.montserrat(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400, // Regular - same as sub-points
                      color: const Color(0xFF4B5563),
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 10.h), // Reduced from 12
                  // Guidelines List
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // First point (different style)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.h,
                            margin: EdgeInsets.only(top: 6.h, right: 12.w), // Reduced top margin
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF8A02),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Wear traditional/modest clothes (men: dhoti/kurta, women: saree/salwar). No shorts or sleeveless.',
                              style: GoogleFonts.montserrat(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600, // SemiBold for first point
                                color: const Color(0xFF1F2937),
                                height: 1.4, // Reduced from 1.5
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h), // Reduced from 12
                      // Sub-points (different style)
                      _buildGuidelinePoint('Visit early morning (5–8 AM) for peaceful darshan; avoid peak crowd in afternoons'),
                      SizedBox(height: 8.h), // Reduced from 10
                      _buildGuidelinePoint('No photography inside, remove footwear, maintain silence, respect rituals.'),
                      SizedBox(height: 8.h), // Reduced from 10
                      _buildGuidelinePoint('Carry water & cash, book special poojas in advance, avoid big bags & fake agents.'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuidelinePoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4.w,
          height: 4.h,
          margin: EdgeInsets.only(top: 8.h, right: 12.w),
          decoration: BoxDecoration(
            color: const Color(0xFF6B7280),
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.montserrat(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400, // Regular for sub-points
              color: const Color(0xFF4B5563),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  IconData _getIconForType(String type) {
    if (type.toLowerCase().contains('morning')) {
      return Icons.wb_twilight;
    } else if (type.toLowerCase().contains('evening')) {
      return Icons.nightlight_round;
    } else if (type.toLowerCase().contains('abhishek') || type.toLowerCase().contains('pooja')) {
      return Icons.auto_awesome;
    } else if (type.toLowerCase().contains('closing')) {
      return Icons.lock;
    }
    return Icons.access_time;
  }

  Widget _buildTimingItem(
    String type,
    String startTime,
    String endTime,
    String frequency, {
    bool showHrLine = true,
  }) {
    final hasTimeRange = startTime != endTime;
    
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon with background
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEDD5),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
              child: Icon(
                _getIconForType(type),
                size: 20.sp,
                color: const Color(0xFFFFA201),
              ),
            ),
            SizedBox(width: 12.w),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    type,
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600, // SemiBold
                      color: const Color(0xFF003366),
                      height: 1.2,
                      letterSpacing: 0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    frequency,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400, // Regular
                      color: const Color(0xFF6B7280),
                      height: 1.2,
                      letterSpacing: 0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ],
              ),
            ),
            // Time on right - displayed one below the other
            SizedBox(
              width: 100.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasTimeRange) ...[
                    // Start time
                    Text(
                      startTime,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700, // Bold
                        color: const Color(0xFFFF9933),
                        height: 1.2,
                        letterSpacing: 0,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                    SizedBox(height: 2.h),
                    // Dash
                    Text(
                      '-',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400, // Regular
                        color: const Color(0xFF6B7280),
                        height: 1.2,
                        letterSpacing: 0,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 2.h),
                    // End time
                    Text(
                      endTime,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700, // Bold
                        color: const Color(0xFFFF9933),
                        height: 1.2,
                        letterSpacing: 0,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ] else ...[
                    // Single time (when start and end are same)
                    Text(
                      startTime,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700, // Bold
                        color: const Color(0xFFFF9933),
                        height: 1.2,
                        letterSpacing: 0,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        if (showHrLine) ...[
          SizedBox(height: 8.h), // Reduced spacing
          // HR Line for each event
          Container(
            height: 1.h, // Reduced height
            color: const Color(0xFFE5E7EB),
          ),
        ],
      ],
    );
  }

  Widget _buildHowToReachSection() {
    // Get route and distance from additionalInfo or use defaults
    final routeFrom = (widget.place.additionalInfo?['routeFrom'] as String?) ?? 'Nashik';
    final routeTo = (widget.place.additionalInfo?['routeTo'] as String?) ?? 'Trimbak';
    final distance = (widget.place.additionalInfo?['distance'] as String?) ?? '~25 km (40-50 mins drive)';
    
    return Column(
      children: [
        // Main How to Reach Card
        Center(
          child: Container(
            width: 358.w,
            height: 116.h,
            decoration: BoxDecoration(
              color: Colors.white, // #FFFFFF
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: const Color(0xFFE5E7EB), // #E5E7EB
                width: 1,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h), // Reduced vertical padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Location icon with "From Nashik City"
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 18.sp, // Slightly reduced icon size
                        color: const Color(0xFF000000),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'From Nashik City',
                        style: GoogleFonts.montserrat(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500, // Medium
                          color: const Color(0xFF000000), // #000000
                          height: 1.2, // Reduced line height
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h), // Reduced spacing
                  // Route: Nashik → Trimbak
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Route: ',
                          style: GoogleFonts.montserrat(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700, // Bold
                            color: const Color(0xFF4B5563), // #4B5563
                          ),
                        ),
                        TextSpan(
                          text: '$routeFrom → $routeTo',
                          style: GoogleFonts.montserrat(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400, // Regular
                            color: const Color(0xFF4B5563), // #4B5563
                            height: 1.2, // Reduced line height
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6.h), // Reduced spacing
                  // Distance: Bold label with regular value
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Distance: ',
                          style: GoogleFonts.montserrat(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700, // Bold
                            color: const Color(0xFF4B5563), // #4B5563
                          ),
                        ),
                        TextSpan(
                          text: distance,
                          style: GoogleFonts.montserrat(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400, // Regular
                            color: const Color(0xFF4B5563), // #4B5563
                            height: 1.2, // Reduced line height
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h), // Spacing between main card and travel mode cards
        // Travel Mode Cards Row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w), // Match main card padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Auto Card
              Expanded(
                child: _buildTravelModeCard(
                  icon: Icons.directions_car,
                  label: 'Auto',
                ),
              ),
              SizedBox(width: 3.w), // Spacing between cards
              // Private Cab Card
              Expanded(
                child: _buildTravelModeCard(
                  icon: Icons.local_taxi,
                  label: 'Private Cab',
                ),
              ),
              SizedBox(width: 3.w), // Spacing between cards
              // Local Bus Card
              Expanded(
                child: _buildTravelModeCard(
                  icon: Icons.directions_bus,
                  label: 'Local Bus',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTravelModeCard({
    required IconData icon,
    required String label,
  }) {
    return Container(
      height: 72.h, // Increased height to accommodate text better
      decoration: BoxDecoration(
        color: Colors.white, // #FFFFFF
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xFFE5E7EB), // #E5E7EB
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000), // #0000001A - 10% opacity
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: const Color(0xFF1F2937),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 11.sp, // Slightly reduced to fit better
                fontWeight: FontWeight.w500, // Medium
                color: const Color(0xFF1F2937),
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreMoreSection() {
    // Get video URL and images from additionalInfo or use defaults
    // TODO: Use videoUrl when implementing YouTube player
    // ignore: unused_local_variable
    final videoUrl = (widget.place.additionalInfo?['videoUrl'] as String?) ?? 
        'https://www.youtube.com/watch?v=dQw4w9WgXcQ'; // Default YouTube URL
    final exploreImages = (widget.place.additionalInfo?['exploreImages'] as List?)?.cast<String>() ?? 
        widget.place.imageUrls.take(4).toList();
    
    // Ensure we have at least 4 images (pad with default if needed)
    final List<String> displayImages = [];
    displayImages.addAll(exploreImages);
    while (displayImages.length < 4) {
      displayImages.add('assets/png/trambak.png');
    }
    displayImages.removeRange(4, displayImages.length); // Keep only first 4
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // YouTube Video Player
        Center(
          child: Container(
            width: 349.w,
            height: 201.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.black,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Stack(
                children: [
                  // Video thumbnail/placeholder
                  Container(
                    width: double.infinity,
                    height: double.infinity,
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
                  ),
                  // Play button overlay
                  Center(
                    child: Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 32.sp,
                      ),
                    ),
                  ),
                  // Tap to play
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // TODO: Implement YouTube video player
                        // For now, this is a placeholder
                      },
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        // Image Previews Row
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return Padding(
                padding: EdgeInsets.only(right: index < 3 ? 3.w : 0),
                child: GestureDetector(
                  onTap: () {
                    _showImageDialog(context, displayImages[index]);
                  },
                  child: Container(
                    width: 59.w,
                    height: 57.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.asset(
                        displayImages[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFF3F4F6),
                            child: Icon(
                              Icons.image,
                              size: 24.sp,
                              color: const Color(0xFF9CA3AF),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  void _showImageDialog(BuildContext context, String imagePath) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 300.w,
                      height: 300.h,
                      color: const Color(0xFF1F2937),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48.sp,
                            color: Colors.white,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'Image not found',
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 40.h,
              right: 20.w,
              child: IconButton(
                icon: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPilgrimagePackagesSection() {
    return Column(
      children: [
        // First Card - White Background
        Center(
          child: Container(
            width: 358.w,
            height: 180.h,
            decoration: BoxDecoration(
              color: Colors.white, // #FFFFFF
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: const Color(0xFFE5E7EB), // #E5E7EB
                width: 1,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h), // Reduced vertical padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title: One Day Spiritual Darshan
                  Text(
                    'One Day Spiritual Darshan',
                    style: GoogleFonts.montserrat(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500, // Medium
                      color: const Color(0xFF1F2937), // #1F2937
                      height: 1.3, // Reduced line height
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 6.h), // Reduced spacing
                  // Subtitle: All key temples in Nashik
                  Text(
                    'All key temples in Nashik',
                    style: GoogleFonts.montserrat(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400, // Regular
                      color: const Color(0xFF4B5563), // #4B5563
                      height: 1.3, // Reduced line height
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 10.h), // Reduced spacing
                  // Options: Transport, Meals, Guide
                  Row(
                    children: [
                      _buildPackageOption('Transport'),
                      SizedBox(width: 12.w), // Reduced spacing
                      _buildPackageOption('Meals'),
                      SizedBox(width: 12.w), // Reduced spacing
                      _buildPackageOption('Guide'),
                    ],
                  ),
                  SizedBox(height: 12.h), // Fixed spacing instead of Spacer
                  // Explore More Button
                  Center(
                    child: Container(
                      width: 318.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFFFF994D), // #FF994D
                            Color(0xFFFFB048), // #FFB048
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // TODO: Navigate to package details
                          },
                          borderRadius: BorderRadius.circular(8.r),
                          child: Center(
                            child: Text(
                              'Explore More',
                              style: GoogleFonts.montserrat(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500, // Medium
                                color: Colors.white, // #FFFFFF
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h), // Spacing between cards
        // Second Card - Gradient Background
        Center(
          child: Container(
            width: 358.w,
            height: 180.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFFF974C), // #FF974C
                  Color(0xFFFFAF47), // #FFAF47
                ],
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: const Color(0xFFE5E7EB), // #E5E7EB
                width: 1,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h), // Reduced vertical padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title: One Day Spiritual Darshan
                  Text(
                    'One Day Spiritual Darshan',
                    style: GoogleFonts.montserrat(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500, // Medium
                      color: const Color(0xFF1F2937), // #1F2937
                      height: 1.3, // Reduced line height
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 6.h), // Reduced spacing
                  // Subtitle: All key temples in Nashik
                  Text(
                    'All key temples in Nashik',
                    style: GoogleFonts.montserrat(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400, // Regular
                      color: const Color(0xFF4B5563), // #4B5563
                      height: 1.3, // Reduced line height
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 10.h), // Reduced spacing
                  // Options: Transport, Meals, Guide
                  Row(
                    children: [
                      _buildPackageOption('Transport'),
                      SizedBox(width: 12.w), // Reduced spacing
                      _buildPackageOption('Meals'),
                      SizedBox(width: 12.w), // Reduced spacing
                      _buildPackageOption('Guide'),
                    ],
                  ),
                  SizedBox(height: 12.h), // Fixed spacing instead of Spacer
                  // Explore Festival Package Button
                  Center(
                    child: Container(
                      width: 318.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: Colors.white, // #FFFFFF
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // TODO: Navigate to festival package details
                          },
                          borderRadius: BorderRadius.circular(8.r),
                          child: Center(
                            child: Text(
                              'Explore Festival Package',
                              style: GoogleFonts.montserrat(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500, // Medium
                                color: const Color(0xFFF97316), // #F97316
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h), // Spacing between cards
        // Countdown Card
        Center(
          child: Container(
            width: 358.w,
            height: 164.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFEE2E2), // #FEE2E2
                  Color(0xFFFFEDD5), // #FFEDD5
                ],
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h), // Reduced vertical padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Calendar icon and "Next Festival" text
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 18.sp, // Slightly reduced
                        color: const Color(0xFFEF4444), // #EF4444
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Next Festival',
                        style: GoogleFonts.montserrat(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500, // Medium
                          color: const Color(0xFF1F2937), // #1F2937
                          height: 1.2, // Reduced line height
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h), // Reduced spacing
                  // Mahashivratri 2026 - Centered
                  Center(
                    child: Text(
                      'Mahashivratri 2026',
                      style: GoogleFonts.montserrat(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700, // Bold
                        color: const Color(0xFFDC2626), // #DC2626
                        height: 1.2, // Reduced line height
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h), // Reduced spacing
                  // Countdown Timer
                  Center(
                    child: _buildCountdownTimer(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCountdownTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCountdownItem('Days', _days, 'days'),
        SizedBox(width: 12.w), // Reduced spacing
        _buildCountdownItem('Hours', _hours, 'hours'),
        SizedBox(width: 12.w), // Reduced spacing
        _buildCountdownItem('Seconds', _seconds, 'seconds'),
      ],
    );
  }

  Widget _buildCountdownItem(String label, int value, String key) {
    return Column(
      key: ValueKey(key),
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h), // Reduced padding
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: GoogleFonts.montserrat(
              fontSize: 20.sp, // Reduced font size
              fontWeight: FontWeight.w700, // Bold
              color: const Color(0xFFDC2626), // #DC2626
            ),
          ),
        ),
        SizedBox(height: 4.h), // Reduced spacing
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 11.sp, // Slightly reduced
            fontWeight: FontWeight.w500, // Medium
            color: const Color(0xFF4B5563), // #4B5563
          ),
        ),
      ],
    );
  }

  Widget _buildPackageOption(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check_circle,
          size: 16.sp,
          color: const Color(0xFF10B981), // Green checkmark
        ),
        SizedBox(width: 4.w),
        Text(
          text,
          style: GoogleFonts.montserrat(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400, // Regular
            color: const Color(0xFF4B5563), // #4B5563
          ),
        ),
      ],
    );
  }

  Widget _buildNearbySacredPlacesSection() {
    // Get nearby places from additionalInfo or use defaults
    final nearbyPlaces = (widget.place.additionalInfo?['nearbyPlaces'] as List?) ?? [];
    
    // Default nearby places if not provided
    final defaultPlaces = [
      {
        'image': 'assets/png/trambak.png',
        'title': 'Ramkund',
        'subtitle': 'Holy Bathing Ghat',
        'rating': '4.8',
      },
      {
        'image': 'assets/png/trambak.png',
        'title': 'Kalaram Temple',
        'subtitle': 'Ancient Temple',
        'rating': '4.6',
      },
      {
        'image': 'assets/png/trambak.png',
        'title': 'Sita Gufa',
        'subtitle': 'Sacred Cave',
        'rating': '4.7',
      },
      {
        'image': 'assets/png/trambak.png',
        'title': 'Muktidham Temple',
        'subtitle': 'Marble Temple',
        'rating': '4.5',
      },
    ];
    
    final placesList = nearbyPlaces.isNotEmpty 
        ? nearbyPlaces.map((e) => e as Map<String, dynamic>).toList()
        : defaultPlaces;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row with "Holy Spots" and "View More"
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Holy Spots',
                style: GoogleFonts.montserrat(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700, // Bold
                  color: const Color(0xFF1F2937),
                  height: 1.2,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Navigate to view all nearby places
                },
                child: Text(
                  'View More',
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500, // Medium
                    color: const Color(0xFFEA580C), // #EA580C
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        // Horizontal Scrolling Cards
        SizedBox(
          height: 190.h,
          child: ListView.separated(
            controller: _nearbyPlacesScrollController,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: placesList.length,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final place = placesList[index];
              return _buildNearbyPlaceCard(
                imagePath: place['image'] as String? ?? 'assets/png/trambak.png',
                title: place['title'] as String? ?? 'Sacred Place',
                subtitle: place['subtitle'] as String? ?? 'Holy Site',
                rating: place['rating'] as String? ?? '4.5',
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        // Dot Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            placesList.length,
            (index) => Container(
              width: 8.w,
              height: 8.h,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentNearbyPage == index
                    ? const Color(0xFF000000)
                    : const Color(0xFFD9D9D9),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNearbyPlaceCard({
    required String imagePath,
    required String title,
    required String subtitle,
    required String rating,
  }) {
    return Container(
      width: 167.w,
      constraints: BoxConstraints(
        maxHeight: 190.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image with Rating Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                child: Image.asset(
                  imagePath,
                  width: 167.w,
                  height: 128.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 167.w,
                      height: 128.h,
                      color: const Color(0xFFF3F4F6),
                      child: Icon(
                        Icons.image,
                        size: 32.sp,
                        color: const Color(0xFF9CA3AF),
                      ),
                    );
                  },
                ),
              ),
              // Rating Badge at top-right corner
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        size: 14.sp,
                        color: const Color(0xFFFFA201),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        rating,
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1F2937),
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Text Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1F2937),
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF4B5563),
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedSection() {
    // Get recommended places from additionalInfo or use defaults
    final recommendedPlaces = (widget.place.additionalInfo?['recommendedPlaces'] as List?) ?? [];
    
    // Default recommended places
    final defaultPlaces = [
      {
        'image': 'assets/png/trambak.png',
        'title': 'Pandavleni Caves',
        'subtitle': 'Ancient Buddhist caves dating back to 3rd century BCE',
        'location': 'Start point • 1 hr visit',
      },
      {
        'image': 'assets/png/trambak.png',
        'title': 'Kalaram Temple',
        'subtitle': 'Sacred temple dedicated to Lord Rama with black stone idol',
        'location': '15 min drive • 45 min visit',
      },
      {
        'image': 'assets/png/trambak.png',
        'title': 'Ramkund',
        'subtitle': 'Holy bathing ghat on river Godavari',
        'location': '10 min walk • 30 min visit',
      },
    ];
    
    final placesList = recommendedPlaces.isNotEmpty 
        ? recommendedPlaces.map((e) => e as Map<String, dynamic>).toList()
        : defaultPlaces;
    
    // Group cards in sets of 3
    final List<List<Map<String, dynamic>>> cardGroups = [];
    for (int i = 0; i < placesList.length; i += 3) {
      cardGroups.add(placesList.sublist(
        i,
        i + 3 > placesList.length ? placesList.length : i + 3,
      ));
    }
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w), // Same margin as headings
      child: SizedBox(
        height: (104.h * 3) + (10.h * 2), // Height for 3 cards + reduced spacing
        child: PageView.builder(
          itemCount: cardGroups.length,
          itemBuilder: (context, pageIndex) {
            final group = cardGroups[pageIndex];
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(group.length, (index) {
                final place = group[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: index < group.length - 1 ? 10.h : 0), // Reduced spacing
                  child: _buildRecommendedCard(
                    imagePath: place['image'] as String? ?? 'assets/png/trambak.png',
                    title: place['title'] as String? ?? 'Recommended Place',
                    subtitle: place['subtitle'] as String? ?? 'Description',
                    location: place['location'] as String? ?? 'Location info',
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRecommendedCard({
    required String imagePath,
    required String title,
    required String subtitle,
    required String location,
  }) {
    return Container(
      width: 352.w,
      height: 104.h,
      decoration: BoxDecoration(
        color: Colors.white, // #FFFFFF
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFE5E7EB), // #E5E7EB
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.w), // Reduced padding
        child: Row(
          children: [
            // Left side - Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Container(
                width: 64.w,
                height: 64.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFE5E7EB), // #E5E7EB
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Image.asset(
                  imagePath,
                  width: 64.w,
                  height: 64.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 64.w,
                      height: 64.h,
                      color: const Color(0xFFF3F4F6),
                      child: Icon(
                        Icons.image,
                        size: 24.sp,
                        color: const Color(0xFF9CA3AF),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: 10.w), // Reduced spacing
            // Right side - Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600, // SemiBold
                      color: const Color(0xFF000000), // #000000
                      height: 1.3, // Reduced line height
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3.h), // Reduced spacing
                  // Subtitle
                  Text(
                    subtitle,
                    style: GoogleFonts.montserrat(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400, // Regular
                      color: const Color(0xFF4B5563), // #4B5563
                      height: 1.2, // Reduced line height
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3.h), // Reduced spacing
                  // Location info
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 12.sp, // Slightly reduced
                        color: const Color(0xFF6B7280),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          location,
                          style: GoogleFonts.montserrat(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400, // Regular
                            color: const Color(0xFF6B7280), // #6B7280
                            height: 1.2, // Reduced line height
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
            SizedBox(width: 8.w),
            // Right side - Arrow button
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6), // #F3F4F6
                borderRadius: BorderRadius.circular(9999.r),
                border: Border.all(
                  color: const Color(0xFFE5E7EB), // #E5E7EB
                  width: 1,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 14.sp,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
