import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// Saved Events Page
/// Shows saved/curated events by date with time blocks (Morning, Afternoon, Evening) and event cards.
class SavedEventsPage extends StatefulWidget {
  const SavedEventsPage({super.key});

  @override
  State<SavedEventsPage> createState() => _SavedEventsPageState();
}

class _SavedEventsPageState extends State<SavedEventsPage> {
  int _selectedDateIndex = 0;
  final Map<String, bool> _expandedBlocks = {'Morning': true, 'Afternoon': true, 'Evening': true};

  static const _monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  static const _weekdayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  List<Map<String, dynamic>> get _dateTabs {
    final now = DateTime.now();
    return List.generate(5, (offset) {
      final d = DateTime(now.year, now.month, now.day).add(Duration(days: offset));
      final label = offset == 0 ? 'Today' : offset == 1 ? 'Tomorrow' : _weekdayNames[d.weekday - 1];
      return {'label': label, 'day': '${d.day}', 'month': _monthNames[d.month - 1]};
    });
  }

  static final List<Map<String, dynamic>> _morningEvents = [
    {
      'title': 'Nashik Cultural Festival',
      'category': 'Cultural',
      'categoryColor': const Color(0xFFDC2626),
      'status': 'Upcoming',
      'statusColor': const Color(0xFF10B981),
      'location': 'Sardar Vallabhbhai Patel Garden',
      'time': '9:00 AM - 11:30 AM',
      'distance': '2.3 km from current location',
      'action': 'Set Reminder',
      'actionIcon': Icons.notifications_none,
      'secondaryIcon': Icons.map_outlined,
      'eventId': 'nashik-cultural-festival',
    },
    {
      'title': 'Classical Music Morning',
      'category': 'Music',
      'categoryColor': const Color(0xFF9333EA),
      'rating': 4,
      'location': 'Kalidas Kala Mandir',
      'time': '10:00 AM - 12:00 PM',
      'distance': '4.1 km from previous event',
      'timeConflict': 'Time Conflict / Overlaps with previous event by 30 min',
      'action': 'Auto Reschedule',
      'actionIcon': Icons.refresh,
      'secondaryIcon': Icons.map_outlined,
      'eventId': 'classical-music-morning',
    },
  ];

  static final List<Map<String, dynamic>> _afternoonEvents = [
    {
      'title': 'Nashik Food Festival',
      'category': 'Food',
      'categoryColor': const Color(0xFFDC2626),
      'status': 'Upcoming',
      'statusColor': const Color(0xFF10B981),
      'location': 'College Road Food Street',
      'time': '1:00 PM - 5:00 PM',
      'attendees': '1,200+ people interested',
      'aiSuggestion': 'People also planned: Wine Tasting Tour (3 km away)',
      'action': 'Remind 30 min before',
      'actionIcon': Icons.notifications_none,
      'secondaryIcon': Icons.share_outlined,
      'eventId': 'nashik-food-festival',
    },
  ];

  static final List<Map<String, dynamic>> _eveningEvents = [
    {
      'title': 'Trimbakeshwar Evening Aarti',
      'category': 'Religious',
      'categoryColor': const Color(0xFFFF9933),
      'rating': 5,
      'location': 'Trimbakeshwar Temple',
      'time': '7:00 PM - 8:30 PM',
      'distance': '28 km from city center',
      'reminderSet': true,
      'reminderTime': '6:00 PM',
      'action': 'Cancel Reminder',
      'actionIcon': Icons.notifications_off_outlined,
      'isOutlined': true,
      'secondaryIcon': Icons.map_outlined,
      'eventId': 'trimbakeshwar-evening-aarti',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20.sp, color: const Color(0xFF1F2937)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Events',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark, size: 24.sp, color: const Color(0xFF1F2937)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              'Saved events',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F2937),
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Your curated events in Nashik',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.normal,
                color: const Color(0xFF6B7280),
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: 20.h),
            _buildDateSelector(),
            SizedBox(height: 24.h),
            _buildTimeBlock('Morning', '6:00 AM - 12:00 PM', Icons.wb_sunny_outlined, _morningEvents),
            _buildTimeBlock('Afternoon', '12:00 PM - 6:00 PM', Icons.wb_cloudy_outlined, _afternoonEvents),
            _buildTimeBlock('Evening', '6:00 PM - 11:00 PM', Icons.nightlight_round_outlined, _eveningEvents),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return SizedBox(
      height: 90.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _dateTabs.length,
        itemBuilder: (context, index) {
          final tab = _dateTabs[index];
          final isSelected = _selectedDateIndex == index;
          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: InkWell(
              onTap: () => setState(() => _selectedDateIndex = index),
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFF9933) : Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected ? const Color(0xFFFF9933) : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tab['label'] as String,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                        color: isSelected ? Colors.white : const Color(0xFF6B7280),
                        fontFamily: 'Roboto',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          tab['day'] as String,
                          style: GoogleFonts.montserrat(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                            color: isSelected ? const Color(0xFFFFFFFF) : const Color(0xFF1F2937),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          tab['month'] as String,
                          style: GoogleFonts.montserrat(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.1,
                            color: isSelected ? const Color(0xFFFFFFFF) : const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeBlock(String title, String timeRange, IconData icon, List<Map<String, dynamic>> events) {
    final isExpanded = _expandedBlocks[title] ?? true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => setState(() => _expandedBlocks[title] = !isExpanded),
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Row(
                children: [
                  Icon(icon, size: 24.sp, color: const Color(0xFFFF9933)),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1F2937),
                            fontFamily: 'Roboto',
                          ),
                        ),
                        Text(
                          timeRange,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF6B7280),
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                    size: 28.sp,
                    color: const Color(0xFF6B7280),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isExpanded) ...[
          ...events.map((e) => Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: _buildEventCard(e),
              )),
        ],
      ],
    );
  }

  Widget _buildEventCard(Map<String, dynamic> e) {
    final hasTimeConflict = e['timeConflict'] != null;
    final hasAiSuggestion = e['aiSuggestion'] != null;
    final reminderSet = e['reminderSet'] == true;
    final isOutlined = e['isOutlined'] == true;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(11.r)),
                child: Image.asset(
                  'assets/images/home-hero.png',
                  width: double.infinity,
                  height: 140.h,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 140.h,
                    color: const Color(0xFFF3F4F6),
                    child: Icon(Icons.image, size: 40.sp, color: Colors.grey),
                  ),
                ),
              ),
              Positioned(
                top: 10.h,
                left: 10.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: (e['categoryColor'] as Color?) ?? const Color(0xFFDC2626),
                    borderRadius: BorderRadius.circular(9999.r),
                  ),
                  child: Text(
                    e['category'] as String? ?? 'Event',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
              if (e['status'] != null)
                Positioned(
                  top: 10.h,
                  right: 40.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: (e['statusColor'] as Color?) ?? const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(9999.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 6.sp, color: Colors.white),
                        SizedBox(width: 6.w),
                        Text(
                          e['status'] as String,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (e['rating'] != null)
                Positioned(
                  bottom: 8.h,
                  left: 10.w,
                  child: Row(
                    children: List.generate(5, (i) {
                      final filled = i < (e['rating'] as int);
                      return Icon(
                        filled ? Icons.star : Icons.star_border,
                        size: 16.sp,
                        color: const Color(0xFFFBBF24),
                      );
                    }),
                  ),
                ),
              Positioned(
                top: 10.h,
                right: 10.w,
                child: IconButton(
                  icon: Icon(Icons.more_vert, size: 22.sp, color: Colors.white),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: 32.w, minHeight: 32.w),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e['title'] as String,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2937),
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 16.sp, color: const Color(0xFF6B7280)),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        e['location'] as String? ?? '',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF6B7280),
                          fontFamily: 'Roboto',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16.sp, color: const Color(0xFF6B7280)),
                    SizedBox(width: 6.w),
                    Text(
                      e['time'] as String? ?? '',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF6B7280),
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                if (e['distance'] != null || e['attendees'] != null) ...[
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(Icons.directions_walk, size: 16.sp, color: const Color(0xFF6B7280)),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          (e['distance'] ?? e['attendees']) as String,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xFF6B7280),
                            fontFamily: 'Roboto',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                if (hasTimeConflict) ...[
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: const Color(0xFFFED7AA)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.warning_amber_rounded, size: 20.sp, color: const Color(0xFFC2410C)),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            e['timeConflict'] as String,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF9A3412),
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (hasAiSuggestion) ...[
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lightbulb_outline, size: 20.sp, color: const Color(0xFF2563EB)),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'AI Suggestion / ${e['aiSuggestion']}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF1D4ED8),
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (reminderSet) ...[
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Reminder Set',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF10B981),
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Text(
                        e['reminderTime'] as String? ?? '',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF6B7280),
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 14.h),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44.h,
                        child: Material(
                          color: isOutlined ? Colors.white : const Color(0xFFFF9933),
                          borderRadius: BorderRadius.circular(10.r),
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(10.r),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                border: isOutlined ? Border.all(color: const Color(0xFFE5E7EB)) : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    e['actionIcon'] as IconData? ?? Icons.notifications_none,
                                    size: 20.sp,
                                    color: isOutlined ? const Color(0xFF6B7280) : Colors.white,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    e['action'] as String? ?? 'Set Reminder',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: isOutlined ? const Color(0xFF6B7280) : Colors.white,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    SizedBox(
                      width: 44.w,
                      height: 44.h,
                      child: Material(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(10.r),
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(10.r),
                          child: Icon(
                            e['secondaryIcon'] as IconData? ?? Icons.map_outlined,
                            size: 22.sp,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
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
}
