import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nashik/core/router/navigation/app_navigator.dart';

/// Upcoming Events Page
/// Calendar with highlighted dates that have events; list of events for selected date.
class UpcomingEventsPage extends StatefulWidget {
  const UpcomingEventsPage({super.key});

  @override
  State<UpcomingEventsPage> createState() => _UpcomingEventsPageState();
}

class _UpcomingEventsPageState extends State<UpcomingEventsPage> {
  DateTime _currentMonth = DateTime(2026, 1);
  DateTime? _selectedDate = DateTime(2026, 1, 18);

  /// Dates that have events (day of month) – highlighted in calendar.
  static const Set<int> _datesWithEvents = {12, 13, 14, 15, 18};

  /// Events by date key "yyyy-MM-dd".
  static final Map<String, List<Map<String, dynamic>>> _eventsByDate = {
    '2026-01-12': [
      {'title': 'Morning Ganga Aarti', 'description': 'Daily spiritual ritual at the holy ghat.', 'time': '5:30 AM – 6:30 AM', 'location': 'Ramkund Ghat', 'eventId': 'morning-ganga-aarti'},
    ],
    '2026-01-13': [
      {'title': 'Spiritual Discourse', 'description': 'Bhagavad Gita teachings by Swami Ji.', 'time': '4:00 PM – 6:00 PM', 'location': 'Sita Gufa Temple', 'eventId': 'spiritual-discourse'},
    ],
    '2026-01-14': [
      {'title': 'Makar Sankranti Celebration', 'description': 'Traditional kite flying & holy dip ceremony.', 'time': '6:00 AM – 12:00 PM', 'location': 'Godavari Ghat', 'eventId': 'makar-sankranti'},
    ],
    '2026-01-15': [
      {'title': 'Kathak Dance Performance', 'description': 'Classical dance depicting Lord Krishna tales.', 'time': '7:00 PM – 9:00 PM', 'location': 'Kalidas Auditorium', 'eventId': 'kathak-dance'},
    ],
    '2026-01-18': [
      {'title': 'Ramayana Katha', 'description': 'Join us for an enlightening discourse on the sacred texts with learned scholars.', 'time': '10:00 AM – 12:00 PM', 'location': 'Muktidham, Nashik', 'eventId': 'ramayana-katha'},
      {'title': 'Morning Ganga Aarti', 'description': 'Experience the divine morning ritual at the sacred ghats with traditional chants and offerings.', 'time': '6:00 PM – 7:30 PM', 'location': 'Ramkund Ghat, Panchavati', 'eventId': 'morning-ganga-aarti'},
    ],
  };

  List<Map<String, dynamic>> _eventsForSelectedDate() {
    if (_selectedDate == null) return [];
    final key = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    return _eventsByDate[key] ?? [];
  }

  bool _dateHasEvents(int day) => _datesWithEvents.contains(day);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20.sp, color: const Color(0xFF1F2937)),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Upcoming Events',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            _buildCalendarCard(),
            SizedBox(height: 24.h),
            _buildEventsHeader(),
            SizedBox(height: 16.h),
            ..._eventsForSelectedDate().map((e) => Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: _buildEventCard(
                    title: e['title'] as String,
                    description: e['description'] as String,
                    time: e['time'] as String,
                    location: e['location'] as String,
                    eventId: e['eventId'] as String,
                  ),
                )),
            if (_eventsForSelectedDate().isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Center(
                  child: Text(
                    'No events on this date.',
                    style: TextStyle(fontSize: 14.sp, color: const Color(0xFF6B7280), fontFamily: 'Roboto'),
                  ),
                ),
              ),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    final monthName = DateFormat('MMMM yyyy').format(_currentMonth);
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final daysInMonth = lastDay.day;
    final startWeekday = firstDay.weekday % 7;

    return Container(
      padding: EdgeInsets.all(16.w),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, size: 28.sp, color: const Color(0xFF1F2937)),
                onPressed: () {
                  setState(() {
                    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
                  });
                },
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(minWidth: 40.w, minHeight: 40.w),
              ),
              Text(
                monthName,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                  fontFamily: 'Roboto',
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, size: 28.sp, color: const Color(0xFF1F2937)),
                onPressed: () {
                  setState(() {
                    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
                  });
                },
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(minWidth: 40.w, minHeight: 40.w),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'].map((d) {
              return SizedBox(
                width: 36.w,
                child: Text(
                  d,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6B7280),
                    fontFamily: 'Roboto',
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 12.h),
          Builder(
            builder: (context) {
              final width = MediaQuery.of(context).size.width - 40.w - 32.w;
              final cellSize = (width - 14.w) / 7;
              final rows = <Widget>[];
              var day = 1;
              var cellIndex = 0;
              var rowCells = <Widget>[];

              for (var i = 0; i < startWeekday; i++) {
                rowCells.add(SizedBox(width: cellSize, height: cellSize));
                cellIndex++;
              }

              while (day <= daysInMonth) {
                final d = day;
                final isSelected = _selectedDate != null &&
                    _selectedDate!.year == _currentMonth.year &&
                    _selectedDate!.month == _currentMonth.month &&
                    _selectedDate!.day == d;
                final hasEvents = _dateHasEvents(d);
                final highlight = isSelected || hasEvents;

                rowCells.add(
                  Padding(
                    padding: EdgeInsets.all(2.w),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = DateTime(_currentMonth.year, _currentMonth.month, d);
                        });
                      },
                      child: Container(
                        width: cellSize - 4.w,
                        height: cellSize - 4.w,
                        decoration: BoxDecoration(
                          color: highlight ? const Color(0xFFFF9933) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Text(
                            '$d',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: highlight ? Colors.white : const Color(0xFF1F2937),
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
                cellIndex++;
                day++;

                if (cellIndex % 7 == 0) {
                  rows.add(Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: rowCells));
                  rowCells = [];
                }
              }

              if (rowCells.isNotEmpty) {
                while (rowCells.length < 7) {
                  rowCells.add(SizedBox(width: cellSize, height: cellSize));
                }
                rows.add(Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: rowCells));
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: rows,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEventsHeader() {
    if (_selectedDate == null) return const SizedBox.shrink();
    final dateStr = DateFormat('d MMMM, yyyy').format(_selectedDate!);
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
          color: const Color(0xFF1F2937),
          fontFamily: 'Roboto',
        ),
        children: [
          const TextSpan(text: 'Events on '),
          TextSpan(
            text: dateStr,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard({
    required String title,
    required String description,
    required String time,
    required String location,
    required String eventId,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.asset(
              'assets/images/home-hero.png',
              width: 90.w,
              height: 90.w,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 90.w,
                height: 90.w,
                color: const Color(0xFFF3F4F6),
                child: Icon(Icons.image_not_supported, size: 28.sp, color: Colors.grey),
              ),
            ),
          ),
          SizedBox(width: 14.w),
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
                SizedBox(height: 6.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF6B7280),
                    height: 1.35,
                    fontFamily: 'Roboto',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16.sp, color: const Color(0xFFFF9933)),
                    SizedBox(width: 6.w),
                    Text(
                      time,
                      style: TextStyle(fontSize: 13.sp, color: const Color(0xFF1F2937), fontFamily: 'Roboto'),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 16.sp, color: const Color(0xFFFF9933)),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        location,
                        style: TextStyle(fontSize: 13.sp, color: const Color(0xFF1F2937), fontFamily: 'Roboto'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  height: 40.h,
                  child: Material(
                    color: const Color(0xFFFF9933),
                    borderRadius: BorderRadius.circular(8.r),
                    child: InkWell(
                      onTap: () {
                        AppNavigator.pushToEventDetail(
                          context,
                          eventId: eventId,
                          eventTitle: title,
                        );
                      },
                      borderRadius: BorderRadius.circular(8.r),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
