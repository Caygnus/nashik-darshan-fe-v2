import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nashik/core/router/route_names.dart';

/// Itinerary Detail Page
/// Displays full plan: summary card, travel preferences, day-by-day timeline, and activity cards.
class ItineraryDetailPage extends StatefulWidget {
  const ItineraryDetailPage({
    super.key,
    required this.itineraryId,
    this.title = 'Itinerary detail page',
  });

  final String itineraryId;
  final String title;

  @override
  State<ItineraryDetailPage> createState() => _ItineraryDetailPageState();
}

class _ItineraryDetailPageState extends State<ItineraryDetailPage> {
  int _selectedDayIndex = 0;
  final List<String> _dayLabels = ['Day 1', 'Day 2', 'Day 3', 'Day 4'];
  final List<String> _dayDates = ['15 Jan', '16 Jan', '17 Jan', '18 Jan'];
  final Map<String, String> _notesByActivity = {};

  void _showNoteDialog(BuildContext context, {required String activityTitle}) {
    final initialText = _notesByActivity[activityTitle] ?? '';
    showDialog<String>(
      context: context,
      barrierColor: Colors.black26,
      builder: (ctx) => _NoteDialog(
        initialText: initialText,
        onSave: (text) {
          setState(() => _notesByActivity[activityTitle] = text);
          Navigator.of(ctx).pop(text);
        },
        onClose: () => Navigator.of(ctx).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20.sp, color: const Color(0xFF111827)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  _buildActionButtons(),
                  SizedBox(height: 24.h),
                  _buildTravelPreferencesSection(),
                  SizedBox(height: 24.h),
                  _buildDayByDaySection(),
                  SizedBox(height: 20.h),
                  _buildDayContent(),
                  SizedBox(height: 80.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Container(
        height: 220.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/home-hero.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: const Color(0xFFE5E7EB)),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.2),
                      Colors.black.withValues(alpha: 0.75),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 20.w,
                right: 20.w,
                bottom: 20.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spiritual Nashik Tour',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Saved on 15 Jan 2025 at 14.52 pm',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.normal,
                        color: Colors.white70,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        _buildBulletChip('4 Days'),
                        SizedBox(width: 12.w),
                        _buildBulletChip('Family'),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildAvatar('A'),
                            Transform.translate(offset: Offset(-8.w, 0), child: _buildAvatar('B')),
                            Transform.translate(offset: Offset(-16.w, 0), child: _buildAvatar('C')),
                          ],
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'For 3 Travellers · 3 Adults',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
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

  Widget _buildBulletChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(9999.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }

  Widget _buildAvatar(String letter) {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.w),
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6B7280),
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48.h,
            child: Material(
              color: const Color(0xFFFF9820),
              borderRadius: BorderRadius.circular(12.r),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12.r),
                child: Center(
                  child: Text(
                    'Edit Itinerary',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: SizedBox(
            height: 48.h,
            child: Material(
              color: const Color(0xFFFF9820),
              borderRadius: BorderRadius.circular(12.r),
              child: InkWell(
                onTap: () => context.pushNamed(
                  AppRouteNames.addStops,
                  queryParameters: {'tripTitle': widget.title},
                ),
                borderRadius: BorderRadius.circular(12.r),
                child: Center(
                  child: Text(
                    'Add Stops',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTravelPreferencesSection() {
    final preferences = ['Adventure', 'Heritage', 'Nature', 'Relaxed', 'Cultural'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Travel Preferences',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
            fontFamily: 'Roboto',
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: preferences.map((p) => Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(9999.r),
            ),
            child: Text(
              p,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF4B5563),
                fontFamily: 'Roboto',
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildDayByDaySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Day-by-Day Timeline',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
            fontFamily: 'Roboto',
          ),
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_dayLabels.length, (i) {
              final isSelected = _selectedDayIndex == i;
              return Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDayIndex = i),
                  child: Container(
                    width: 72.w,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFF9820) : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _dayLabels[i],
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : const Color(0xFF4B5563),
                            fontFamily: 'Roboto',
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _dayDates[i],
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.normal,
                            color: isSelected ? Colors.white70 : const Color(0xFF6B7280),
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
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

  Widget _buildDayContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTimeSlot('Morning', '08:00 - 12:00'),
        SizedBox(height: 12.h),
        _buildActivityCard(
          imagePath: 'assets/png/trambak.png',
          title: 'Kalaram Temple',
          tag: 'Temple',
          tagColor: const Color(0xFFEDE9FE),
          tagTextColor: const Color(0xFF6D28D9),
          description: 'Ancient black stone temple dedicated to Lord Rama',
          duration: '30-45 min',
          distance: '2.3 km',
          onNotesTap: () => _showNoteDialog(context, activityTitle: 'Kalaram Temple'),
        ),
        SizedBox(height: 16.h),
        _buildTravelTime('8 min'),
        SizedBox(height: 16.h),
        _buildActivityCard(
          imagePath: 'assets/png/trambak.png',
          title: 'Sadhana Restaurant',
          tag: 'Food',
          tagColor: const Color(0xFFDBEAFE),
          tagTextColor: const Color(0xFF2563EB),
          description: 'Traditional vegetarian lunch spot',
          duration: '1 hr',
          distance: '15.3 km',
          onNotesTap: () => _showNoteDialog(context, activityTitle: 'Sadhana Restaurant'),
        ),
        SizedBox(height: 20.h),
        _buildTimeSlot('Afternoon', '13:30 - 16:30'),
        SizedBox(height: 12.h),
        _buildActivityCard(
          imagePath: 'assets/png/trambak.png',
          title: 'Pandavleni Caves',
          tag: 'Heritage',
          tagColor: const Color(0xFFDBEAFE),
          tagTextColor: const Color(0xFF2563EB),
          description: 'Ancient Buddhist rock-cut caves with stunning views',
          duration: '2-3 hrs',
          distance: '8.5 km',
          onNotesTap: () => _showNoteDialog(context, activityTitle: 'Pandavleni Caves'),
        ),
      ],
    );
  }

  Widget _buildTimeSlot(String label, String time) {
    return Row(
      children: [
        Icon(Icons.wb_sunny_outlined, size: 24.sp, color: const Color(0xFFFF9820)),
        SizedBox(width: 10.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
            fontFamily: 'Roboto',
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          time,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
            color: const Color(0xFF6B7280),
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }

  Widget _buildTravelTime(String duration) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.directions_car, size: 20.sp, color: const Color(0xFF6B7280)),
        SizedBox(width: 8.w),
        Text(
          duration,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6B7280),
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCard({
    required String imagePath,
    required String title,
    required String tag,
    required Color tagColor,
    required Color tagTextColor,
    required String description,
    required String duration,
    required String distance,
    VoidCallback? onNotesTap,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
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
              imagePath,
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F2937),
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                    Icon(Icons.more_vert, size: 20.sp, color: const Color(0xFF9CA3AF)),
                  ],
                ),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: tagColor,
                    borderRadius: BorderRadius.circular(9999.r),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: tagTextColor,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF6B7280),
                    height: 1.35,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14.sp, color: const Color(0xFF9CA3AF)),
                    SizedBox(width: 4.w),
                    Text(
                      duration,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF6B7280),
                        fontFamily: 'Roboto',
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Icon(Icons.location_on_outlined, size: 14.sp, color: const Color(0xFF9CA3AF)),
                    SizedBox(width: 4.w),
                    Text(
                      distance,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF6B7280),
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 36.h,
                        child: Material(
                          color: const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(8.r),
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(8.r),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.directions, size: 16.sp, color: Colors.white),
                                SizedBox(width: 6.w),
                                Text(
                                  'Directions',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: SizedBox(
                        height: 36.h,
                        child: Material(
                          color: const Color(0xFFEAB308),
                          borderRadius: BorderRadius.circular(8.r),
                          child: InkWell(
                            onTap: onNotesTap ?? () {},
                            borderRadius: BorderRadius.circular(8.r),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.note_add_outlined, size: 16.sp, color: Colors.white),
                                SizedBox(width: 6.w),
                                Text(
                                  'Notes',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ],
                            ),
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

/// Note dialog: "Write Down your Note" with text input, close, and Save note button.
class _NoteDialog extends StatefulWidget {
  const _NoteDialog({
    required this.initialText,
    required this.onSave,
    required this.onClose,
  });

  final String initialText;
  final void Function(String text) onSave;
  final VoidCallback onClose;

  @override
  State<_NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<_NoteDialog> {
  late final TextEditingController _controller;

  static const Color _goldBrown = Color(0xFFB45309);
  static const Color _lightGoldBg = Color(0xFFFEF3C7);
  static const Color _creamBorder = Color(0xFFFDE68A);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: _creamBorder, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: _creamBorder.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Write Down your Note',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: _goldBrown,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                Material(
                  color: _lightGoldBg,
                  borderRadius: BorderRadius.circular(10.r),
                  child: InkWell(
                    onTap: widget.onClose,
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      child: Icon(Icons.close, size: 20.sp, color: const Color(0xFF1F2937)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              constraints: BoxConstraints(minHeight: 140.h),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: TextField(
                controller: _controller,
                maxLines: 6,
                minLines: 4,
                decoration: InputDecoration(
                  hintText: 'Type your note here...',
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF9CA3AF),
                    fontFamily: 'Roboto',
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF1F2937),
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.centerRight,
              child: Material(
                color: _lightGoldBg,
                borderRadius: BorderRadius.circular(12.r),
                child: InkWell(
                  onTap: () => widget.onSave(_controller.text.trim()),
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: _goldBrown, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.description_outlined, size: 20.sp, color: _goldBrown),
                        SizedBox(width: 8.w),
                        Text(
                          'Save note',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: _goldBrown,
                            fontFamily: 'Roboto',
                          ),
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
    );
  }
}
