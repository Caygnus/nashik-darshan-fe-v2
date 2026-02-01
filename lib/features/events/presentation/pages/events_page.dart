import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nashik/core/router/navigation/app_navigator.dart';
import 'package:nashik/core/router/route_names.dart';

/// Events Screen
/// Displays events and festivals in Nashik
class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  String _selectedCategory = 'All Events';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, size: 20.sp, color: const Color(0xFF1F2937)),
              onPressed: () => Navigator.of(context).maybePop(),
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
                icon: Icon(Icons.bookmark_border, size: 24.sp, color: const Color(0xFF1F2937)),
                onPressed: () => context.pushNamed(AppRouteNames.savedEvents),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 80.h), // Padding for bottom navigation bar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Featured Events Section
            _buildFeaturedEventsSection(),
            SizedBox(height: 24.h),
            // Browse by Category Section
            _buildBrowseByCategorySection(),
            SizedBox(height: 24.h),
            // Upcoming Events Section
            _buildUpcomingEventsSection(),
            SizedBox(height: 24.h),
            // Events You May Like Section
            _buildEventsYouMayLikeSection(),
            SizedBox(height: 24.h),
            // Event Information Section
            _buildEventInformationSection(),
          ],
        ),
      ),
    ),
        ],
      ),
    );
  }

  Widget _buildFeaturedEventsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Events',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                  fontFamily: 'Roboto',
                ),
              ),
              InkWell(
                onTap: () {
                  // TODO: Navigate to all featured events
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFF9933),
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Featured Event Cards
          _buildFeaturedEventCard(
            imagePath: 'assets/images/home-hero.png',
            title: 'Shravan Maas Special',
            date: 'Jul 22 - Aug 19 · All Day',
            location: 'Ramkund, Panchavati',
            badgeText: 'Live Now',
            badgeColor: Colors.red,
            eventId: 'shravan-maas-special',
          ),
          SizedBox(height: 16.h),
          _buildFeaturedEventCard(
            imagePath: 'assets/images/home-hero.png',
            title: 'Devotional Concert by Anup Jalota',
            date: 'Jan 12 · 6:00 PM - 9:00 PM',
            location: 'Kalidas Auditorium',
            badgeText: 'This Weekend',
            badgeColor: const Color(0xFFFF9933),
            eventId: 'anup-jalota-concert',
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedEventCard({
    required String imagePath,
    required String title,
    required String date,
    required String location,
    required String badgeText,
    required Color badgeColor,
    required String eventId,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: 200.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 200.h,
                      color: const Color(0xFFF3F4F6),
                      child: Icon(Icons.image_not_supported, size: 40.sp, color: Colors.grey),
                    );
                  },
                ),
              ),
              // Badge (top right)
              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(9999.r),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2937),
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16.sp, color: const Color(0xFFFF9933)),
                    SizedBox(width: 8.w),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF6B7280),
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16.sp, color: const Color(0xFFFF9933)),
                    SizedBox(width: 8.w),
                    Text(
                      location,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF6B7280),
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                InkWell(
                  onTap: () {
                    AppNavigator.pushToEventDetail(
                      context,
                      eventId: eventId,
                      eventTitle: title,
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 44.h,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFFF9933),
                          Color(0xFFFFB048),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Roboto',
                        ),
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

  Widget _buildBrowseByCategorySection() {
    final categories = [
      {'name': 'All Events', 'icon': Icons.people},
      {'name': 'Spiritual', 'icon': Icons.self_improvement},
      {'name': 'Discovery', 'icon': Icons.explore},
      {'name': 'Cultural', 'icon': Icons.theater_comedy},
      {'name': 'Festival', 'icon': Icons.celebration},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'Browse by Category',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
              fontFamily: 'Roboto',
            ),
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 50.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = _selectedCategory == category['name'] as String;
              return Container(
                margin: EdgeInsets.only(right: 12.w),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category['name'] as String;
                    });
                  },
                  borderRadius: BorderRadius.circular(9999.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFF9933) : Colors.white,
                      borderRadius: BorderRadius.circular(9999.r),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFFF9933) : const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          category['icon'] as IconData,
                          size: 20.sp,
                          color: isSelected ? Colors.white : const Color(0xFF6B7280),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          category['name'] as String,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : const Color(0xFF1F2937),
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
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

  Widget _buildUpcomingEventsSection() {
    final upcomingEvents = [
      {'day': '12', 'month': 'JAN', 'title': 'Morning Ganga Aarti', 'description': 'Daily spiritual ritual at the holy ghat.', 'time': '5:30 AM - 6:30 AM', 'location': 'Ramkund Ghat', 'tag': {'text': 'Today', 'color': const Color(0xFF10B981)}, 'eventId': 'morning-ganga-aarti'},
      {'day': '13', 'month': 'JAN', 'title': 'Spiritual Discourse', 'description': 'Bhagavad Gita teachings by Swami Ji.', 'time': '4:00 PM - 6:00 PM', 'location': 'Sita Gufa Temple', 'tag': {'text': 'Free', 'color': const Color(0xFF3B82F6)}, 'eventId': 'spiritual-discourse'},
      {'day': '14', 'month': 'JAN', 'title': 'Makar Sankranti Celebration', 'description': 'Traditional kite flying & holy dip ceremony.', 'time': '6:00 AM - 12:00 PM', 'location': 'Godavari Ghat', 'tag': {'text': 'Festival', 'color': const Color(0xFF9333EA)}, 'eventId': 'makar-sankranti'},
      {'day': '15', 'month': 'JAN', 'title': 'Kathak Dance Performance', 'description': 'Classical dance depicting Lord Krishna tales.', 'time': '7:00 PM - 9:00 PM', 'location': 'Kalidas Auditorium', 'tag': {'text': 'Cultural', 'color': const Color(0xFFFF9933)}, 'eventId': 'kathak-dance'},
      {'day': '18', 'month': 'JAN', 'title': 'Weekend Bhajan Sandhya', 'description': 'Devotional singing by local artists.', 'time': '5:00 PM - 7:00 PM', 'location': 'Kapaleshwar Temple', 'tag': {'text': 'Weekend', 'color': const Color(0xFFFFB048)}, 'eventId': 'weekend-bhajan'},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Events',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                  fontFamily: 'Roboto',
                ),
              ),
              InkWell(
                onTap: () => context.pushNamed(AppRouteNames.upcomingEvents),
                child: Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFF9933),
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Event Cards
          ...upcomingEvents.map((event) => Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: _buildUpcomingEventCard(
                  day: event['day'] as String,
                  month: event['month'] as String,
                  title: event['title'] as String,
                  description: event['description'] as String,
                  time: event['time'] as String,
                  location: event['location'] as String,
                  tag: event['tag'] as Map<String, dynamic>,
                  eventId: event['eventId'] as String,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildUpcomingEventCard({
    required String day,
    required String month,
    required String title,
    required String description,
    required String time,
    required String location,
    required Map<String, dynamic> tag,
    required String eventId,
  }) {
    return InkWell(
      onTap: () {
        AppNavigator.pushToEventDetail(
          context,
          eventId: eventId,
          eventTitle: title,
        );
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Box: Date Montserrat Bold 24, Month Montserrat Medium 12, color FFFFFF
          Container(
            width: 64.w,
            height: 72.h,
            decoration: BoxDecoration(
              color: const Color(0xFFFF9933),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day,
                  style: GoogleFonts.montserrat(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFFFFFF),
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  month,
                  style: GoogleFonts.montserrat(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFFFFFFF),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F2937),
                          fontFamily: 'Roboto',
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: (tag['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(9999.r),
                      ),
                      child: Text(
                        tag['text'] as String,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: tag['color'] as Color,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF6B7280),
                    fontFamily: 'Roboto',
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 13.sp, color: const Color(0xFFFF9933)),
                    SizedBox(width: 3.w),
                    Flexible(
                      child: Text(
                        time,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF6B7280),
                          fontFamily: 'Roboto',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.location_on, size: 13.sp, color: const Color(0xFFFF9933)),
                    SizedBox(width: 3.w),
                    Flexible(
                      child: Text(
                        location,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF6B7280),
                          fontFamily: 'Roboto',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: const Color(0xFFFF9933)),
                      ),
                      child: Text(
                        'Save Event',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFF9933),
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildEventsYouMayLikeSection() {
    final events = [
      {
        'image': 'assets/images/home-hero.png',
        'title': 'Morning Yoga & Meditation',
        'dateTime': 'Jan 20 · 6:00 AM',
        'location': 'Trimbakeshwar',
      },
      {
        'image': 'assets/images/home-hero.png',
        'title': 'Lavani Folk Dance Show',
        'dateTime': 'Jan 22 · 8:00 PM',
        'location': 'City Hall',
      },
      {
        'image': 'assets/images/home-hero.png',
        'title': 'Evening Maha Aarti',
        'dateTime': 'Daily · 7:00 PM',
        'location': 'Sundar Narayan',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'Events You May Like',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
              fontFamily: 'Roboto',
            ),
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 110.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Container(
                width: 280.w,
                margin: EdgeInsets.only(right: 12.w),
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.asset(
                        event['image'] as String,
                        width: 72.w,
                        height: 72.w,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 72.w,
                            height: 72.w,
                            color: const Color(0xFFF3F4F6),
                            child: Icon(Icons.image_not_supported, size: 20.sp, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 10.w),
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            event['title'] as String,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1F2937),
                              fontFamily: 'Roboto',
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            event['dateTime'] as String,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF6B7280),
                              fontFamily: 'Roboto',
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            event['location'] as String,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF6B7280),
                              fontFamily: 'Roboto',
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Save Event Button (orange, white text)
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9933),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'Save Event',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEventInformationSection() {
    final infoCards = [
      {
        'icon': Icons.people,
        'iconColor': const Color(0xFFFF9933),
        'title': 'Crowd Level',
        'description': 'Check expected attendance',
      },
      {
        'icon': Icons.accessible,
        'iconColor': const Color(0xFF3B82F6),
        'title': 'Accessibility',
        'description': 'Elder-friendly events',
      },
      {
        'icon': Icons.checkroom,
        'iconColor': const Color(0xFF9333EA),
        'title': 'Dress Code',
        'description': 'Traditional attire info',
      },
      {
        'icon': Icons.event_seat,
        'iconColor': const Color(0xFF10B981),
        'title': 'Seating',
        'description': 'Seating arrangements',
      },
    ];

    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Event Information',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
              fontFamily: 'Roboto',
            ),
          ),
          SizedBox(height: 16.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 1.0,
            ),
            itemCount: infoCards.length,
            itemBuilder: (context, index) {
              final card = infoCards[index];
              final iconColor = card['iconColor'] as Color;
              return Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        card['icon'] as IconData,
                        size: 28.sp,
                        color: iconColor,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      card['title'] as String,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      card['description'] as String,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF6B7280),
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
