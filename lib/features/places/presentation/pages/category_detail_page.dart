import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../places/data/repositories/place_repository_impl.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/place.dart';
import '../../domain/repositories/place_repository.dart';
import '../../domain/use_cases/get_category_details.dart';
import '../../domain/use_cases/get_places_by_category.dart';

// Helper function for text styles
TextStyle _getTextStyle({
  required double fontSize,
  FontWeight? fontWeight,
  Color? color,
  double? height,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight ?? FontWeight.normal,
    color: color,
    height: height,
    fontFamily: 'Roboto',
  );
}

/// Category Detail Page
/// Shows comprehensive category information with tabs and sections
class CategoryDetailPage extends StatefulWidget {
  final String categoryId;

  const CategoryDetailPage({
    super.key,
    required this.categoryId,
  });

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> with SingleTickerProviderStateMixin {
  late final PlaceRepository _repository;
  Category? _category;
  List<Place> _places = [];
  bool _isLoading = true;
  // Main scroll controller
  final ScrollController _mainScrollController = ScrollController();
  final ScrollController _navScrollController = ScrollController();
  
  // Active section tracking
  int _activeSectionIndex = 0;
  bool _showStickyNav = false;
  bool _isScrollingToSection = false;
  
  // Global keys for sections to scroll to
  final GlobalKey _aboutSectionKey = GlobalKey();
  final GlobalKey _sacredPlacesSectionKey = GlobalKey();
  final GlobalKey _circuitsSectionKey = GlobalKey();
  
  // Nature-specific section keys
  final GlobalKey _naturePlacesSectionKey = GlobalKey();
  final GlobalKey _natureSafetySectionKey = GlobalKey();
  final GlobalKey _natureFacilitiesSectionKey = GlobalKey();
  final GlobalKey _natureItinerariesSectionKey = GlobalKey();
  final GlobalKey _natureEcoFriendlySectionKey = GlobalKey();
  final GlobalKey _natureStoriesSectionKey = GlobalKey();

  // Section names
  final List<String> _sections = [
    'About',
    'Sacred Places',
    'Circuits',
  ];

  // Scroll controllers for carousels
  final Map<String, ScrollController> _scrollControllers = {};
  final Map<String, int> _currentPageIndices = {};

  @override
  void initState() {
    super.initState();
    _repository = PlaceRepositoryImpl();
    _mainScrollController.addListener(_onScroll);
    _loadData();
  }

  @override
  void dispose() {
    _mainScrollController.removeListener(_onScroll);
    _mainScrollController.dispose();
    _navScrollController.dispose();
    for (var controller in _scrollControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (!_mainScrollController.hasClients || _isScrollingToSection) return;
    
    final scrollOffset = _mainScrollController.offset;
    final imageSectionHeight = 350.h; // Hero section height (increased)
    final navBarHeight = 61.h; // Navigation bar height
    
    // Show sticky nav when scrolled past image section
    final shouldShowNav = scrollOffset > (imageSectionHeight - navBarHeight);
    
    if (_showStickyNav != shouldShowNav) {
      setState(() {
        _showStickyNav = shouldShowNav;
      });
    }
    
    // Find which section is currently in view
    final threshold = 61.0; // Sticky nav height
    
    int? newActiveIndex;
    double minDistance = double.infinity;
    
    // Get section keys based on category
    final List<GlobalKey> sectionKeys;
    if (widget.categoryId == 'nature') {
      sectionKeys = [
        _aboutSectionKey,
        _naturePlacesSectionKey,
        _natureSafetySectionKey,
        _natureFacilitiesSectionKey,
        _natureItinerariesSectionKey,
        _natureEcoFriendlySectionKey,
        _natureStoriesSectionKey,
      ];
    } else if (widget.categoryId == 'adventure') {
      sectionKeys = [
        _aboutSectionKey,
        _sacredPlacesSectionKey,
        _circuitsSectionKey,
        _natureSafetySectionKey,
        _natureFacilitiesSectionKey,
        _natureItinerariesSectionKey,
        _natureEcoFriendlySectionKey,
      ];
    } else if (widget.categoryId == 'family') {
      sectionKeys = [
        _aboutSectionKey,
        _sacredPlacesSectionKey,
        _natureSafetySectionKey,
        _natureFacilitiesSectionKey,
        _circuitsSectionKey,
        _natureEcoFriendlySectionKey,
        _natureStoriesSectionKey,
      ];
    } else if (widget.categoryId == 'culture') {
      sectionKeys = [
        _aboutSectionKey,
        _sacredPlacesSectionKey,
        _natureSafetySectionKey,
        _natureFacilitiesSectionKey,
        _circuitsSectionKey,
        _natureEcoFriendlySectionKey,
        _natureStoriesSectionKey,
      ];
    } else if (widget.categoryId == 'shopping') {
      sectionKeys = [
        _aboutSectionKey,
        _sacredPlacesSectionKey,
        _natureSafetySectionKey,
        _natureFacilitiesSectionKey,
        _circuitsSectionKey,
        _natureEcoFriendlySectionKey,
        _natureStoriesSectionKey,
      ];
    } else {
      sectionKeys = [_aboutSectionKey, _sacredPlacesSectionKey, _circuitsSectionKey];
    }
    
    for (int i = 0; i < sectionKeys.length; i++) {
      final key = sectionKeys[i];
      if (key.currentContext != null) {
        final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null) {
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
    if (newActiveIndex != null && _activeSectionIndex != newActiveIndex) {
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
    
    // Estimate tab width and scroll to approximate position
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

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final category = await GetCategoryDetails(_repository).call(widget.categoryId);
      final places = await GetPlacesByCategory(_repository).call(widget.categoryId);

      // Initialize scroll controllers for carousels
      _initializeScrollControllers();

      if (mounted) {
        setState(() {
          _category = category;
          _places = places;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading category data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _initializeScrollControllers() {
    final carouselKeys = ['temples', 'caves', 'ghats'];
    for (var key in carouselKeys) {
      _scrollControllers[key] = ScrollController();
      _currentPageIndices[key] = 0;
      _scrollControllers[key]!.addListener(() {
        _updatePageIndex(key);
      });
    }
  }

  void _updatePageIndex(String key) {
    final controller = _scrollControllers[key]!;
    if (controller.hasClients) {
      final cardWidth = 160.w + 12.w;
      final offset = controller.offset;
      final newPage = (offset / cardWidth).round();
      if (newPage != _currentPageIndices[key] && newPage >= 0) {
        setState(() {
          _currentPageIndices[key] = newPage;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
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
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => context.pop(),
            ),
            title: Text(
              _category?.name ?? 'Category',
              style: _getTextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111827),
                height: 28 / 18,
              ),
              textAlign: TextAlign.center,
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _category == null
              ? const Center(child: Text('Category not found'))
              : _buildBody(),
    );
  }

  Widget _buildBody() {
    if (widget.categoryId == 'spiritual') {
      return _buildSpiritualPage();
    }
    if (widget.categoryId == 'nature') {
      return _buildNaturePage();
    }
    if (widget.categoryId == 'adventure') {
      return _buildAdventurePage();
    }
    if (widget.categoryId == 'family') {
      return _buildFamilyPage();
    }
    if (widget.categoryId == 'culture') {
      return _buildCulturePage();
    }
    if (widget.categoryId == 'shopping') {
      return _buildShoppingPage();
    }
    // For other categories, show basic layout
    return _buildBasicPage();
  }

  Widget _buildSpiritualPage() {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _mainScrollController,
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
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r), bottomLeft: Radius.zero, bottomRight: Radius.zero),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 44.h, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: _sections.length, itemBuilder: (context, index) {
                              final isActive = index == _activeSectionIndex;
                              return Padding(key: ValueKey('nav-tab-$index'), padding: EdgeInsets.only(right: index < _sections.length - 1 ? 8.w : 0), child: _buildNavigationTab(_sections[index], isActive, index));
                            })),
                            SizedBox(height: 20.h),
                            Container(height: 1.h, color: const Color(0xFFE5E7EB)),
                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildSectionContainer(key: _aboutSectionKey, child: _buildAboutTab()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _sacredPlacesSectionKey, child: _buildSacredPlacesTab()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _circuitsSectionKey, child: _buildCircuitsTab()),
                            SizedBox(height: 32.h),
                            _buildRecommendedCircuitsTab(),
                            SizedBox(height: 32.h),
                            _buildEcoSpiritualMessage(),
                            SizedBox(height: 32.h),
                          ],
                        ),
                      ),
                    ],
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

  Widget _buildSectionContainer({required GlobalKey key, required Widget child}) {
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [child],
    );
  }

  Widget _buildNaturePage() {
    // Nature category sections
    final List<String> natureSections = [
      'About',
      'Places',
      'Safety',
      'Facilities',
      'Itineraries',
      'Eco-Friendly',
      'Stories',
    ];
    
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _mainScrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hero Section
              _buildNatureHeroSection(),
              // Navigation Tabs
              Transform.translate(
                offset: Offset(0, -20.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                      bottomLeft: Radius.zero,
                      bottomRight: Radius.zero,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 44.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: natureSections.length,
                                itemBuilder: (context, index) {
                                  final isActive = index == _activeSectionIndex;
                                  return Padding(
                                    key: ValueKey('nav-tab-$index'),
                                    padding: EdgeInsets.only(
                                      right: index < natureSections.length - 1 ? 8.w : 0,
                                    ),
                                    child: _buildNavigationTab(natureSections[index], isActive, index),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Container(height: 1.h, color: const Color(0xFFE5E7EB)),
                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                      // All Nature Sections
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // About Section
                            _buildSectionContainer(
                              key: _aboutSectionKey,
                              child: _buildNatureAboutSection(),
                            ),
                            SizedBox(height: 32.h),
                            // Places Section
                            _buildSectionContainer(
                              key: _naturePlacesSectionKey,
                              child: _buildNaturePlacesSection(),
                            ),
                            SizedBox(height: 32.h),
                            // Safety Section
                            _buildSectionContainer(
                              key: _natureSafetySectionKey,
                              child: _buildSafetyEssentialsSection(),
                            ),
                            SizedBox(height: 32.h),
                            // Facilities Section
                            _buildSectionContainer(
                              key: _natureFacilitiesSectionKey,
                              child: _buildNearbyFacilitiesSection(),
                            ),
                            SizedBox(height: 32.h),
                            // Itineraries Section
                            _buildSectionContainer(
                              key: _natureItinerariesSectionKey,
                              child: _buildRecommendedItinerariesSection(),
                            ),
                            SizedBox(height: 32.h),
                            // Eco-Friendly Section
                            _buildSectionContainer(
                              key: _natureEcoFriendlySectionKey,
                              child: _buildEcoFriendlyTravelSection(),
                            ),
                            SizedBox(height: 32.h),
                            // Stories Section
                            _buildSectionContainer(
                              key: _natureStoriesSectionKey,
                              child: _buildTravelStoriesSection(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_showStickyNav) _buildStickyNavigationBar(isNature: widget.categoryId == 'nature'),
      ],
    );
  }

  Widget _buildBasicPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryHero(),
          SizedBox(height: 24.h),
          _buildSignificanceSection(),
          SizedBox(height: 24.h),
          _buildPlacesSection(),
          SizedBox(height: 80.h),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      height: 350.h, // Increased height
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(_category?.imagePath ?? 'assets/png/trambak.png'),
          fit: BoxFit.cover,
        ),
        color: const Color(0xFFF3F4F6), // Fallback color
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Experience the Divine Essence of Nashik',
                style: _getTextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'City of Faith & Spirituality Side',
                style: _getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  _buildBulletPoint('Caves'),
                  SizedBox(width: 8.w),
                  _buildBulletPoint('Jyotirling'),
                  SizedBox(width: 8.w),
                  _buildBulletPoint('Holy Ghats'),
                  SizedBox(width: 8.w),
                  _buildBulletPoint('Temples'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Text(
      '• $text',
      style: _getTextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    );
  }

  Widget _buildStickyNavigationBar({bool isNature = false}) {
    final List<String> sections;
    if (widget.categoryId == 'nature') {
      sections = ['About', 'Places', 'Safety', 'Facilities', 'Itineraries', 'Eco-Friendly', 'Stories'];
    } else if (widget.categoryId == 'adventure') {
      sections = ['About', 'Places', 'Trails', 'Safety', 'Facilities', 'Checklist', 'Tourism'];
    } else if (widget.categoryId == 'family') {
      sections = ['About', 'Places', 'Safety', 'Facilities', 'Itineraries', 'Eco-Friendly', 'Stories'];
    } else if (widget.categoryId == 'culture') {
      sections = ['About', 'Places', 'Safety', 'Facilities', 'Itineraries', 'Eco-Friendly', 'Stories'];
    } else if (widget.categoryId == 'shopping') {
      sections = ['About', 'Places', 'Safety', 'Facilities', 'Itineraries', 'Eco-Friendly', 'Stories'];
    } else {
      sections = _sections;
    }
    
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
              height: 40.h,
              child: ListView.builder(
                controller: _navScrollController,
                scrollDirection: Axis.horizontal,
                itemCount: sections.length,
                itemBuilder: (context, index) {
                  final isActive = index == _activeSectionIndex;
                  return Padding(
                    key: ValueKey('sticky-nav-tab-$index'),
                    padding: EdgeInsets.only(
                      right: index < sections.length - 1 ? 8.w : 0,
                    ),
                    child: _buildNavigationTab(sections[index], isActive, index),
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

  void _scrollToSection(int index) {
    // Get sections and keys based on category
    final List<String> sections;
    final List<GlobalKey> sectionKeys;
    
    if (widget.categoryId == 'nature') {
      sections = ['About', 'Places', 'Safety', 'Facilities', 'Itineraries', 'Eco-Friendly', 'Stories'];
      sectionKeys = [
        _aboutSectionKey,
        _naturePlacesSectionKey,
        _natureSafetySectionKey,
        _natureFacilitiesSectionKey,
        _natureItinerariesSectionKey,
        _natureEcoFriendlySectionKey,
        _natureStoriesSectionKey,
      ];
    } else if (widget.categoryId == 'adventure') {
      sections = ['About', 'Places', 'Trails', 'Safety', 'Facilities', 'Checklist', 'Tourism'];
      sectionKeys = [
        _aboutSectionKey,
        _sacredPlacesSectionKey,
        _circuitsSectionKey,
        _natureSafetySectionKey,
        _natureFacilitiesSectionKey,
        _natureItinerariesSectionKey,
        _natureEcoFriendlySectionKey,
      ];
    } else if (widget.categoryId == 'family') {
      sections = ['About', 'Places', 'Safety', 'Facilities', 'Itineraries', 'Eco-Friendly', 'Stories'];
      sectionKeys = [
        _aboutSectionKey,
        _sacredPlacesSectionKey,
        _natureSafetySectionKey,
        _natureFacilitiesSectionKey,
        _circuitsSectionKey,
        _natureEcoFriendlySectionKey,
        _natureStoriesSectionKey,
      ];
    } else if (widget.categoryId == 'culture') {
      sections = ['About', 'Places', 'Safety', 'Facilities', 'Itineraries', 'Eco-Friendly', 'Stories'];
      sectionKeys = [
        _aboutSectionKey,
        _sacredPlacesSectionKey,
        _natureSafetySectionKey,
        _natureFacilitiesSectionKey,
        _circuitsSectionKey,
        _natureEcoFriendlySectionKey,
        _natureStoriesSectionKey,
      ];
    } else if (widget.categoryId == 'shopping') {
      sections = ['About', 'Places', 'Safety', 'Facilities', 'Itineraries', 'Eco-Friendly', 'Stories'];
      sectionKeys = [
        _aboutSectionKey,
        _sacredPlacesSectionKey,
        _natureSafetySectionKey,
        _natureFacilitiesSectionKey,
        _circuitsSectionKey,
        _natureEcoFriendlySectionKey,
        _natureStoriesSectionKey,
      ];
    } else {
      sections = _sections;
      sectionKeys = [_aboutSectionKey, _sacredPlacesSectionKey, _circuitsSectionKey];
    }
    
    debugPrint('🔄 _scrollToSection called with index: $index, section: ${sections[index]}');
    debugPrint('📋 Total sections: ${sectionKeys.length}, Category: ${widget.categoryId}');
    if (index < 0 || index >= sectionKeys.length) {
      debugPrint('❌ Invalid index: $index (max: ${sectionKeys.length - 1})');
      return;
    }
    final key = sectionKeys[index];
    
    debugPrint('🔑 Checking key for section: ${sections[index]}');
    if (key.currentContext == null) {
      debugPrint('❌ Section key context is null for index: $index, section: ${sections[index]}');
      debugPrint('⏳ Waiting for context to be available...');
      // Wait a bit and try again
      Future.delayed(const Duration(milliseconds: 100), () {
        if (key.currentContext != null) {
          _scrollToSection(index); // Retry
        } else {
          debugPrint('❌ Context still null after delay');
        }
      });
      return;
    }
    debugPrint('✅ Key context found for section: ${sections[index]}');
    
    // Set flag to prevent scroll detection from overriding
    _isScrollingToSection = true;
    
    // Update active section index first
    setState(() {
      _activeSectionIndex = index;
    });
    
    // Calculate sticky nav bar height: ~61.h
    final stickyNavHeight = 61.0;
    
    // Also ensure sticky nav is shown when scrolling to a section
    if (!_showStickyNav) {
      setState(() {
        _showStickyNav = true;
      });
    }
    
    // Wait a frame to ensure everything is rendered, then scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = key.currentContext;
      if (context == null) {
        debugPrint('❌ Context is null after postFrameCallback');
        _isScrollingToSection = false;
        return;
      }
      
      debugPrint('✅ Scrolling to section: ${sections[index]}');
      
      // Get RenderBox to calculate exact scroll position
      final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null) {
        debugPrint('❌ RenderBox is null for section: ${sections[index]}');
        _isScrollingToSection = false;
        return;
      }
      
      // Use Scrollable.ensureVisible with proper alignment for sticky nav
      final screenHeight = MediaQuery.of(context).size.height;
      final alignment = _showStickyNav ? (stickyNavHeight / screenHeight) : 0.0;
      
      debugPrint('📍 Section: ${sections[index]}, Alignment: $alignment, StickyNav: $_showStickyNav');
      
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: alignment,
        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
      ).then((_) {
        debugPrint('✅ Scroll completed for: ${sections[index]}');
        Future.delayed(const Duration(milliseconds: 300), () {
          _isScrollingToSection = false;
        });
      }).catchError((Object error) {
        debugPrint('❌ Error scrolling to section: $error');
        _isScrollingToSection = false;
      });
    });
  }

  Widget _buildAboutTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // About Section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w), // Reduced margin
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Holy City of Ancient Devotion',
                style: _getTextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Nashik holds immense spiritual significance with its connection to the Ramayana, being a Kumbh Mela city, and home to one of India\'s holiest Jyotirlingas.',
                style: _getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        // Stats Card - 358X112
        Center(
          child: Container(
            width: 358.w,
            height: 112.h,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFEDD5), // #FFEDD5
                  Color(0xFFFEE2E2), // #FEE2E2
                ],
              ),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: const Color(0xFFE5E7EB), // Stroke E5E7EB
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Om symbol
                Text(
                  'ॐ',
                  style: TextStyle(
                    fontSize: 40.sp,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(width: 16.w),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '50+ Sacred Sites',
                        style: _getTextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Centuries of devotion and faith',
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
          ),
        ),
        SizedBox(height: 24.h),
        // Search Bar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w), // Reduced margin
          child: Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: const Color(0xFF9CA3AF), size: 20.sp),
                SizedBox(width: 12.w),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search spiritual places...',
                      hintStyle: _getTextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF9CA3AF),
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    style: _getTextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 32.h),
        // Live Aarti Timings
        _buildLiveAartiTimings(),
        SizedBox(height: 32.h),
        // Visitor Information
        _buildVisitorInformation(),
      ],
    );
  }

  Widget _buildSacredPlacesSubSection({
    required String title,
    required IconData icon,
    required List<Map<String, dynamic>> places,
    required String carouselKey,
  }) {
    final controller = _scrollControllers[carouselKey] ?? ScrollController();
    final currentPage = _currentPageIndices[carouselKey] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w), // Further reduced margin
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFFF97316), size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                title,
                style: _getTextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 200.h,
          child: ListView.builder(
            controller: controller,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12.w), // Further reduced margin
            itemCount: places.length,
            itemBuilder: (context, index) {
              final place = places[index];
              return Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: _buildSacredPlaceCard(
                  devanagari: (place['devanagari'] as String?) ?? '',
                  english: (place['english'] as String?) ?? '',
                  distance: (place['distance'] as String?) ?? '',
                  imagePath: (place['image'] as String?) ?? 'assets/png/trambak.png',
                  placeMap: place,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            places.length,
            (index) => Container(
              width: 8.w,
              height: 8.h,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentPage == index
                    ? const Color(0xFF000000)
                    : const Color(0xFFD9D9D9),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSacredPlaceCard({
    required String devanagari,
    required String english,
    required String distance,
    required String imagePath,
    Map<String, dynamic>? placeMap,
  }) {
    return GestureDetector(
      onTap: () {
        if (_places.isEmpty) return;
        
        // Find matching place from _places list by name
        // Try exact match first, then partial match
        Place matchingPlace;
        
        // Try exact match
        try {
          matchingPlace = _places.firstWhere(
            (place) => place.name.toLowerCase() == english.toLowerCase(),
          );
        } catch (e) {
          // Try partial match
          try {
            matchingPlace = _places.firstWhere(
              (place) {
                final placeNameLower = place.name.toLowerCase();
                final englishLower = english.toLowerCase();
                // Check if place name contains key words from english name or vice versa
                final englishWords = englishLower.split(' ');
                return englishWords.any((word) => placeNameLower.contains(word)) ||
                       placeNameLower.split(' ').any((word) => englishLower.contains(word));
              },
            );
          } catch (e2) {
            // If no match found, use first spiritual place
            matchingPlace = _places.firstWhere(
              (place) => place.categoryId.toLowerCase() == 'spiritual',
              orElse: () => _places.first,
            );
          }
        }
        
        // Navigate to place detail page
        context.push('/place/${matchingPlace.id}');
      },
      child: Container(
        width: 160.w,
        height: 200.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.white,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Stack(
            children: [
              Image.asset(
                imagePath,
                width: 160.w,
                height: 200.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFF3F4F6),
                    child: Icon(Icons.image_not_supported, size: 40.sp),
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
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
              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF97316),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    distance,
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      devanagari,
                      style: _getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      english,
                      style: _getTextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
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
        ),
      ),
    );
  }

  Widget _buildCircuitsTab() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Section Header
          Text(
            'Circuits',
            style: _getTextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Explore various spiritual circuits and pilgrimage routes in Nashik.',
            style: _getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircuitCard({
    required IconData icon,
    required String title,
    required String description,
    required String duration,
  }) {
    return Container(
      width: 358.w,
      height: 114.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h), // Reduced vertical padding
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED), // Background #FFF7ED
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFED7AA), width: 1), // Stroke #FED7AA
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top section with icon and content
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36.w, // Further reduced
                height: 36.w, // Further reduced
                decoration: BoxDecoration(
                  color: const Color(0xFFF97316).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: const Color(0xFFF97316), size: 18.sp), // Further reduced
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: _getTextStyle(
                        fontSize: 14.sp, // Further reduced
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F2937),
                        height: 1.2, // Added line height to reduce spacing
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h), // Further reduced
                    Text(
                      description,
                      style: _getTextStyle(
                        fontSize: 12.sp, // Further reduced
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B7280),
                        height: 1.2, // Added line height
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h), // Further reduced
                    Text(
                      duration,
                      style: _getTextStyle(
                        fontSize: 10.sp, // Further reduced
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF9CA3AF),
                        height: 1.2, // Added line height
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Bottom section with Start Journey button (right aligned)
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to circuit detail
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF97316),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h), // Further reduced
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Start Journey',
                style: _getTextStyle(
                  fontSize: 12.sp, // Further reduced
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.2, // Added line height
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSacredPlacesTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Section Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w), // Further reduced margin
          child: Text(
            'Sacred Places',
            style: _getTextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        // Temples Section
        _buildSacredPlacesSubSection(
          title: 'Temples',
          icon: Icons.temple_buddhist,
          places: _getTemplesList(),
          carouselKey: 'temples',
        ),
        SizedBox(height: 32.h),
        // Sacred Caves Section
        _buildSacredPlacesSubSection(
          title: 'Sacred Caves',
          icon: Icons.landscape,
          places: _getCavesList(),
          carouselKey: 'caves',
        ),
        SizedBox(height: 32.h),
        // Holy Ghats Section
        _buildSacredPlacesSubSection(
          title: 'Holy Ghats',
          icon: Icons.water_drop,
          places: _getGhatsList(),
          carouselKey: 'ghats',
        ),
      ],
    );
  }

  Widget _buildRecommendedCircuitsTab() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w), // Further reduced margin
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommended Pilgrimage Circuits',
            style: _getTextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 16.h),
          _buildCircuitCard(
            icon: Icons.self_improvement,
            title: 'Ramayana Circuit',
            description: 'Sita Gufa • Ramkund • Kalaram Mandir',
            duration: 'Duration: 4-5 hours',
          ),
          SizedBox(height: 12.h),
          _buildCircuitCard(
            icon: Icons.landscape,
            title: 'Jyotirlinga & Hills',
            description: 'Trimbakeshwar • Brahmagiri • Anjaneri',
            duration: 'Duration: Full day',
          ),
          SizedBox(height: 12.h),
          _buildCircuitCard(
            icon: Icons.eco,
            title: 'Meditation & Peace',
            description: 'Ashrams • Godavari Ghats • Meditation Centers',
            duration: 'Duration: 6-7 hours',
          ),
        ],
      ),
    );
  }

  Widget _buildLiveAartiTimings() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w), // Further reduced margin
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Single card with both aarti timings
          Center(
            child: Container(
              width: 358.w,
              height: 280.h, // Further increased height to fix overflow
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h), // Reduced vertical padding slightly
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Heading with icon inside card
                  Row(
                    children: [
                      Icon(Icons.access_time, color: const Color(0xFFF97316), size: 24.sp), // Increased icon size
                      SizedBox(width: 8.w),
                      Text(
                        'Live Aarti Timings',
                        style: _getTextStyle(
                          fontSize: 18.sp, // Increased heading size for better readability
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F2937),
                          height: 1.2, // Added line height
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h), // Slightly reduced spacing
                  // Trimbakeshwar card
                  _buildAartiTimingCard(
                    temple: 'Trimbakeshwar',
                    time: '5:30 AM',
                    aartiType: 'Morning Aarti',
                    isLive: true,
                  ),
                  SizedBox(height: 10.h), // Reduced spacing between cards
                  // Kalaram Mandir card
                  _buildAartiTimingCard(
                    temple: 'Kalaram Mandir',
                    time: '7:00 PM',
                    aartiType: 'Evening Aarti',
                    isLive: false,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAartiTimingCard({
    required String temple,
    required String time,
    required String aartiType,
    required bool isLive,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h), // Reduced vertical padding
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB), // Light background for inner card
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  temple,
                  style: _getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                    height: 1.1, // Reduced line height
                  ),
                ),
                SizedBox(height: 3.h), // Reduced spacing
                Text(
                  time,
                  style: _getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B7280),
                    height: 1.1, // Reduced line height
                  ),
                ),
                SizedBox(height: 3.h), // Reduced spacing
                Text(
                  aartiType,
                  style: _getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9CA3AF),
                    height: 1.1, // Reduced line height
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h), // Reduced vertical padding
            decoration: BoxDecoration(
              color: isLive ? const Color(0xFF10B981) : const Color(0xFF9CA3AF),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              isLive ? 'Live' : 'Upcoming',
              style: _getTextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.1, // Reduced line height
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitorInformation() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w), // Further reduced margin
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Visitor Information',
            style: _getTextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 16.h),
          // Best Time to Visit Card
          Center(
            child: Container(
              width: 358.w,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _buildVisitorInfoItem(
                icon: Icons.calendar_today,
                text: 'October to March, during Kumbh Mela (every 12 years)',
                title: 'Best Time to Visit',
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Dress Code Card
          Center(
            child: Container(
              width: 358.w,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _buildVisitorInfoItem(
                icon: Icons.checkroom,
                text: 'Modest clothing, remove shoes in temples',
                title: 'Dress Code',
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Transportation Card
          Center(
            child: Container(
              width: 358.w,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _buildVisitorInfoItem(
                icon: Icons.directions_bus,
                text: 'Auto-rickshaws, city buses, taxi rentals available',
                title: 'Transportation',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitorInfoItem({
    required IconData icon,
    required String text,
    String? title,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: const Color(0xFFF97316).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: const Color(0xFFF97316), size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null) ...[
                Text(
                  title,
                  style: _getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 4.h),
              ],
              Text(
                text,
                style: _getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildEcoSpiritualMessage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w), // Further reduced margin
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFD1FAE5), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.eco, color: const Color(0xFF10B981), size: 24.sp),
                SizedBox(width: 8.w),
                Text(
                  'Eco-Spiritual Message',
                  style: _getTextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _buildEcoMessagePoint('Keep holy ghats and temples clean'),
            SizedBox(height: 8.h),
            _buildEcoMessagePoint('Maintain silence in meditation zones'),
            SizedBox(height: 8.h),
            _buildEcoMessagePoint('Respect local customs and rituals'),
            SizedBox(height: 8.h),
            _buildEcoMessagePoint('Use eco-friendly offerings'),
          ],
        ),
      ),
    );
  }

  Widget _buildEcoMessagePoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, color: const Color(0xFF10B981), size: 20.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: _getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1F2937),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  // Mock data methods
  List<Map<String, dynamic>> _getTemplesList() {
    return [
      {
        'devanagari': 'श्री त्र्यंबकेश्वर ज्योतिलिंग',
        'english': 'Trimbakeshwar Temple',
        'distance': '25 km Away',
        'image': 'assets/png/trambak.png',
      },
      {
        'devanagari': 'श्री गजानन महाराज',
        'english': 'Shree Gajanan Maharaj',
        'distance': '25 km Away',
        'image': 'assets/png/trambak.png',
      },
      {
        'devanagari': 'कालाराम मंदिर',
        'english': 'Kalaram Temple',
        'distance': '8 km Away',
        'image': 'assets/png/trambak.png',
      },
    ];
  }

  List<Map<String, dynamic>> _getCavesList() {
    return [
      {
        'devanagari': 'पांडव लेणी',
        'english': 'Pandav Leni',
        'distance': '4 km Away',
        'image': 'assets/png/trambak.png',
      },
      {
        'devanagari': 'सीता गुहा',
        'english': 'Seeta Ghufa',
        'distance': '4 km Away',
        'image': 'assets/png/trambak.png',
      },
    ];
  }

  List<Map<String, dynamic>> _getGhatsList() {
    return [
      {
        'devanagari': 'कुशावर्त कुंड',
        'english': 'Kushavart Kund',
        'distance': '27 km Away',
        'image': 'assets/png/trambak.png',
      },
      {
        'devanagari': 'गोदावरी घाट',
        'english': 'Godavari Ghat',
        'distance': '27 km Away',
        'image': 'assets/png/trambak.png',
      },
    ];
  }

  // Basic page methods (for non-spiritual categories)
  Widget _buildCategoryHero() {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(_category!.imagePath),
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
          child: Text(
            _category!.name,
            style: _getTextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignificanceSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About ${_category!.name}',
            style: _getTextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            _category!.significance,
            style: _getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.normal,
              color: const Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlacesSection() {
    if (_places.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Center(
          child: Text(
            'No places found in this category',
            style: _getTextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF6B7280),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'Places to Explore',
            style: _getTextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _places.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                bottom: 16.h,
              ),
              child: _buildPlaceCard(_places[index]),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPlaceCard(Place place) {
    return GestureDetector(
      onTap: () {
        context.push('/place/${place.id}');
      },
      child: Container(
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
                place.imageUrls.isNotEmpty ? place.imageUrls.first : 'assets/png/trambak.png',
                width: 80.w,
                height: 80.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80.w,
                    height: 80.w,
                    color: const Color(0xFFF3F4F6),
                    child: Icon(Icons.image_not_supported, size: 32.sp),
                  );
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: _getTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    place.description,
                    style: _getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6B7280),
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
    );
  }

  // ==================== NATURE PAGE METHODS ====================

  Widget _buildNatureHeroSection() {
    return Container(
      width: double.infinity,
      height: 350.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(_category?.imagePath ?? 'assets/png/trambak.png'),
          fit: BoxFit.cover,
        ),
        color: const Color(0xFFF3F4F6),
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Breathe in the Green',
                style: _getTextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Discover Nature in Nashik',
                style: _getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  _buildNatureBulletPoint('Vineyards'),
                  SizedBox(width: 8.w),
                  _buildNatureBulletPoint('Waterfalls'),
                  SizedBox(width: 8.w),
                  _buildNatureBulletPoint('Treks & Hills'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNatureBulletPoint(String text) {
    return Text(
      '• $text',
      style: _getTextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    );
  }

  Widget _buildNatureAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildNatureKeyStatistics(),
        SizedBox(height: 32.h),
        _buildThrillAwaitsSection(),
        SizedBox(height: 32.h),
        Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: const Color(0xFF9CA3AF), size: 20.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search nature places...',
                    hintStyle: _getTextStyle(fontSize: 14.sp, color: const Color(0xFF9CA3AF)),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  style: _getTextStyle(fontSize: 14.sp, color: const Color(0xFF1F2937)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNatureKeyStatistics() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatCard('15+', 'Adventure Spots', const Color(0xFF10B981)),
        SizedBox(width: 12.w),
        _buildStatCard('10', 'Vineyards', const Color(0xFF3B82F6)),
        SizedBox(width: 12.w),
        _buildStatCard('5', 'Waterfalls', const Color(0xFFF97316)),
      ],
    );
  }

  Widget _buildStatCard(String number, String label, Color color) {
    return Expanded(
      child: Container(
        height: 100.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              number,
              style: _getTextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: color,
                height: 1.0,
              ),
            ),
            SizedBox(height: 4.h),
            Flexible(
              child: Text(
                label,
                style: _getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThrillAwaitsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Thrill Awaits You', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
        SizedBox(height: 12.h),
        Text('Discover Nashik\'s adventurous side with thrilling treks, river rafting, camping, and cave explorations for unforgettable experiences.', style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280), height: 1.5), textAlign: TextAlign.center),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFFFEDD5), Color(0xFFFEE2E2)]),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.hiking, color: const Color(0xFFEF4444), size: 40.sp),
              SizedBox(height: 12.h),
              Text('150+ Adventurous Sites', style: _getTextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
              SizedBox(height: 4.h),
              Text('Centuries of Nature, Adventure, and Discovery', style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280)), textAlign: TextAlign.center),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNaturePlacesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Places', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
            SizedBox(width: 8.w),
            Icon(Icons.landscape, color: const Color(0xFF10B981), size: 20.sp),
            SizedBox(width: 4.w),
            Text('Nature Spots', style: _getTextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: const Color(0xFF10B981))),
          ],
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 0, right: 0),
            itemCount: _places.length > 5 ? 5 : _places.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: _buildNaturePlaceCard(_places[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNaturePlaceCard(Place place) {
    return GestureDetector(
      onTap: () => context.push('/place/${place.id}'),
      child: Container(
        width: 160.w,
        height: 200.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r), color: Colors.white),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Stack(
            children: [
              Image.asset(place.imageUrls.isNotEmpty ? place.imageUrls.first : 'assets/png/trambak.png', width: 160.w, height: 200.h, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFFF3F4F6), child: Icon(Icons.image_not_supported, size: 40.sp))),
              Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)]))),
              Positioned(top: 12.h, right: 12.w, child: Container(padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h), decoration: BoxDecoration(color: const Color(0xFFF97316), borderRadius: BorderRadius.circular(4.r)), child: Text('Nature', style: _getTextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: Colors.white)))),
              Positioned(bottom: 12.h, left: 12.w, right: 12.w, child: Text(place.name, style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.white, height: 1.2), maxLines: 2, overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSafetyEssentialsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Safety & Essentials', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: const Color(0xFFEF4444), width: 1.5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [Icon(Icons.warning, color: const Color(0xFFEF4444), size: 24.sp), SizedBox(width: 8.w), Text('Important Safety Tips', style: _getTextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937)))]),
              SizedBox(height: 12.h),
              _buildSafetyTip('Avoid trekking during heavy monsoon'),
              SizedBox(height: 8.h),
              _buildSafetyTip('Carry sufficient water and snacks'),
              SizedBox(height: 8.h),
              _buildSafetyTip('Inform someone about your trek plan'),
              SizedBox(height: 8.h),
              _buildSafetyTip('Use proper trekking shoes'),
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
        Container(margin: EdgeInsets.only(top: 6.h), width: 6.w, height: 6.h, decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle)),
        SizedBox(width: 8.w),
        Expanded(child: Text(text, style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF1F2937), height: 1.4))),
      ],
    );
  }

  Widget _buildNearbyFacilitiesSection() {
    final isFamily = widget.categoryId == 'family';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nearby Facilities', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
        SizedBox(height: 16.h),
        Row(children: [Expanded(child: _buildFacilityCard(Icons.hotel, 'Stay', 'Hotels & Campsites', const Color(0xFF3B82F6))), SizedBox(width: 12.w), Expanded(child: _buildFacilityCard(Icons.restaurant, 'Food', 'Local Dhabas', const Color(0xFFF97316)))]),
        SizedBox(height: 12.h),
        Row(children: [Expanded(child: _buildFacilityCard(Icons.people, 'Guides', 'Local Experts', const Color(0xFF10B981))), SizedBox(width: 12.w), Expanded(child: _buildFacilityCard(Icons.local_hospital, isFamily ? 'Medical Aid' : 'Safety', 'Emergency Services', const Color(0xFF8B5CF6)))]),
      ],
    );
  }

  Widget _buildFacilityCard(IconData icon, String title, String subtitle, Color color) {
    return Container(
      height: 100.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: const Color(0xFFE5E7EB), width: 1)),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: _getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 3.h),
                Flexible(
                  child: Text(
                    subtitle,
                    style: _getTextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6B7280),
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedItinerariesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recommended Itineraries', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
        SizedBox(height: 16.h),
        _buildItineraryCard(title: '1-Day Adventure', badge: 'Perfect for beginners', badgeColor: const Color(0xFF10B981), places: 'Someshwar Waterfall + Gangapur Dam', duration: '6-7 hours', price: 'Rs 800/person'),
        SizedBox(height: 12.h),
        _buildItineraryCard(title: '2-Day Adventure', badge: 'For enthusiasts', badgeColor: const Color(0xFFF97316), places: 'Anjaneri Fort Trek + Pahine Waterfall', duration: '2 days', price: 'Rs 2500/person'),
      ],
    );
  }

  Widget _buildItineraryCard({required String title, required String badge, required Color badgeColor, required String places, required String duration, required String price}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: const Color(0xFFE5E7EB), width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Text(title, style: _getTextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))), SizedBox(width: 8.w), Container(padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h), decoration: BoxDecoration(color: badgeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4.r)), child: Text(badge, style: _getTextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: badgeColor)))]),
          SizedBox(height: 8.h),
          Text(places, style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280))),
          SizedBox(height: 12.h),
          Row(children: [Icon(Icons.access_time, size: 16.sp, color: const Color(0xFF9CA3AF)), SizedBox(width: 4.w), Text(duration, style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280))), SizedBox(width: 16.w), Icon(Icons.currency_rupee, size: 16.sp, color: const Color(0xFF9CA3AF)), SizedBox(width: 4.w), Text(price, style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280)))]),
          SizedBox(height: 12.h),
          Align(
            alignment: Alignment.bottomRight,
            child: Text('View Details', style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF3B82F6))),
          ),
        ],
      ),
    );
  }

  Widget _buildEcoFriendlyTravelSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: const Color(0xFF10B981), width: 1.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(Icons.eco, color: const Color(0xFF10B981), size: 24.sp), SizedBox(width: 8.w), Text('Eco-Friendly Travel', style: _getTextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937)))]),
          SizedBox(height: 12.h),
          Text('Help preserve Nashik\'s natural beauty for future generations', style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280), height: 1.5)),
          SizedBox(height: 16.h),
          Row(children: [Expanded(child: Column(children: [Icon(Icons.water_drop, color: const Color(0xFF10B981), size: 24.sp), SizedBox(height: 8.h), Text('Carry water bottles', style: _getTextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280)), textAlign: TextAlign.center)])), Expanded(child: Column(children: [Icon(Icons.delete_outline, color: const Color(0xFF10B981), size: 24.sp), SizedBox(height: 8.h), Text('No littering', style: _getTextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280)), textAlign: TextAlign.center)]))]),
          SizedBox(height: 16.h),
          Row(children: [Expanded(child: Column(children: [Icon(Icons.support_agent, color: const Color(0xFF10B981), size: 24.sp), SizedBox(height: 8.h), Text('Support locals', style: _getTextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280)), textAlign: TextAlign.center)])), Expanded(child: Column(children: [Icon(Icons.camera_alt, color: const Color(0xFF10B981), size: 24.sp), SizedBox(height: 8.h), Text('Take only photos', style: _getTextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280)), textAlign: TextAlign.center)]))]),
        ],
      ),
    );
  }

  Widget _buildTravelStoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Travel Stories', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
        SizedBox(height: 16.h),
        SizedBox(
          height: 280.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) => Padding(padding: EdgeInsets.only(right: 12.w), child: _buildTravelStoryCard(index)),
          ),
        ),
      ],
    );
  }

  Widget _buildTravelStoryCard(int index) {
    final stories = [
      {'image': 'assets/png/trambak.png', 'quote': 'Amazing waterfall experience!', 'avatar': 'assets/png/trambak.png', 'name': 'Sarah'},
      {'image': 'assets/png/trambak.png', 'quote': 'Perfect trek with friends', 'avatar': 'assets/png/trambak.png', 'name': 'John'},
      {'image': 'assets/png/trambak.png', 'quote': 'Romantic vineyard date', 'avatar': 'assets/png/trambak.png', 'name': 'Emma'},
    ];
    final story = stories[index % stories.length];
    return Container(
      width: 200.w,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: const Color(0xFFE5E7EB), width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(borderRadius: BorderRadius.only(topLeft: Radius.circular(12.r), topRight: Radius.circular(12.r)), child: Image.asset(story['image'] as String, width: 200.w, height: 150.h, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(height: 150.h, color: const Color(0xFFF3F4F6), child: Icon(Icons.image_not_supported, size: 40.sp)))),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(children: [CircleAvatar(radius: 16.r, backgroundImage: AssetImage(story['avatar'] as String), onBackgroundImageError: (_, __) {}), SizedBox(width: 8.w), Expanded(child: Text('"${story['quote'] as String}"', style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF1F2937)), maxLines: 2, overflow: TextOverflow.ellipsis))]),
          ),
        ],
      ),
    );
  }

  // ==================== ADVENTURE PAGE METHODS ====================

  Widget _buildAdventurePage() {
    // Adventure category sections
    final List<String> adventureSections = [
      'About',
      'Places',
      'Trails',
      'Safety',
      'Facilities',
      'Checklist',
      'Tourism',
    ];
    
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _mainScrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAdventureHeroSection(),
              Transform.translate(
                offset: Offset(0, -20.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                      bottomLeft: Radius.zero,
                      bottomRight: Radius.zero,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 44.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: adventureSections.length,
                                itemBuilder: (context, index) {
                                  final isActive = index == _activeSectionIndex;
                                  return Padding(
                                    key: ValueKey('nav-tab-$index'),
                                    padding: EdgeInsets.only(
                                      right: index < adventureSections.length - 1 ? 8.w : 0,
                                    ),
                                    child: _buildNavigationTab(adventureSections[index], isActive, index),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Container(height: 1.h, color: const Color(0xFFE5E7EB)),
                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildSectionContainer(key: _aboutSectionKey, child: _buildAdventureAboutSection()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _sacredPlacesSectionKey, child: _buildAdventurePlacesSection()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _circuitsSectionKey, child: _buildRecommendedAdventureTrailsSection()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _natureSafetySectionKey, child: _buildSafetyEssentialsSection()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _natureFacilitiesSectionKey, child: _buildNearbyFacilitiesSection()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _natureItinerariesSectionKey, child: _buildAdventureChecklistSection()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _natureEcoFriendlySectionKey, child: _buildResponsibleTourismSection()),
                          ],
                        ),
                      ),
                    ],
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

  Widget _buildAdventureHeroSection() {
    return Container(
      width: double.infinity,
      height: 350.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(_category?.imagePath ?? 'assets/png/trambak.png'),
          fit: BoxFit.cover,
        ),
        color: const Color(0xFFF3F4F6),
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Unleash Your Adventure', style: _getTextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700, color: Colors.white, height: 1.2)),
              SizedBox(height: 8.h),
              Text('Explore Nashik\'s Wild Side', style: _getTextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.white, height: 1.3)),
              SizedBox(height: 12.h),
              Wrap(spacing: 8.w, children: [_buildAdventureBulletPoint('Caves'), _buildAdventureBulletPoint('Waterfalls'), _buildAdventureBulletPoint('Treks'), _buildAdventureBulletPoint('Sports')]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdventureBulletPoint(String text) {
    return Text('• $text', style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white));
  }

  Widget _buildAdventureAboutSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [_buildAdventureKeyStatistics(), SizedBox(height: 32.h), _buildThrillAwaitsSection(), SizedBox(height: 32.h), Container(height: 48.h, padding: EdgeInsets.symmetric(horizontal: 16.w), decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(8.r), border: Border.all(color: const Color(0xFFE5E7EB), width: 1)), child: Row(children: [Icon(Icons.search, color: const Color(0xFF9CA3AF), size: 20.sp), SizedBox(width: 12.w), Expanded(child: TextField(decoration: InputDecoration(hintText: 'Search adventure places...', hintStyle: _getTextStyle(fontSize: 14.sp, color: const Color(0xFF9CA3AF)), border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none, contentPadding: EdgeInsets.zero, isDense: true), style: _getTextStyle(fontSize: 14.sp, color: const Color(0xFF1F2937))))]))]);
  }

  Widget _buildAdventureKeyStatistics() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_buildStatCard('15+', 'Adventure Spots', const Color(0xFF10B981)), SizedBox(width: 12.w), _buildStatCard('8', 'Trek Routes', const Color(0xFF3B82F6)), SizedBox(width: 12.w), _buildStatCard('5', 'Waterfalls', const Color(0xFFEF4444))]);
  }

  Widget _buildAdventurePlacesSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [Text('Places', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))), SizedBox(width: 8.w), Icon(Icons.landscape, color: const Color(0xFFF97316), size: 20.sp), SizedBox(width: 4.w), Text('Adventurous Spots', style: _getTextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: const Color(0xFFF97316)))]), Text('View more', style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF3B82F6)))]), SizedBox(height: 16.h), SizedBox(height: 200.h, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: _places.length > 5 ? 5 : _places.length, itemBuilder: (context, index) => Padding(padding: EdgeInsets.only(right: 12.w), child: _buildAdventurePlaceCard(_places[index], index))))]);
  }

  Widget _buildAdventurePlaceCard(Place place, int index) {
    final distances = ['14 km away', '26 km away', '18 km away', '32 km away', '22 km away'];
    final distance = distances[index % distances.length];
    return GestureDetector(onTap: () => context.push('/place/${place.id}'), child: Container(width: 160.w, height: 200.h, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r), color: Colors.white), child: ClipRRect(borderRadius: BorderRadius.circular(12.r), child: Stack(children: [Image.asset(place.imageUrls.isNotEmpty ? place.imageUrls.first : 'assets/png/trambak.png', width: 160.w, height: 200.h, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFFF3F4F6), child: Icon(Icons.image_not_supported, size: 40.sp))), Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)]))), Positioned(top: 12.h, right: 12.w, child: Container(padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h), decoration: BoxDecoration(color: const Color(0xFFF97316), borderRadius: BorderRadius.circular(4.r)), child: Text(distance, style: _getTextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: Colors.white)))), Positioned(bottom: 12.h, left: 12.w, right: 12.w, child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text(place.name, style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.white, height: 1.2), maxLines: 2, overflow: TextOverflow.ellipsis)]))]))));
  }

  Widget _buildRecommendedAdventureTrailsSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Recommended Adventure Trails', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))), SizedBox(height: 16.h), _buildAdventureTrailCard(title: '1-Day Adventure', badge: 'Perfect for beginners', badgeColor: const Color(0xFF10B981), places: 'Pahine Waterfall + Anjaneri Hills', duration: '6-7 hours', showViewDetails: true), SizedBox(height: 12.h), _buildAdventureTrailCard(title: '2-Day Adventure', badge: 'For enthusiasts', badgeColor: const Color(0xFFF97316), places: 'Harihar Fort Trek + Dugarwadi Waterfall', duration: '2 days', showViewDetails: true)]);
  }

  Widget _buildAdventureTrailCard({required String title, required String badge, required Color badgeColor, required String places, required String duration, required bool showViewDetails}) {
    return Container(padding: EdgeInsets.all(16.w), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: const Color(0xFFE5E7EB), width: 1)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: _getTextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))), Container(padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h), decoration: BoxDecoration(color: badgeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4.r)), child: Text(badge, style: _getTextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: badgeColor)))]), SizedBox(height: 8.h), Text(places, style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280))), SizedBox(height: 12.h), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [Icon(Icons.access_time, size: 16.sp, color: const Color(0xFF9CA3AF)), SizedBox(width: 4.w), Text(duration, style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280)))]), if (showViewDetails) Text('View Details', style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFFF97316)))])]));
  }

  Widget _buildAdventureChecklistSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Adventure Checklist', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildChecklistCard('Trekking Shoes'),
                  SizedBox(height: 12.h),
                  _buildChecklistCard('First Aid Kit'),
                  SizedBox(height: 12.h),
                  _buildChecklistCard('Energy Snacks'),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildChecklistCard('Water Bottle'),
                  SizedBox(height: 12.h),
                  _buildChecklistCard('Rain Gear'),
                  SizedBox(height: 12.h),
                  _buildChecklistCard('Phone Charger'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChecklistCard(String text) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(Icons.check_circle, color: const Color(0xFF10B981), size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: _getTextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1F2937),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsibleTourismSection() {
    final tourismCards = [
      {'icon': Icons.favorite, 'text': 'Take only memories, leave only footprints'},
      {'icon': Icons.people, 'text': 'Support local guides and communities'},
      {'icon': Icons.recycling, 'text': 'Carry your trash back with you'},
      {'icon': Icons.park, 'text': 'Respect wildlife and natural habitats'},
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Responsible Tourism', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
        SizedBox(height: 16.h),
        SizedBox(
          height: 80.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tourismCards.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: index < tourismCards.length - 1 ? 12.w : 0),
                child: _buildTourismCard(
                  tourismCards[index]['icon'] as IconData,
                  tourismCards[index]['text'] as String,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTourismCard(IconData icon, String text) {
    return Container(
      width: 280.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF10B981), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: const Color(0xFF10B981), size: 24.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: _getTextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1F2937),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== FAMILY PAGE METHODS ====================

  Widget _buildFamilyPage() {
    final List<String> familySections = ['About', 'Places', 'Safety', 'Facilities', 'Itineraries', 'Eco-Friendly', 'Stories'];
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _mainScrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFamilyHeroSection(),
              Transform.translate(
                offset: Offset(0, -20.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r), bottomLeft: Radius.zero, bottomRight: Radius.zero),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 44.h, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: familySections.length, itemBuilder: (context, index) {
                              final isActive = index == _activeSectionIndex;
                              return Padding(key: ValueKey('nav-tab-$index'), padding: EdgeInsets.only(right: index < familySections.length - 1 ? 8.w : 0), child: _buildNavigationTab(familySections[index], isActive, index));
                            })),
                            SizedBox(height: 20.h),
                            Container(height: 1.h, color: const Color(0xFFE5E7EB)),
                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildSectionContainer(key: _aboutSectionKey, child: _buildFamilyAboutSection()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _sacredPlacesSectionKey, child: _buildFamilyPlacesSection()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _natureSafetySectionKey, child: _buildFamilySafetyEssentialsSection()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _natureFacilitiesSectionKey, child: _buildNearbyFacilitiesSection()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _circuitsSectionKey, child: _buildRecommendedFamilyItinerariesSection()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _natureEcoFriendlySectionKey, child: _buildEcoFriendlyTravelSection()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _natureStoriesSectionKey, child: _buildTravelStoriesSection()),
                          ],
                        ),
                      ),
                    ],
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

  Widget _buildFamilyHeroSection() {
    return Container(
      width: double.infinity,
      height: 350.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(_category?.imagePath ?? 'assets/png/trambak.png'),
          fit: BoxFit.cover,
        ),
        color: const Color(0xFFF3F4F6),
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Breathe in the Green', style: _getTextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700, color: Colors.white, height: 1.2)),
              SizedBox(height: 8.h),
              Text('Discover Nature in Nashik', style: _getTextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.white, height: 1.3)),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 8.w,
                children: [
                  _buildFamilyBulletPoint('Picnic Spot'),
                  _buildFamilyBulletPoint('Kids-Friendly'),
                  _buildFamilyBulletPoint('Garden & park'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFamilyBulletPoint(String text) {
    return Text('• $text', style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white));
  }

  Widget _buildFamilyAboutSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [_buildFamilyKeyStatistics(), SizedBox(height: 32.h), _buildFamilyFriendlyNashikSection(), SizedBox(height: 32.h), _buildFamilyFriendlySitesCard(), SizedBox(height: 32.h), Container(height: 48.h, padding: EdgeInsets.symmetric(horizontal: 16.w), decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(8.r), border: Border.all(color: const Color(0xFFE5E7EB), width: 1)), child: Row(children: [Icon(Icons.search, color: const Color(0xFF9CA3AF), size: 20.sp), SizedBox(width: 12.w), Expanded(child: TextField(decoration: InputDecoration(hintText: 'Search family friendly places...', hintStyle: _getTextStyle(fontSize: 14.sp, color: const Color(0xFF9CA3AF)), border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none, contentPadding: EdgeInsets.zero, isDense: true), style: _getTextStyle(fontSize: 14.sp, color: const Color(0xFF1F2937))))]))]);
  }

  Widget _buildFamilyKeyStatistics() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_buildStatCard('15+', 'Kids-friendly spots', const Color(0xFF10B981)), SizedBox(width: 12.w), _buildStatCard('10', 'Easy-access spots', const Color(0xFF3B82F6)), SizedBox(width: 12.w), _buildStatCard('5', 'Food points nearby', const Color(0xFFF97316))]);
  }

  Widget _buildFamilyFriendlyNashikSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [Text('Family-Friendly Nashik', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937)), textAlign: TextAlign.center), SizedBox(height: 12.h), Text('Safe, comfortable and memorable places in Nashik for families, kids and elders. Create beautiful memories together at these carefully curated spots.', style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280), height: 1.5), textAlign: TextAlign.center)]);
  }

  Widget _buildFamilyFriendlySitesCard() {
    return Container(width: double.infinity, padding: EdgeInsets.all(20.w), decoration: BoxDecoration(gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFFFEDD5), Color(0xFFFEE2E2)]), borderRadius: BorderRadius.circular(12.r), border: Border.all(color: const Color(0xFFE5E7EB), width: 1)), child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [Icon(Icons.family_restroom, color: const Color(0xFFEF4444), size: 40.sp), SizedBox(height: 12.h), Text('35+ Family Friendly Sites', style: _getTextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))), SizedBox(height: 4.h), Text('Discover Nature in Nashik', style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280)), textAlign: TextAlign.center)]));
  }

  Widget _buildFamilyPlacesSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Family-Friendly Places', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))), Text('View More', style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF3B82F6)))]), SizedBox(height: 16.h), ...List.generate(_places.length > 3 ? 3 : _places.length, (index) => Padding(padding: EdgeInsets.only(bottom: index < 2 ? 16.h : 0), child: _buildFamilyPlaceCard(_places[index], index)))]);  }

  Widget _buildFamilyPlaceCard(Place place, int index) {
    final tags = [['Kids-Friendly', const Color(0xFF10B981)], ['Picnic Spot', const Color(0xFFFBBF24)], ['Easy Access', const Color(0xFF3B82F6)]];
    final placeTags = [['Stroller-Friendly', 'Food Nearby', 'Play Area'], ['Restrooms Available', 'Shade/Seating', 'Food Nearby'], ['Stroller-Friendly', 'Restrooms', 'Shade/Seating']];
    final distances = ['12 km away • 25 min drive', '0 km away • 18 min drive', '15 km away • 30 min drive'];
    final tag = tags[index % tags.length];
    final placeTagList = placeTags[index % placeTags.length];
    final distance = distances[index % distances.length];
    return GestureDetector(
      onTap: () => context.push('/place/${place.id}'),
      child: Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: const Color(0xFFE5E7EB), width: 1)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(children: [
          ClipRRect(borderRadius: BorderRadius.only(topLeft: Radius.circular(12.r), topRight: Radius.circular(12.r)), child: Image.asset(place.imageUrls.isNotEmpty ? place.imageUrls.first : 'assets/png/trambak.png', width: double.infinity, height: 180.h, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(height: 180.h, color: const Color(0xFFF3F4F6), child: Icon(Icons.image_not_supported, size: 40.sp)))),
          Positioned(top: 12.h, left: 12.w, child: Container(padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h), decoration: BoxDecoration(color: tag[1] as Color, borderRadius: BorderRadius.circular(4.r)), child: Text(tag[0] as String, style: _getTextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: Colors.white)))),
          Positioned(top: 12.h, right: 12.w, child: Container(padding: EdgeInsets.all(8.w), decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))]), child: Icon(Icons.favorite_border, color: const Color(0xFFEF4444), size: 20.sp))),
        ]),
        Padding(padding: EdgeInsets.all(16.w), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(place.name, style: _getTextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))), SizedBox(height: 8.h), Row(children: [Icon(Icons.location_on, size: 16.sp, color: const Color(0xFF9CA3AF)), SizedBox(width: 4.w), Text(distance, style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280)))]), SizedBox(height: 12.h), Wrap(spacing: 8.w, runSpacing: 8.h, children: placeTagList.map((tagText) => Container(padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h), decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(4.r), border: Border.all(color: const Color(0xFFE5E7EB), width: 1)), child: Text(tagText, style: _getTextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280))))).toList())])),
      ]),
      ),
    );
  }

  Widget _buildRecommendedFamilyItinerariesSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Recommended Itineraries', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))), SizedBox(height: 16.h), _buildFamilyItineraryCard(title: '1-Day Picnic', badge: 'Perfect for beginners', badgeColor: const Color(0xFF10B981), places: 'Someshwar Waterfall + Food Street', duration: '6-7 hours', showViewDetails: true), SizedBox(height: 12.h), _buildFamilyItineraryCard(title: '2-Day Picnic', badge: 'All Ages', badgeColor: const Color(0xFFF97316), places: 'Sula Vineyards (Family Area) + Eco Park', duration: '2 days', showViewDetails: true)]);
  }

  Widget _buildFamilyItineraryCard({required String title, required String badge, required Color badgeColor, required String places, required String duration, required bool showViewDetails}) {
    return Container(padding: EdgeInsets.all(16.w), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: const Color(0xFFE5E7EB), width: 1)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: _getTextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))), Container(padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h), decoration: BoxDecoration(color: badgeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4.r)), child: Text(badge, style: _getTextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: badgeColor)))]), SizedBox(height: 8.h), Text(places, style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280))), SizedBox(height: 12.h), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [Icon(Icons.access_time, size: 16.sp, color: const Color(0xFF9CA3AF)), SizedBox(width: 4.w), Text(duration, style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280)))]), if (showViewDetails) Text('View Details', style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFFF97316)))])]));
  }

  Widget _buildFamilySafetyEssentialsSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Safety & Essentials', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))), SizedBox(height: 16.h), Container(width: double.infinity, padding: EdgeInsets.all(16.w), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: const Color(0xFFEF4444), width: 1.5)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(Icons.warning, color: const Color(0xFFEF4444), size: 24.sp), SizedBox(width: 8.w), Text('Important Safety Tips', style: _getTextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937)))]), SizedBox(height: 12.h), _buildFamilySafetyTip('Carry water bottles and caps for kids'), SizedBox(height: 8.h), _buildFamilySafetyTip('Choose spots with easy parking access'), SizedBox(height: 8.h), _buildFamilySafetyTip('Elder-friendly walking levels available'), SizedBox(height: 8.h), _buildFamilySafetyTip('Avoid visiting during peak heat hours (12 PM - 3 PM)')]))]);
  }

  Widget _buildFamilySafetyTip(String text) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(margin: EdgeInsets.only(top: 6.h), width: 6.w, height: 6.h, decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle)), SizedBox(width: 8.w), Expanded(child: Text(text, style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF1F2937), height: 1.4)))]);
  }

  // ==================== CULTURE PAGE METHODS ====================

  Widget _buildCulturePage() {
    final List<String> cultureSections = ['About', 'Places', 'Safety', 'Facilities', 'Itineraries', 'Eco-Friendly', 'Stories'];
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _mainScrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCultureHeroSection(),
              Transform.translate(
                offset: Offset(0, -20.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r), bottomLeft: Radius.zero, bottomRight: Radius.zero),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 44.h, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: cultureSections.length, itemBuilder: (context, index) {
                              final isActive = index == _activeSectionIndex;
                              return Padding(key: ValueKey('nav-tab-$index'), padding: EdgeInsets.only(right: index < cultureSections.length - 1 ? 8.w : 0), child: _buildNavigationTab(cultureSections[index], isActive, index));
                            })),
                            SizedBox(height: 20.h),
                            Container(height: 1.h, color: const Color(0xFFE5E7EB)),
                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildSectionContainer(key: _aboutSectionKey, child: _buildCultureAboutSection()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _sacredPlacesSectionKey, child: _buildCulturePlacesSection()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _natureSafetySectionKey, child: _buildCultureSafetyEssentialsSection()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _natureFacilitiesSectionKey, child: _buildCultureNearbyFacilitiesSection()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _circuitsSectionKey, child: _buildCultureCircuitsSection()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _natureEcoFriendlySectionKey, child: _buildCultureEcoFriendlyTravelSection()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _natureStoriesSectionKey, child: _buildTravelStoriesSection()),
                            SizedBox(height: 32.h),
                          ],
                        ),
                      ),
                    ],
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

  Widget _buildCultureHeroSection() {
    return Container(
      width: double.infinity,
      height: 350.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(_category?.imagePath ?? 'assets/png/trambak.png'),
          fit: BoxFit.cover,
        ),
        color: const Color(0xFFF3F4F6),
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Experience the Culture of Nashik', style: _getTextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700, color: Colors.white, height: 1.2)),
              SizedBox(height: 8.h),
              Text('Explore sacred sites, heritage landmarks, festivals', style: _getTextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.white, height: 1.3)),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 8.w,
                children: [
                  _buildCultureBulletPoint('Temples'),
                  _buildCultureBulletPoint('Festivals'),
                  _buildCultureBulletPoint('Ghats'),
                  _buildCultureBulletPoint('Local Art'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCultureBulletPoint(String text) {
    return Text('• $text', style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white));
  }

  Widget _buildCultureAboutSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      _buildCultureKeyStatistics(),
      SizedBox(height: 32.h),
      _buildCultureHeritageSection(),
      SizedBox(height: 32.h),
      _buildCultureHistoryCard(),
      SizedBox(height: 32.h),
      Container(height: 48.h, padding: EdgeInsets.symmetric(horizontal: 16.w), decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(8.r), border: Border.all(color: const Color(0xFFE5E7EB), width: 1)), child: Row(children: [Icon(Icons.search, color: const Color(0xFF9CA3AF), size: 20.sp), SizedBox(width: 12.w), Expanded(child: TextField(decoration: InputDecoration(hintText: 'Search cultural places...', hintStyle: _getTextStyle(fontSize: 14.sp, color: const Color(0xFF9CA3AF)), border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none, contentPadding: EdgeInsets.zero, isDense: true), style: _getTextStyle(fontSize: 14.sp, color: const Color(0xFF1F2937))))])),
    ]);
  }

  Widget _buildCultureKeyStatistics() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      _buildCultureStatCard('30+', 'Temples And Sacred Places', const Color(0xFF10B981), Icons.temple_buddhist),
      SizedBox(width: 12.w),
      _buildCultureStatCard('12+', 'Heritage Sites', const Color(0xFF3B82F6), Icons.account_balance),
      SizedBox(width: 12.w),
      _buildCultureStatCard('3', 'Major Annual Festivals', const Color(0xFFEF4444), Icons.celebration),
    ]);
  }

  Widget _buildCultureStatCard(String number, String label, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(number, style: _getTextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700, color: color)),
            SizedBox(height: 4.h),
            Text(label, style: _getTextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280), height: 1.3), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _buildCultureHeritageSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text('Nashik\'s Cultural Heritage', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937)), textAlign: TextAlign.center),
      SizedBox(height: 12.h),
      Text('Discover Nashik\'s deep cultural roots, from ancient temples and Sanskrit traditions to vibrant festivals and soulful spiritual experiences.', style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280), height: 1.5), textAlign: TextAlign.center),
    ]);
  }

  Widget _buildCultureHistoryCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFEDD5), Color(0xFFFEE2E2)],
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.people, color: const Color(0xFFEF4444), size: 40.sp),
          SizedBox(height: 12.h),
          Text('1000+ Years of History', style: _getTextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937)), textAlign: TextAlign.center),
          SizedBox(height: 4.h),
          Text('Discover Culture in Nashik', style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280)), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildCulturePlacesSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Family-Friendly Places', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
        Text('View More', style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF3B82F6))),
      ]),
      SizedBox(height: 16.h),
      ...List.generate(_places.length > 3 ? 3 : _places.length, (index) => Padding(
        padding: EdgeInsets.only(bottom: index < 2 ? 16.h : 0),
        child: _buildCulturePlaceCard(_places[index], index),
      )),
    ]);
  }

  Widget _buildCulturePlaceCard(Place place, int index) {
    final tags = [
      ['Temple', const Color(0xFF10B981)],
      ['Ghat', const Color(0xFFFBBF24)],
      ['Cave', const Color(0xFF3B82F6)],
    ];
    final placeTags = [
      ['Ancient Temple', 'Ritual Spot', 'Heritage Protected'],
      ['Historical Landmark', 'Ritual Spot', 'Ancient Landmark'],
      ['Historical Landmark', 'Heritage Protected', 'Ancient Cave'],
    ];
    final distances = ['1.2 km away • 5 min drive', '8 km away • 18 min drive', '15 km away • 30 min drive'];
    final placeNames = ['Kalaram Mandir', 'Ramkund', 'Pandavleni Caves'];
    final tag = tags[index % tags.length];
    final placeTagList = placeTags[index % placeTags.length];
    final distance = distances[index % distances.length];
    final placeName = index < placeNames.length ? placeNames[index] : place.name;
    
    return GestureDetector(
      onTap: () => context.push('/place/${place.id}'),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12.r), topRight: Radius.circular(12.r)),
                child: Image.asset(
                  place.imageUrls.isNotEmpty ? place.imageUrls.first : 'assets/png/trambak.png',
                  width: double.infinity,
                  height: 180.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180.h,
                    color: const Color(0xFFF3F4F6),
                    child: Icon(Icons.image_not_supported, size: 40.sp),
                  ),
                ),
              ),
              Positioned(
                top: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: tag[1] as Color,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(tag[0] as String, style: _getTextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: Icon(Icons.favorite_border, color: const Color(0xFFEF4444), size: 20.sp),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(placeName, style: _getTextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16.sp, color: const Color(0xFF9CA3AF)),
                    SizedBox(width: 4.w),
                    Text(distance, style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280))),
                  ],
                ),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: placeTagList.map((tagText) {
                    Color tagColor = const Color(0xFFE0F2FE);
                    if (tagText.contains('Ritual')) tagColor = const Color(0xFFFFF7ED);
                    if (tagText.contains('Heritage')) tagColor = const Color(0xFFF3E8FF);
                    if (tagText.contains('Ancient') && !tagText.contains('Temple')) tagColor = const Color(0xFFFFF7ED);
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: tagColor,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                      ),
                      child: Text(tagText, style: _getTextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280))),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildCultureCircuitsSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Recommended Itineraries', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
      SizedBox(height: 16.h),
      _buildCultureItineraryCard(
        title: '1-Day Cultural Trail',
        badge: 'Perfect for beginners',
        badgeColor: const Color(0xFF10B981),
        places: 'Panchavati + Ramkund',
        duration: '2-3 hours',
        showViewDetails: true,
      ),
      SizedBox(height: 12.h),
      _buildCultureItineraryCard(
        title: '2-Day Cultural Trail',
        badge: 'All Ages',
        badgeColor: const Color(0xFFF97316),
        places: 'Pandavleni Caves + Old Nashik Heritage Walk',
        duration: '1-5 days',
        showViewDetails: true,
      ),
    ]);
  }

  Widget _buildCultureItineraryCard({required String title, required String badge, required Color badgeColor, required String places, required String duration, required bool showViewDetails}) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(title, style: _getTextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(badge, style: _getTextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: badgeColor)),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(places, style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280))),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time, size: 16.sp, color: const Color(0xFF9CA3AF)),
                  SizedBox(width: 4.w),
                  Text(duration, style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280))),
                ],
              ),
              if (showViewDetails)
                Text('View Details', style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF3B82F6))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCultureSafetyEssentialsSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Safety & Essentials', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
      SizedBox(height: 16.h),
      Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFEF4444), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: const Color(0xFFEF4444), size: 24.sp),
                SizedBox(width: 8.w),
                Text('Important Safety Tips', style: _getTextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
              ],
            ),
            SizedBox(height: 12.h),
            _buildCultureSafetyTip('Carry water bottles and caps for kids'),
            SizedBox(height: 8.h),
            _buildCultureSafetyTip('Choose spots with easy parking access'),
            SizedBox(height: 8.h),
            _buildCultureSafetyTip('Elder-friendly walking levels available'),
            SizedBox(height: 8.h),
            _buildCultureSafetyTip('Avoid visiting during peak heat hours (12 PM - 3 PM)'),
          ],
        ),
      ),
    ]);
  }

  Widget _buildCultureSafetyTip(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 6.h),
          width: 6.w,
          height: 6.h,
          decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
        ),
        SizedBox(width: 8.w),
        Expanded(child: Text(text, style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF1F2937), height: 1.4))),
      ],
    );
  }

  Widget _buildCultureNearbyFacilitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nearby Facilities', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
        SizedBox(height: 16.h),
        Row(children: [
          Expanded(child: _buildFacilityCard(Icons.hotel, 'Stay', 'Hotels & Campsites', const Color(0xFF3B82F6))),
          SizedBox(width: 12.w),
          Expanded(child: _buildFacilityCard(Icons.restaurant, 'Food', 'Prasad & Local Foods', const Color(0xFFF97316))),
        ]),
        SizedBox(height: 12.h),
        Row(children: [
          Expanded(child: _buildFacilityCard(Icons.people, 'Guides', 'Local Experts', const Color(0xFF10B981))),
          SizedBox(width: 12.w),
          Expanded(child: _buildFacilityCard(Icons.local_hospital, 'Medical Aid', 'Emergency Services', const Color(0xFF8B5CF6))),
        ]),
      ],
    );
  }

  Widget _buildCultureEcoFriendlyTravelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Eco-Friendly Travel', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFF10B981), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.eco, color: const Color(0xFF10B981), size: 24.sp),
                  SizedBox(width: 8.w),
                  Text('Eco-Friendly Tips', style: _getTextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
                ],
              ),
              SizedBox(height: 12.h),
              Text('Do not litter in temple or ghat areas, Follow queue systems and guidelines', style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF1F2937), height: 1.4)),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildEcoTip(Icons.water_drop, 'Carry water bottles'),
                  _buildEcoTip(Icons.delete_outline, 'Avoid plastic flowers'),
                  _buildEcoTip(Icons.handshake, 'Support locals'),
                  _buildEcoTip(Icons.camera_alt, 'Take only photos'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEcoTip(IconData icon, String text) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF10B981), size: 24.sp),
          SizedBox(height: 4.h),
          Text(text, style: _getTextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280)), textAlign: TextAlign.center, maxLines: 2),
        ],
      ),
    );
  }

  // ==================== SHOPPING PAGE METHODS ====================

  Widget _buildShoppingPage() {
    final List<String> shoppingSections = ['About', 'Places', 'Safety', 'Facilities', 'Itineraries', 'Eco-Friendly', 'Stories'];
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _mainScrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildShoppingHeroSection(),
              Transform.translate(
                offset: Offset(0, -20.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r), bottomLeft: Radius.zero, bottomRight: Radius.zero),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 44.h, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: shoppingSections.length, itemBuilder: (context, index) {
                              final isActive = index == _activeSectionIndex;
                              return Padding(key: ValueKey('nav-tab-$index'), padding: EdgeInsets.only(right: index < shoppingSections.length - 1 ? 8.w : 0), child: _buildNavigationTab(shoppingSections[index], isActive, index));
                            })),
                            SizedBox(height: 20.h),
                            Container(height: 1.h, color: const Color(0xFFE5E7EB)),
                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildSectionContainer(key: _aboutSectionKey, child: _buildShoppingAboutSection()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _sacredPlacesSectionKey, child: _buildShoppingPlacesSection()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _natureSafetySectionKey, child: _buildShoppingSafetyEssentialsSection()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _natureFacilitiesSectionKey, child: _buildShoppingNearbyFacilitiesSection()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _circuitsSectionKey, child: _buildShoppingRecommendedItinerariesSection()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _natureEcoFriendlySectionKey, child: _buildShoppingEcoFriendlyTravelSection()),
                            SizedBox(height: 32.h),
                            _buildSectionContainer(key: _natureStoriesSectionKey, child: _buildShoppingStoriesSection()),
                            SizedBox(height: 32.h),
                          ],
                        ),
                      ),
                    ],
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

  Widget _buildShoppingHeroSection() {
    return Container(
      width: double.infinity,
      height: 350.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(_category?.imagePath ?? 'assets/png/trambak.png'),
          fit: BoxFit.cover,
        ),
        color: const Color(0xFFF3F4F6),
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Shop the Best of Nashik', style: _getTextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700, color: Colors.white, height: 1.2)),
              SizedBox(height: 8.h),
              Text('Explore markets, crafts, malls & local specialities', style: _getTextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.white, height: 1.3)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShoppingAboutSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      _buildShoppingKeyStatistics(),
      SizedBox(height: 32.h),
      _buildShoppingHighlightsSection(),
      SizedBox(height: 32.h),
      Container(height: 48.h, padding: EdgeInsets.symmetric(horizontal: 16.w), decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(8.r), border: Border.all(color: const Color(0xFFE5E7EB), width: 1)), child: Row(children: [Icon(Icons.search, color: const Color(0xFF9CA3AF), size: 20.sp), SizedBox(width: 12.w), Expanded(child: TextField(decoration: InputDecoration(hintText: 'Search markets, shops, souvenirs...', hintStyle: _getTextStyle(fontSize: 14.sp, color: const Color(0xFF9CA3AF)), border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none, contentPadding: EdgeInsets.zero, isDense: true), style: _getTextStyle(fontSize: 14.sp, color: const Color(0xFF1F2937))))])),
    ]);
  }

  Widget _buildShoppingKeyStatistics() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      _buildShoppingStatCard('20+', 'Shopping Spots', const Color(0xFF10B981)),
      SizedBox(width: 12.w),
      _buildShoppingStatCard('5', 'Iconic Markets', const Color(0xFF6B7280)),
      SizedBox(width: 12.w),
      _buildShoppingStatCard('10+', 'Local Craft Shops', const Color(0xFFF97316)),
    ]);
  }

  Widget _buildShoppingStatCard(String number, String label, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(number, style: _getTextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700, color: color)),
            SizedBox(height: 4.h),
            Text(label, style: _getTextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280), height: 1.3), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _buildShoppingHighlightsSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Nashik\'s Shopping Highlights', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
      SizedBox(height: 12.h),
      Text('Discover Nashik\'s colourful markets, handcrafted goods, premium malls, and unique local products perfect for gifting and collecting.', style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280), height: 1.5)),
    ]);
  }

  Widget _buildShoppingPlacesSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Family-Friendly Places', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
        Text('View More', style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF3B82F6))),
      ]),
      SizedBox(height: 16.h),
      SizedBox(
        height: 280.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _places.length > 3 ? 3 : _places.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(right: index < 2 ? 12.w : 0),
              child: _buildShoppingPlaceCard(_places[index], index),
            );
          },
        ),
      ),
    ]);
  }

  Widget _buildShoppingPlaceCard(Place place, int index) {
    final tags = [
      ['Street Market', const Color(0xFF10B981)],
      ['Mall', const Color(0xFF3B82F6)],
      ['Cove', const Color(0xFF3B82F6)],
    ];
    final placeTags = [
      ['Street Market', 'Bargaining', 'Family'],
      ['Peak 6-9 PM', 'Parking', 'Family'],
      ['Handicrafts', 'Budget Friendly', 'Family'],
    ];
    final distances = ['2.6 km away • 12 min drive', '8 km away • 18 min drive', '1.5 km away • 12 min drive'];
    final placeNames = ['Shalimar', 'City Centre Mall', 'Old Nashik handicraft Lane'];
    final tag = tags[index % tags.length];
    final placeTagList = placeTags[index % placeTags.length];
    final distance = distances[index % distances.length];
    final placeName = index < placeNames.length ? placeNames[index] : place.name;
    
    return GestureDetector(
      onTap: () => context.push('/place/${place.id}'),
      child: Container(
        width: 280.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12.r), topRight: Radius.circular(12.r)),
                child: Image.asset(
                  place.imageUrls.isNotEmpty ? place.imageUrls.first : 'assets/png/trambak.png',
                  width: double.infinity,
                  height: 180.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180.h,
                    color: const Color(0xFFF3F4F6),
                    child: Icon(Icons.image_not_supported, size: 40.sp),
                  ),
                ),
              ),
              Positioned(
                top: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: tag[1] as Color,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(tag[0] as String, style: _getTextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: Icon(Icons.favorite_border, color: const Color(0xFFEF4444), size: 20.sp),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(placeName, style: _getTextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16.sp, color: const Color(0xFF9CA3AF)),
                    SizedBox(width: 4.w),
                    Text(distance, style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280))),
                  ],
                ),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: placeTagList.map((tagText) {
                    Color tagColor = const Color(0xFFE0F2FE);
                    if (tagText.contains('Bargaining') || tagText.contains('Peak')) tagColor = const Color(0xFFFFF7ED);
                    if (tagText.contains('Family')) tagColor = const Color(0xFFF3E8FF);
                    if (tagText.contains('Handicrafts') || tagText.contains('Budget')) tagColor = const Color(0xFFE0F2FE);
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: tagColor,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                      ),
                      child: Text(tagText, style: _getTextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280))),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildShoppingSafetyEssentialsSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Safety & Essentials', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
      SizedBox(height: 16.h),
      Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFEF4444), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: const Color(0xFFEF4444), size: 24.sp),
                SizedBox(width: 8.w),
                Text('Important Safety Tips', style: _getTextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
              ],
            ),
            SizedBox(height: 12.h),
            _buildShoppingSafetyTip('Carry water bottles and caps for kids'),
            SizedBox(height: 8.h),
            _buildShoppingSafetyTip('Choose spots with easy parking access'),
            SizedBox(height: 8.h),
            _buildShoppingSafetyTip('Elder-friendly walking levels available'),
            SizedBox(height: 8.h),
            _buildShoppingSafetyTip('Avoid visiting during peak heat hours (12 PM - 3 PM)'),
          ],
        ),
      ),
    ]);
  }

  Widget _buildShoppingSafetyTip(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 6.h),
          width: 6.w,
          height: 6.h,
          decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
        ),
        SizedBox(width: 8.w),
        Expanded(child: Text(text, style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF1F2937), height: 1.4))),
      ],
    );
  }

  Widget _buildShoppingNearbyFacilitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nearby Facilities', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
        SizedBox(height: 16.h),
        Row(children: [
          Expanded(child: _buildFacilityCard(Icons.hotel, 'Stay', 'Hotels & Campsites', const Color(0xFF3B82F6))),
          SizedBox(width: 12.w),
          Expanded(child: _buildFacilityCard(Icons.restaurant, 'Food', 'Prasad & Local Foods', const Color(0xFFF97316))),
        ]),
        SizedBox(height: 12.h),
        Row(children: [
          Expanded(child: _buildFacilityCard(Icons.people, 'Guides', 'Local Experts', const Color(0xFF10B981))),
          SizedBox(width: 12.w),
          Expanded(child: _buildFacilityCard(Icons.local_hospital, 'Medical Aid', 'Emergency Services', const Color(0xFF8B5CF6))),
        ]),
      ],
    );
  }

  Widget _buildShoppingRecommendedItinerariesSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Recommended Itineraries', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
      SizedBox(height: 16.h),
      _buildShoppingItineraryCard(
        title: '1-Day Shopping Trail',
        badge: 'Complete Market',
        badgeColor: const Color(0xFF10B981),
        places: 'Saraf Bazaar + Main Road Market + 3 more',
        duration: '2-3 hours',
        showViewDetails: true,
      ),
      SizedBox(height: 12.h),
      _buildShoppingItineraryCard(
        title: '2-Day Cultural Trail',
        badge: 'Gift Shopping',
        badgeColor: const Color(0xFFF97316),
        places: 'Paithani house + Handmade Artifacts Lane',
        duration: '2 days',
        showViewDetails: true,
      ),
    ]);
  }

  Widget _buildShoppingItineraryCard({required String title, required String badge, required Color badgeColor, required String places, required String duration, required bool showViewDetails}) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(title, style: _getTextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(badge, style: _getTextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: badgeColor)),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(places, style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280))),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time, size: 16.sp, color: const Color(0xFF9CA3AF)),
                  SizedBox(width: 4.w),
                  Text(duration, style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6B7280))),
                ],
              ),
              if (showViewDetails)
                Text('View Details', style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF3B82F6))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShoppingEcoFriendlyTravelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Eco-Friendly Travel', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFF10B981), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.eco, color: const Color(0xFF10B981), size: 24.sp),
                  SizedBox(width: 8.w),
                  Text('Eco-Friendly Travel', style: _getTextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
                ],
              ),
              SizedBox(height: 12.h),
              Text('Bring your own shopping bags to reduce plastic waste & Buy directly from Shopkeeps', style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF1F2937), height: 1.4)),
              SizedBox(height: 16.h),
              _buildShoppingEcoTip(Icons.water_drop, 'Carry water bottles'),
              SizedBox(height: 12.h),
              _buildShoppingEcoTip(Icons.shopping_bag, 'Carry Reusable Bags'),
              SizedBox(height: 12.h),
              _buildShoppingEcoTip(Icons.delete_outline, 'Avoid plastic flowers'),
              SizedBox(height: 12.h),
              _buildShoppingEcoTip(Icons.favorite, 'Support Local Artisans'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShoppingEcoTip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF10B981), size: 20.sp),
        SizedBox(width: 8.w),
        Text('• $text', style: _getTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF1F2937))),
      ],
    );
  }

  Widget _buildShoppingStoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shopping Stories', style: _getTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937))),
        SizedBox(height: 16.h),
        SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              final stories = [
                {'quote': 'Loved the vibrant market vibe!', 'image': 'assets/png/trambak.png'},
                {'quote': 'So many unique finds', 'image': 'assets/png/trambak.png'},
                {'quote': 'friendly shopkeeper', 'image': 'assets/png/trambak.png'},
              ];
              final story = stories[index];
              return Padding(
                padding: EdgeInsets.only(right: index < 2 ? 12.w : 0),
                child: _buildShoppingStoryCard(story['quote']!, story['image']!),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShoppingStoryCard(String quote, String image) {
    return Container(
      width: 200.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12.r), topRight: Radius.circular(12.r)),
            child: Image.asset(
              image,
              width: double.infinity,
              height: 120.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 120.h,
                color: const Color(0xFFF3F4F6),
                child: Icon(Icons.image_not_supported, size: 40.sp),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12.r,
                  backgroundColor: const Color(0xFFE5E7EB),
                  child: Icon(Icons.person, size: 16.sp, color: const Color(0xFF6B7280)),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(quote, style: _getTextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color(0xFF1F2937)), maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
