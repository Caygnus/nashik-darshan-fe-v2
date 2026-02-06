import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// Aarti Timing Page
/// Displays aarti & darshan timings for various temples
class AartiTimingPage extends StatefulWidget {
  const AartiTimingPage({super.key});

  @override
  State<AartiTimingPage> createState() => _AartiTimingPageState();
}

class _AartiTimingPageState extends State<AartiTimingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Fixed aarti types for all temples
  static const List<String> fixedAartiTypes = [
    'Morning Aarti',
    'Abhishek Pooja',
    'Evening Aarti',
    'Temple Closing',
  ];

  final List<Map<String, dynamic>> temples = [
    {
      'name': 'Trimbakeshwar Temple',
      'icon': Icons.temple_buddhist,
      'timings': [
        {'type': 'Morning Aarti', 'startTime': '5:30 AM', 'endTime': '7:00 AM', 'frequency': 'Daily'},
        {'type': 'Abhishek Pooja', 'startTime': '6:00 AM', 'endTime': '12:00 PM', 'frequency': 'Special slots'},
        {'type': 'Evening Aarti', 'startTime': '7:00 PM', 'endTime': '8:00 PM', 'frequency': 'Daily'},
        {'type': 'Temple Closing', 'startTime': '9:00 PM', 'endTime': '9:00 PM', 'frequency': 'Daily'},
      ],
    },
    {
      'name': 'Kalaram Temple',
      'icon': Icons.temple_hindu,
      'timings': [
        {'type': 'Morning Aarti', 'startTime': '6:00 AM', 'endTime': '7:30 AM', 'frequency': 'Daily'},
        {'type': 'Abhishek Pooja', 'startTime': '7:00 AM', 'endTime': '11:00 AM', 'frequency': 'Special slots'},
        {'type': 'Evening Aarti', 'startTime': '7:30 PM', 'endTime': '8:30 PM', 'frequency': 'Daily'},
        {'type': 'Temple Closing', 'startTime': '9:00 PM', 'endTime': '9:00 PM', 'frequency': 'Daily'},
      ],
    },
    {
      'name': 'Saptashrungi Temple',
      'icon': Icons.temple_buddhist,
      'timings': [
        {'type': 'Morning Aarti', 'startTime': '5:00 AM', 'endTime': '6:30 AM', 'frequency': 'Daily'},
        {'type': 'Abhishek Pooja', 'startTime': '6:00 AM', 'endTime': '11:00 AM', 'frequency': 'Special slots'},
        {'type': 'Evening Aarti', 'startTime': '7:00 PM', 'endTime': '8:00 PM', 'frequency': 'Daily'},
        {'type': 'Temple Closing', 'startTime': '8:30 PM', 'endTime': '8:30 PM', 'frequency': 'Daily'},
      ],
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
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
          'Aarti & Darshan Timings',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16.h), // Small top spacing
            // Horizontal scrolling cards - aligned to top
            SizedBox(
              height: 385.h, // Exact card height - no extra space
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: temples.length,
                itemBuilder: (context, index) {
                  final temple = temples[index];
                  
                  return Align(
                    alignment: Alignment.bottomLeft, // Align to bottom to remove space
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 16.w,
                        right: 25.w, // 25px spacing between cards
                      ),
                      child: _buildTempleCard(temple),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8.h), // Small spacing between cards and dots
            // Dots Indicator - shown below cards
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
                          ? const Color(0xFFFF9933)
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32.h), // Spacing before Important Tips section
            // Important Tips Section
            _buildImportantTipsSection(),
            SizedBox(height: 24.h), // Spacing before Plan Trip section
            // Plan Trip Section
            _buildPlanTripSection(),
            SizedBox(height: 24.h), // Bottom spacing
          ],
        ),
      ),
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

  Widget _buildTempleCard(Map<String, dynamic> temple) {
    return Container(
      width: 358.w,
      height: 385.h, // Fixed height 385
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r), // Corner radius 12
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
        padding: EdgeInsets.only(
          left: 20.w, // Left margin inside card
          top: 16.h, // Minimal top margin
          right: 20.w, // Right margin inside card
          bottom: 16.h, // Minimal bottom margin - no empty space
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Temple Title - centered
            Center(
              child: Text(
                temple['name'] as String,
                style: GoogleFonts.poppins(
                  fontSize: 20.sp, // Increased
                  fontWeight: FontWeight.w700, // Bold
                  color: const Color(0xFF292D32),
                  height: 1.2,
                  letterSpacing: 0,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 20.h), // Added spacing between temple name and timing list
            // Timing List - using fixed aarti types
            ...fixedAartiTypes.asMap().entries.map((entry) {
              final index = entry.key;
              final aartiType = entry.value;
              final isLast = index == fixedAartiTypes.length - 1;
              
              // Find timing for this aarti type
              final timingsList = temple['timings'] as List;
              Map<String, dynamic>? timing;
              for (var t in timingsList) {
                if (t['type'] == aartiType) {
                  timing = t as Map<String, dynamic>;
                  break;
                }
              }
              
              if (timing == null) return const SizedBox.shrink();
              
              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 6.h), // Minimal spacing
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
    );
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
          crossAxisAlignment: CrossAxisAlignment.center, // Vertically center aligned
          children: [
            // Icon with background
            Container(
              width: 40.w, // Increased
              height: 40.h, // Increased
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
                size: 20.sp, // Increased
                color: const Color(0xFFFFA201),
              ),
            ),
            SizedBox(width: 12.w), // Increased spacing
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    type,
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp, // Increased
                      fontWeight: FontWeight.w600, // SemiBold
                      color: const Color(0xFF003366),
                      height: 1.2,
                      letterSpacing: 0,
                    ),
                    maxLines: 2, // Allow wrapping to 2 lines
                    overflow: TextOverflow.visible, // Show full text
                    softWrap: true, // Enable text wrapping
                  ),
                  SizedBox(height: 3.h), // Spacing
                  Text(
                    frequency,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp, // Increased
                      fontWeight: FontWeight.w400, // Regular
                      color: const Color(0xFF6B7280),
                      height: 1.2,
                      letterSpacing: 0,
                    ),
                    maxLines: 2, // Allow wrapping to 2 lines
                    overflow: TextOverflow.visible, // Show full text
                    softWrap: true, // Enable text wrapping
                  ),
                ],
              ),
            ),
            // Time on right - displayed one below the other with proper alignment
            SizedBox(
              width: 100.w, // Increased for better fit
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasTimeRange) ...[
                    // Start time
                    Text(
                      startTime,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp, // Increased
                        fontWeight: FontWeight.w700, // Bold
                        color: const Color(0xFFFF9933),
                        height: 1.2,
                        letterSpacing: 0,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 2, // Allow wrapping if needed
                      overflow: TextOverflow.visible, // Show full text
                      softWrap: true, // Enable text wrapping
                    ),
                    SizedBox(height: 2.h), // Spacing
                    // Dash
                    Text(
                      '-',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp, // Increased
                        fontWeight: FontWeight.w400, // Regular
                        color: const Color(0xFF6B7280),
                        height: 1.2,
                        letterSpacing: 0,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 2.h), // Spacing
                    // End time
                    Text(
                      endTime,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp, // Increased
                        fontWeight: FontWeight.w700, // Bold
                        color: const Color(0xFFFF9933),
                        height: 1.2,
                        letterSpacing: 0,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 2, // Allow wrapping if needed
                      overflow: TextOverflow.visible, // Show full text
                      softWrap: true, // Enable text wrapping
                    ),
                  ] else ...[
                    // Single time (when start and end are same)
                    Text(
                      startTime,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp, // Increased
                        fontWeight: FontWeight.w700, // Bold
                        color: const Color(0xFFFF9933),
                        height: 1.2,
                        letterSpacing: 0,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 2, // Allow wrapping if needed
                      overflow: TextOverflow.visible, // Show full text
                      softWrap: true, // Enable text wrapping
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        if (showHrLine) ...[
          SizedBox(height: 10.h), // Spacing for visibility
          // HR Line for each event - more visible
          Container(
            height: 1.5.h, // Increased height for better visibility
            color: const Color(0xFFE5E7EB), // Darker color for better visibility
          ),
        ],
      ],
    );
  }

  Widget _buildImportantTipsSection() {
    final tips = [
      {
        'icon': Icons.checkroom,
        'title': 'Dress Code',
        'subtitle': 'Traditional attire\npreferred',
      },
      {
        'icon': Icons.calendar_today,
        'title': 'Best Time',
        'subtitle': 'Oct - Mar',
      },
      {
        'icon': Icons.book_online,
        'title': 'Book Advance',
        'subtitle': 'Pooja reservations',
      },
      {
        'icon': Icons.camera_alt_outlined,
        'title': 'No Photos',
        'subtitle': 'Inside Temple',
      },
    ];

    return Column(
      children: [
        // Title
        Text(
          'Important Tips',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF003366),
            height: 28 / 20, // Line height 28px for 20px font
            letterSpacing: 0,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.h),
        // Cards Grid - 2 rows, 2 columns
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              // First row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: _buildTipCard(tips[0]),
                  ),
                  SizedBox(width: 12.w),
                  Flexible(
                    flex: 1,
                    child: _buildTipCard(tips[1]),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              // Second row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: _buildTipCard(tips[2]),
                  ),
                  SizedBox(width: 12.w),
                  Flexible(
                    flex: 1,
                    child: _buildTipCard(tips[3]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTipCard(Map<String, dynamic> tip) {
    return Container(
      width: 173.w,
      constraints: BoxConstraints(
        minHeight: 146.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFAAAAAA),
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
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w), // Reduced horizontal padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon container
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xFFFF9933),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
              child: Icon(
                tip['icon'] as IconData,
                size: 24.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.h), // Reduced spacing
            // Title
            Text(
              tip['title'] as String,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500, // Medium
                color: const Color(0xFF003366),
                height: 1.2,
                letterSpacing: 0,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 3.h), // Reduced spacing
            // Subtitle
            Text(
              tip['subtitle'] as String,
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400, // Regular
                color: const Color(0xFF4B5563),
                height: 1.3,
                letterSpacing: 0,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanTripSection() {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.w, // Left margin
        right: 16.w, // Right margin
        top: 0,
        bottom: 0,
      ),
      child: Center(
        child: Container(
          width: 358.w,
          constraints: BoxConstraints(
            minHeight: 224.h,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFF954D), // #FF954D 0%
                Color(0xFFFFB147), // #FFB147
              ],
            ),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h), // Reduced vertical padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Maps icon - horizontally centered
                Icon(
                  Icons.map_outlined,
                  size: 40.sp, // Reduced from 48
                  color: Colors.white,
                ),
                SizedBox(height: 12.h), // Reduced from 16
                // Title
                Text(
                  'Ready for Your Spiritual Journey?',
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700, // Bold
                    color: Colors.white,
                    height: 1.3, // Adjusted line height
                    letterSpacing: 0,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h), // Reduced from 8
                // Subtitle
                Flexible(
                  child: Text(
                    'Plan your complete trip with accommodation and travel bookings',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400, // Regular
                      color: Colors.white,
                      height: 1.3, // Adjusted line height
                      letterSpacing: 0,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 12.h), // Reduced from 16
                // Button
                Container(
                  width: 183.83.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: const Color(0xFFE5E7EB),
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
                        // Handle button tap
                      },
                      borderRadius: BorderRadius.circular(8.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              size: 20.sp,
                              color: const Color(0xFFFF9933),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Plan My Trip',
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700, // Bold
                                color: const Color(0xFFFF9933),
                                letterSpacing: 0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
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
    );
  }
}
