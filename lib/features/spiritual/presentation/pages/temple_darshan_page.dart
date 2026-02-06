import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nashik/core/router/route_names.dart';

/// Temple Darshan Page
/// Displays temple darshan information and booking options
class TempleDarshanPage extends StatefulWidget {
  const TempleDarshanPage({super.key});

  @override
  State<TempleDarshanPage> createState() => _TempleDarshanPageState();
}

class _TempleDarshanPageState extends State<TempleDarshanPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  final PageController _attractionsPageController = PageController();
  int _currentAttractionsPage = 0;

  final List<Map<String, String>> temples = [
    {
      'devanagari': 'श्री त्र्यंबकेश्वर ज्योतिर्लिंग',
      'english': 'Trimbakeshwar Temple',
    },
    {
      'devanagari': 'श्री गजानन महाराज ..',
      'english': 'Shree Gajanan Maharaj...',
    },
  ];

  final List<Map<String, String>> attractions = [
    {
      'name': 'Sula Vineyards',
      'image': 'assets/png/trambak.png',
    },
    {
      'name': 'Pandavleni Caves',
      'image': 'assets/png/trambak.png',
    },
    {
      'name': 'Saptashrungi Temple',
      'image': 'assets/png/trambak.png',
    },
    {
      'name': 'Kalaram Temple',
      'image': 'assets/png/trambak.png',
    },
    {
      'name': 'Trimbakeshwar Temple',
      'image': 'assets/png/trambak.png',
    },
    {
      'name': 'Gangapur Dam',
      'image': 'assets/png/trambak.png',
    },
    {
      'name': 'Anjaneri Fort',
      'image': 'assets/png/trambak.png',
    },
    {
      'name': 'Coin Museum',
      'image': 'assets/png/trambak.png',
    },
  ];

  int get _attractionsPageCount {
    return (attractions.length / 4).ceil(); // 4 cards per page (2x2 grid)
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateCurrentPage);
  }

  void _updateCurrentPage() {
    final double scrollPosition = _scrollController.offset;
    final double cardWidth = 160.w;
    final double spacing = 12.w;
    final int newPage = (scrollPosition / (cardWidth + spacing)).round();
    
    if (newPage != _currentPage && newPage >= 0 && newPage < temples.length) {
      setState(() {
        _currentPage = newPage;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateCurrentPage);
    _scrollController.dispose();
    _attractionsPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Temples Of Nashik',
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image Section - Full width, no margins or radius
            Container(
              width: double.infinity,
              height: 234.h,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/png/trambak.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.3), // Dark overlay for text readability
                      Colors.black.withValues(alpha: 0.5),
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title
                      Text(
                        'Discover the Temples of Nashik',
                        style: GoogleFonts.montserrat(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700, // Bold
                          color: Colors.white,
                          height: 32 / 24, // Line height 32px for 24px font
                          letterSpacing: 0,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12.h),
                      // Subtitle
                      Text(
                        'A City of temples, traditions, and timeless faith.',
                        style: GoogleFonts.montserrat(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400, // Regular
                          color: Colors.white,
                          height: 20 / 14, // Line height 20px for 14px font
                          letterSpacing: 0,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h), // Spacing after image
            // Sacred Temples Section
            Padding(
              padding: EdgeInsets.only(left: 23.w), // Left margin 23
              child: Text(
                'Sacred Temples of Nashik',
                style: GoogleFonts.montserrat(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700, // Bold
                  color: const Color(0xFF1F2937),
                  height: 28 / 18, // Line height 28px for 18px font
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 16.h), // Spacing before cards
            // Horizontal scrolling cards - side by side
            SizedBox(
              height: 230.h, // Card height - increased
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: temples.length,
                itemBuilder: (context, index) {
                  final temple = temples[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 23.w : 12.w, // First card has left margin 23
                      right: index == temples.length - 1 ? 23.w : 12.w, // Last card has right margin
                    ),
                    child: SizedBox(
                      width: 160.w,
                      height: 230.h, // Increased height
                      child: _buildTempleCard(temple),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 12.h), // Spacing between cards and dots
            // Dots Indicator
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  temples.length,
                  (index) => Container(
                    width: _currentPage == index ? 24.w : 8.w,
                    height: 8.h,
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      color: _currentPage == index
                          ? const Color(0xFFFF8A02)
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h), // Spacing after dots
            // Explore Attractions Section
            Padding(
              padding: EdgeInsets.only(left: 23.w), // Left margin
              child: Text(
                'Explore Attractions',
                style: GoogleFonts.montserrat(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600, // SemiBold
                  color: const Color(0xFF1F2937),
                  height: 28 / 18, // Line height 28px for 18px font
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 16.h), // Spacing before cards
            // Horizontal scrolling attraction cards - 2x2 grid
            SizedBox(
              height: (128.h * 2) + 12.h, // 2 rows + spacing between rows
              child: PageView.builder(
                controller: _attractionsPageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentAttractionsPage = index;
                  });
                },
                itemCount: _attractionsPageCount,
                itemBuilder: (context, pageIndex) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w), // Reduced padding to prevent overflow
                    child: _buildAttractionsGrid(pageIndex),
                  );
                },
              ),
            ),
            SizedBox(height: 12.h), // Spacing between cards and dots
            // Dots Indicator for attractions
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _attractionsPageCount,
                  (index) => Container(
                    width: _currentAttractionsPage == index ? 24.w : 8.w,
                    height: 8.h,
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      color: _currentAttractionsPage == index
                          ? const Color(0xFFFF8A02)
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h), // Spacing after attractions
          ],
        ),
      ),
    );
  }

  Widget _buildTempleCard(Map<String, String> temple) {
    return InkWell(
      onTap: () {
        // Navigate to place detail page
        // Extract place ID from temple name (e.g., "Trimbakeshwar Temple" -> "trimbakeshwar")
        final placeId = temple['english']?.toLowerCase().replaceAll(' temple', '').replaceAll(' ', '-') ?? 'trimbakeshwar';
        context.pushNamed(
          AppRouteNames.placeDetail,
          pathParameters: {'placeId': placeId},
        );
      },
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          image: const DecorationImage(
            image: AssetImage('assets/png/trambak.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Colors.black.withValues(alpha: 0.5), // #000000 overlay
          ),
          child: Stack(
            children: [
            // Top right badge
            Positioned(
              top: 12.h,
              right: 12.w,
              child: Container(
                width: 68.w,
                height: 22.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8A02), // #FF8A02
                  borderRadius: BorderRadius.circular(9999.r), // 9999px radius
                  border: Border.all(
                    color: const Color(0xFFE5E7EB), // Stroke E5E7EB
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Spiritual',
                    style: GoogleFonts.montserrat(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400, // Regular
                      color: Colors.white, // #FFFFFF
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            // Bottom left text content
            Positioned(
              bottom: 16.h,
              left: 12.w,
              right: 12.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Devanagari title
                  Text(
                    temple['devanagari'] ?? '',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400, // Regular
                      color: Colors.white, // #FFFFFF
                      height: 15 / 15, // Line height 15px for 15px font
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  // English name
                  Text(
                    temple['english'] ?? '',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400, // Regular
                      color: Colors.white, // #FFFFFF
                      height: 32 / 10, // Line height 32px for 10px font
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
        ),
      ),
    );
  }

  Widget _buildAttractionsGrid(int pageIndex) {
    final int startIndex = pageIndex * 4;
    final int endIndex = (startIndex + 4).clamp(0, attractions.length);
    final List<Map<String, String>> pageAttractions = attractions.sublist(startIndex, endIndex);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate available width: screen width - padding (16.w on each side = 32.w total)
        final double availableWidth = constraints.maxWidth;
        // Calculate card width: (available width - spacing between cards) / 2
        final double spacing = 12.w; // Spacing between cards
        final double cardWidth = (availableWidth - spacing) / 2;
        
        return Column(
          children: [
            // First row
            Row(
              children: [
                SizedBox(
                  width: cardWidth,
                  height: 128.h,
                  child: _buildAttractionCard(pageAttractions.length > 0 ? pageAttractions[0] : null),
                ),
                SizedBox(width: spacing), // Spacing between cards
                SizedBox(
                  width: cardWidth,
                  height: 128.h,
                  child: _buildAttractionCard(pageAttractions.length > 1 ? pageAttractions[1] : null),
                ),
              ],
            ),
            SizedBox(height: 12.h), // Spacing between rows
            // Second row
            Row(
              children: [
                SizedBox(
                  width: cardWidth,
                  height: 128.h,
                  child: _buildAttractionCard(pageAttractions.length > 2 ? pageAttractions[2] : null),
                ),
                SizedBox(width: spacing), // Spacing between cards
                SizedBox(
                  width: cardWidth,
                  height: 128.h,
                  child: _buildAttractionCard(pageAttractions.length > 3 ? pageAttractions[3] : null),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildAttractionCard(Map<String, String>? attraction) {
    if (attraction == null) {
      return const SizedBox.shrink();
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFE5E7EB), // Stroke E5E7EB
          width: 1,
        ),
        image: DecorationImage(
          image: AssetImage(attraction['image'] ?? 'assets/png/trambak.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Stack(
          children: [
            // Bottom gradient overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 44.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7), // #000000 70%
                      Colors.black.withValues(alpha: 0.0), // #000000 0%
                    ],
                  ),
                  border: Border(
                    top: BorderSide(
                      color: const Color(0xFFE5E7EB), // Stroke E5E7EB
                      width: 1,
                    ),
                  ),
                ),
                padding: EdgeInsets.only(left: 12.w, bottom: 8.h, top: 8.h),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    attraction['name'] ?? '',
                    style: GoogleFonts.montserrat(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500, // Medium
                      color: Colors.white, // #FFFFFF
                      height: 20 / 14, // Line height 20px for 14px font
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
