import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:nashik/core/router/route_names.dart';

import '../../domain/entities/saved_itinerary.dart';

/// Saved Itinerary Page
/// Displays the full saved itinerary: summary card, Edit/Share, preferences, day-by-day timeline, activity cards, More Actions.
class SavedItineraryPage extends StatefulWidget {
  const SavedItineraryPage({
    super.key,
    this.data,
  });

  final SavedItineraryData? data;

  @override
  State<SavedItineraryPage> createState() => _SavedItineraryPageState();
}

class _SavedItineraryPageState extends State<SavedItineraryPage> {
  int _selectedDayIndex = 0;
  /// Activity title → user note. TODO: Persist (e.g. local storage or backend) so notes survive navigation and app restart.
  final Map<String, String> _notesByActivity = {};
  static final DateFormat _savedAtFormat = DateFormat('d MMM yyyy \'at\' HH.mm');

  SavedItineraryData? get _data => widget.data;

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
    if (_data == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, size: 20.sp, color: const Color(0xFF111827)),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Saved Itinerary',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: const Color(0xFF111827), fontFamily: 'Roboto'),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Text(
            'No itinerary data',
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF6B7280), fontFamily: 'Roboto'),
          ),
        ),
      );
    }

    final dayPlans = _data!.dayPlans;
    final dayTabs = List.generate(_data!.totalDays, (i) {
      final d = _data!.startDate.add(Duration(days: i));
      return {'label': 'Day ${i + 1}', 'shortDate': DateFormat('d MMM').format(d)};
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20.sp, color: const Color(0xFF111827)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Saved Itinerary',
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
                  _buildSectionTitle('Day-by-Day Timeline'),
                  SizedBox(height: 12.h),
                  _buildDayTabs(dayTabs),
                  SizedBox(height: 20.h),
                  _buildDayContent(dayPlans),
                  SizedBox(height: 24.h),
                  _buildSectionTitle('More Actions'),
                  SizedBox(height: 12.h),
                  _buildMoreActions(),
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
    final d = _data!;
    final totalTravellers = d.adults + d.children + d.seniors;
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Container(
        height: 200.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.asset(
                'assets/png/trambak.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: const Color(0xFFE5E7EB)),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.75)],
                ),
              ),
            ),
            Positioned(
              top: 14.h,
              right: 14.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF16A34A),
                  borderRadius: BorderRadius.circular(9999.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, size: 16.sp, color: Colors.white),
                    SizedBox(width: 6.w),
                    Text(
                      'Saved',
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Roboto'),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16.w,
              right: 16.w,
              bottom: 16.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    d.tripName,
                    style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700, color: Colors.white, fontFamily: 'Roboto'),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Saved on ${_savedAtFormat.format(d.savedAt)}',
                    style: TextStyle(fontSize: 13.sp, color: Colors.white.withValues(alpha: 0.9), fontFamily: 'Roboto'),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Text(
                        '${d.totalDays} Days',
                        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.95), fontFamily: 'Roboto'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Text('•', style: TextStyle(fontSize: 12.sp, color: Colors.white.withValues(alpha: 0.8))),
                      ),
                      Text(
                        d.tripType,
                        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.95), fontFamily: 'Roboto'),
                      ),
                      SizedBox(width: 12.w),
                      Row(
                        children: List.generate(3, (_) => Padding(
                          padding: EdgeInsets.only(right: 4.w),
                          child: CircleAvatar(radius: 10.r, backgroundColor: Colors.white.withValues(alpha: 0.4)),
                        )),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '$totalTravellers Travellers - ${d.adults} Adults${d.children > 0 ? ', ${d.children} Child${d.children > 1 ? 'ren' : ''}' : ''}${d.seniors > 0 ? ', ${d.seniors} Senior${d.seniors > 1 ? 's' : ''}' : ''}',
                        style: TextStyle(fontSize: 12.sp, color: Colors.white.withValues(alpha: 0.9), fontFamily: 'Roboto'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
                onTap: () {
                  context.pushNamed(
                    AppRouteNames.addStops,
                    queryParameters: {'tripTitle': _data?.tripName ?? 'Your Nashik Trip'},
                  );
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Center(
                  child: Text(
                    'Edit Itinerary',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Roboto'),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        SizedBox(
          width: 48.w,
          height: 48.h,
          child: Material(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12.r),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12.r),
              child: Icon(Icons.share, size: 24.sp, color: const Color(0xFF111827)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTravelPreferencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Travel Preferences'),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: _data!.preferenceTags.map((tag) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(9999.r),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Text(
                tag,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color(0xFF374151), fontFamily: 'Roboto'),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF111827),
        fontFamily: 'Roboto',
      ),
    );
  }

  Widget _buildDayTabs(List<Map<String, String>> dayTabs) {
    return SizedBox(
      height: 72.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dayTabs.length,
        itemBuilder: (context, index) {
          final tab = dayTabs[index];
          final isSelected = _selectedDayIndex == index;
          return Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: Material(
              color: isSelected ? const Color(0xFFFF9820) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12.r),
              child: InkWell(
                onTap: () => setState(() => _selectedDayIndex = index),
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        tab['label']!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : const Color(0xFF6B7280),
                          fontFamily: 'Roboto',
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        tab['shortDate']!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : const Color(0xFF6B7280),
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDayContent(List<SavedDayPlan> dayPlans) {
    SavedDayPlan? plan;
    for (final p in dayPlans) {
      if (p.dayIndex == _selectedDayIndex) {
        plan = p;
        break;
      }
    }
    if (plan == null || plan.slots.isEmpty) {
      return Text(
        'No activities planned for this day.',
        style: TextStyle(fontSize: 14.sp, color: const Color(0xFF6B7280), fontFamily: 'Roboto'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: plan.slots.map((slot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSlotHeader(slot.slotName, slot.timeRange),
            SizedBox(height: 12.h),
            ...slot.activities.asMap().entries.map((entry) {
              final i = entry.key;
              final activity = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildActivityCard(activity),
                  if (i == 0 && slot.activities.length > 1 && slot.travelTimeAfter != null) ...[
                    SizedBox(height: 12.h),
                    _buildTravelTime(slot.travelTimeAfter!),
                    SizedBox(height: 12.h),
                  ],
                ],
              );
            }),
            SizedBox(height: 20.h),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSlotHeader(String name, String timeRange) {
    final icon = name == 'Morning'
        ? Icons.wb_sunny_outlined
        : name == 'Afternoon'
            ? Icons.wb_cloudy_outlined
            : Icons.nightlight_round_outlined;
    return Row(
      children: [
        Icon(icon, size: 22.sp, color: const Color(0xFFFF9820)),
        SizedBox(width: 10.w),
        Text(
          '$name $timeRange',
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: const Color(0xFF111827), fontFamily: 'Roboto'),
        ),
      ],
    );
  }

  Widget _buildTravelTime(String time) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.directions_car, size: 18.sp, color: const Color(0xFF2563EB)),
          SizedBox(width: 8.w),
          Text(
            time,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: const Color(0xFF6B7280), fontFamily: 'Roboto'),
          ),
        ],
      ),
    );
  }

  Color _tagColor(ItineraryTagColor key) {
    return switch (key) {
      ItineraryTagColor.orange => const Color(0xFFFF9820),
      ItineraryTagColor.blue => const Color(0xFF2563EB),
      ItineraryTagColor.purple => const Color(0xFF7C3AED),
    };
  }

  Color _tagBgColor(ItineraryTagColor key) {
    return switch (key) {
      ItineraryTagColor.orange => const Color(0xFFFFF7ED),
      ItineraryTagColor.blue => const Color(0xFFDBEAFE),
      ItineraryTagColor.purple => const Color(0xFFEDE9FE),
    };
  }

  Widget _buildActivityCard(SavedActivity activity) {
    final tagColor = _tagColor(activity.tagColorKey);
    final tagBg = _tagBgColor(activity.tagColorKey);
    return Container(
      padding: EdgeInsets.all(14.w),
      margin: EdgeInsets.only(bottom: 12.h),
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
              'assets/png/trambak.png',
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
                        activity.name,
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937), fontFamily: 'Roboto'),
                      ),
                    ),
                    Icon(Icons.more_vert, size: 20.sp, color: const Color(0xFF9CA3AF)),
                  ],
                ),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: tagBg,
                    borderRadius: BorderRadius.circular(9999.r),
                  ),
                  child: Text(
                    activity.category,
                    style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: tagColor, fontFamily: 'Roboto'),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  activity.description,
                  style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280), height: 1.35, fontFamily: 'Roboto'),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14.sp, color: const Color(0xFFFF9820)),
                    SizedBox(width: 4.w),
                    Text(activity.duration, style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280), fontFamily: 'Roboto')),
                    SizedBox(width: 12.w),
                    Icon(Icons.location_on_outlined, size: 14.sp, color: const Color(0xFFFF9820)),
                    SizedBox(width: 4.w),
                    Text(activity.distance, style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280), fontFamily: 'Roboto')),
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
                                Text('Directions', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Roboto')),
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
                            onTap: () => _showNoteDialog(context, activityTitle: activity.name),
                            borderRadius: BorderRadius.circular(8.r),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.note_add_outlined, size: 16.sp, color: Colors.white),
                                SizedBox(width: 6.w),
                                Text('Notes', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Roboto')),
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

  Widget _buildMoreActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.copy, size: 20.sp, color: const Color(0xFF6B7280)),
            label: Text(
              'Duplicate Itinerary',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: const Color(0xFF374151), fontFamily: 'Roboto'),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFE5E7EB)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              backgroundColor: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.delete_outline, size: 20.sp, color: const Color(0xFFDC2626)),
            label: Text(
              'Delete Itinerary',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: const Color(0xFFDC2626), fontFamily: 'Roboto'),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFFECACA)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              backgroundColor: const Color(0xFFFEF2F2),
            ),
          ),
        ),
      ],
    );
  }
}

/// Note dialog for activity notes.
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Write Down your Note',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: const Color(0xFF111827), fontFamily: 'Roboto'),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 24.sp, color: const Color(0xFF6B7280)),
                  onPressed: widget.onClose,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Add your note...',
                hintStyle: TextStyle(fontSize: 14.sp, color: const Color(0xFF9CA3AF)),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
                contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              ),
              style: TextStyle(fontSize: 14.sp, color: const Color(0xFF111827)),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 48.h,
              child: Material(
                color: const Color(0xFFFF9820),
                borderRadius: BorderRadius.circular(12.r),
                child: InkWell(
                  onTap: () => widget.onSave(_controller.text),
                  borderRadius: BorderRadius.circular(12.r),
                  child: Center(
                    child: Text(
                      'Save note',
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Roboto'),
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
