import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nashik/core/router/route_names.dart';
import 'package:nashik/core/utils/snackbar.dart';

import '../../domain/entities/saved_itinerary.dart';
import 'customize_trip_steps/customize_trip_steps.dart';

/// Customize Trip Page
///
/// Multi-step flow: Trip Overview → Trip Basics → Travel Preferences → Plan Your Days → Final Preview.
/// Each step is built in this file; for better maintainability and testability, consider extracting
/// steps into separate widgets under [customize_trip_steps/] (see [CustomizeTripSectionTitle]).
class CustomizeTripPage extends StatefulWidget {
  const CustomizeTripPage({super.key});

  @override
  State<CustomizeTripPage> createState() => _CustomizeTripPageState();
}

class _CustomizeTripPageState extends State<CustomizeTripPage> {
  int _currentStep = 0;
  // Trip Overview - dates drive total days and day tabs
  DateTime? _tripStartDate;
  DateTime? _tripEndDate;
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _arrivalTimeController = TextEditingController();
  final _arrivalDateController = TextEditingController();
  String _tripType = 'Family';
  int _adults = 2;
  int _children = 1;
  int _seniors = 0;
  // Trip Basics
  final _tripNameController = TextEditingController(text: '');
  final _destinationController = TextEditingController(text: '');
  String _destinationCategory = 'Temples';
  String _travelStyle = 'Adventure';
  // Travel Preferences (filter)
  String _preferenceFilter = 'All';
  // Plan Your Days
  int _selectedDayIndex = 0;
  final List<Map<String, String>> _morningPlaces = [
    {'name': 'Kalaram Temple', 'category': 'Temple', 'distance': '2.3 km from hotel', 'tagColor': 'purple'},
    {'name': 'Sadhana Restaurant', 'category': 'Food', 'distance': '1.5 km from hotel', 'tagColor': 'orange'},
  ];
  final List<Map<String, String>> _afternoonPlaces = [
    {'name': 'Pandavleni Caves', 'category': 'Heritage', 'distance': '8.5 km from hotel', 'tagColor': 'blue'},
  ];
  final List<Map<String, String>> _eveningPlaces = [];
  // Final Preview
  bool _notesExpanded = true;
  final _tripNotesController = TextEditingController(
    text: 'Focus on spiritual sites and family-friendly activities. Prefer morning visits to temples. Need vegetarian food options.',
  );

  static const List<String> _tripTypes = ['Solo', 'Family', 'Friends', 'Pilgrimage'];
  static const List<String> _destinationCategories = ['Temples', 'Vineyards', 'Trek spots', 'Waterfalls', 'Heritage'];
  static const List<Map<String, String>> _travelStyles = [
    {'label': 'Relaxed', 'icon': 'coffee'},
    {'label': 'Moderate', 'icon': 'walk'},
    {'label': 'Adventure', 'icon': 'hiking'},
    {'label': 'Pilgrimage', 'icon': 'hands'},
    {'label': 'Food & Wine', 'icon': 'food'},
    {'label': 'Cultural', 'icon': 'cultural'},
    {'label': 'Nature / Scenic', 'icon': 'nature'},
  ];
  static const List<String> _preferenceFilters = ['All', 'Spiritual', 'Adventure', 'Shopping'];
  static const List<Map<String, dynamic>> _recommendedPlaces = [
    {'name': 'Pandavleni Caves', 'category': 'Ancient Caves', 'rating': 4.5},
    {'name': 'Anjaneri Hills', 'category': 'Trekking', 'rating': 4.7},
    {'name': 'Kalaram Temple', 'category': 'Ancient Temple', 'rating': 4.6},
    {'name': 'Panchvati Ghats', 'category': 'Holy Ghats', 'rating': 4.8},
  ];
  static final DateFormat _displayDateFormat = DateFormat('d MMM'); // 15 Jan
  static final DateFormat _displayWithWeekdayFormat = DateFormat('EEE'); // Mon
  static final DateFormat _fullDateFormat = DateFormat('d MMM yyyy'); // 15 Jan 2025
  static final DateFormat _inputDateFormat = DateFormat('MM/dd/yyyy');

  int get _totalDays {
    if (_tripStartDate == null || _tripEndDate == null) return 1;
    final days = _tripEndDate!.difference(_tripStartDate!).inDays + 1;
    return days < 1 ? 1 : days;
  }

  int get _tripDurationDays => _totalDays;

  List<Map<String, String>> get _dayTabs {
    final start = _tripStartDate ?? DateTime.now();
    final count = _totalDays;
    return List.generate(count, (i) {
      final d = start.add(Duration(days: i));
      final short = _displayDateFormat.format(d);
      final dateStr = '$short · ${_displayWithWeekdayFormat.format(d)}';
      return {'label': 'Day ${i + 1}', 'date': dateStr, 'shortDate': short, 'fullDate': _fullDateFormat.format(d)};
    });
  }

  void _clampSelectedDayIndex() {
    final maxIndex = _totalDays - 1;
    if (_selectedDayIndex > maxIndex && maxIndex >= 0) {
      _selectedDayIndex = maxIndex;
    }
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _tripStartDate = now;
    _tripEndDate = now.add(const Duration(days: 3));
    _startDateController.text = _inputDateFormat.format(_tripStartDate!);
    _endDateController.text = _inputDateFormat.format(_tripEndDate!);
    _arrivalTimeController.text = '09:00';
    _arrivalDateController.text = _inputDateFormat.format(_tripStartDate!);
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _arrivalTimeController.dispose();
    _arrivalDateController.dispose();
    _tripNameController.dispose();
    _destinationController.dispose();
    _tripNotesController.dispose();
    super.dispose();
  }

  void _onProceed() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
        _clampSelectedDayIndex();
      });
    }
  }

  void _onSaveItinerary() {
    if (_tripStartDate == null || _tripEndDate == null) return;
    final data = _buildSavedItineraryData();
    context.pushNamed(AppRouteNames.savedItinerary, extra: data);
  }

  SavedItineraryData _buildSavedItineraryData() {
    final tripName = _tripNameController.text.trim().isEmpty
        ? 'Spiritual Nashik Tour'
        : _tripNameController.text.trim();
    final start = _tripStartDate!;
    final end = _tripEndDate!;
    final preferenceTags = ['Adventure', 'Heritage', 'Nature', 'Relaxed', 'Cultural'];
    if (!preferenceTags.contains(_travelStyle)) {
      preferenceTags[0] = _travelStyle;
    }

    final dayPlans = <SavedDayPlan>[];
    for (var dayIndex = 0; dayIndex < _totalDays; dayIndex++) {
      final d = start.add(Duration(days: dayIndex));
      final shortDate = _displayDateFormat.format(d);
      // Use day 0 places for all days until per-day state is implemented
      final morningActivities = _morningPlaces.map((p) => _placeToActivity(p)).toList();
      final afternoonActivities = _afternoonPlaces.map((p) => _placeToActivity(p)).toList();
      final eveningActivities = _eveningPlaces.map((p) => _placeToActivity(p)).toList();

      final slots = <SavedSlotPlan>[
        SavedSlotPlan(
          slotName: 'Morning',
          timeRange: '08:00 - 12:00',
          activities: morningActivities,
          travelTimeAfter: _morningPlaces.length > 1 ? '8 min' : null,
        ),
        SavedSlotPlan(
          slotName: 'Afternoon',
          timeRange: '13:30 - 16:30',
          activities: afternoonActivities,
        ),
        SavedSlotPlan(
          slotName: 'Evening',
          timeRange: '17:00 - 21:00',
          activities: eveningActivities,
        ),
      ];

      dayPlans.add(SavedDayPlan(dayIndex: dayIndex, shortDate: shortDate, slots: slots));
    }

    return SavedItineraryData(
      tripName: tripName,
      savedAt: DateTime.now(),
      startDate: start,
      endDate: end,
      totalDays: _totalDays,
      tripType: _tripType,
      adults: _adults,
      children: _children,
      seniors: _seniors,
      preferenceTags: preferenceTags,
      dayPlans: dayPlans,
    );
  }

  SavedActivity _placeToActivity(Map<String, String> p) {
    final name = p['name'] ?? '';
    final category = p['category'] ?? '';
    final distance = p['distance'] ?? '';
    final tagColorKey = ItineraryTagColor.fromString(p['tagColor'] ?? 'purple');
    final desc = _activityDescription(name);
    final duration = _activityDuration(name);
    return SavedActivity(
      name: name,
      category: category,
      description: desc,
      duration: duration,
      distance: distance,
      tagColorKey: tagColorKey,
    );
  }

  Color _tagColorFor(ItineraryTagColor key) {
    return switch (key) {
      ItineraryTagColor.orange => const Color(0xFFFF9820),
      ItineraryTagColor.blue => const Color(0xFF2563EB),
      ItineraryTagColor.purple => const Color(0xFF7C3AED),
    };
  }

  String _activityDescription(String name) {
    switch (name) {
      case 'Kalaram Temple':
        return 'Ancient black stone temple dedicated to Lord Rama';
      case 'Sadhana Restaurant':
        return 'Traditional vegetarian lunch spot';
      case 'Pandavleni Caves':
        return 'Ancient Buddhist rock-cut caves with stunning views';
      default:
        return 'Visit this place';
    }
  }

  String _activityDuration(String name) {
    switch (name) {
      case 'Kalaram Temple':
        return '30-45 min';
      case 'Sadhana Restaurant':
        return '1 hr';
      case 'Pandavleni Caves':
        return '2-3 hrs';
      default:
        return '1 hr';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastStep = _currentStep == 4;
    final showProceed = _currentStep < 4;
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
          _currentStep == 4 ? 'Final Preview' : 'Customize your trip',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: _buildStepContent(),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 52.h,
                child: Material(
                  borderRadius: BorderRadius.circular(12.r),
                  child: InkWell(
                    onTap: isLastStep ? _onSaveItinerary : _onProceed,
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF994D), Color(0xFFFFB049)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          showProceed ? 'Proceed' : 'Save Itinerary',
                          style: GoogleFonts.montserrat(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildTripOverview();
      case 1:
        return _buildTripBasics();
      case 2:
        return _buildTravelPreferences();
      case 3:
        return _buildPlanYourDays();
      case 4:
        return _buildFinalPreview();
      default:
        return _buildTripOverview();
    }
  }

  // ---------- Step 0: Trip Overview ----------
  Widget _buildTripOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomizeTripSectionTitle('Trip Overview'),
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                'Start Date',
                'mm/dd/yyyy',
                _startDateController,
                onTap: () => _pickStartDate(),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildDateField(
                'End Date',
                'mm/dd/yyyy',
                _endDateController,
                onTap: () => _pickEndDate(),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildDateField('Arrival Time', '00:00:00', _arrivalTimeController),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildDateField(
                'Arrival Date',
                'mm/dd/yyyy',
                _arrivalDateController,
                onTap: () => _pickArrivalDate(),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            'Total: $_totalDays Days',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF16A34A),
              fontFamily: 'Roboto',
            ),
          ),
        ),
        CustomizeTripSectionTitle('Trip Type'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _tripTypes.map((type) {
              final isSelected = _tripType == type;
              return Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: Material(
                  color: isSelected ? const Color(0xFFFF9820) : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(9999.r),
                  child: InkWell(
                    onTap: () => setState(() => _tripType = type),
                    borderRadius: BorderRadius.circular(9999.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                      child: Text(
                        type,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : const Color(0xFF374151),
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        CustomizeTripSectionTitle('Number of Travellers'),
        _buildTravellersCard(),
        SizedBox(height: 24.h),
      ],
    );
  }

  Future<void> _pickStartDate() async {
    final initial = _tripStartDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _tripStartDate = picked;
      _startDateController.text = _inputDateFormat.format(picked);
      if (_tripEndDate != null && !_tripEndDate!.isAfter(picked) && !_isSameDay(_tripEndDate!, picked)) {
        _tripEndDate = picked;
        _endDateController.text = _inputDateFormat.format(picked);
      }
      _clampSelectedDayIndex();
    });
  }

  Future<void> _pickEndDate() async {
    final start = _tripStartDate ?? DateTime.now();
    final initial = _tripEndDate ?? start.add(const Duration(days: 3));
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(start) ? start : initial,
      firstDate: start,
      lastDate: start.add(const Duration(days: 365)),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _tripEndDate = picked;
      _endDateController.text = _inputDateFormat.format(picked);
      _clampSelectedDayIndex();
    });
  }

  Future<void> _pickArrivalDate() async {
    final initial = _tripStartDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _arrivalDateController.text = _inputDateFormat.format(picked);
    });
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Widget _buildDateField(
    String label,
    String hint,
    TextEditingController controller, {
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF374151),
            fontFamily: 'Roboto',
          ),
        ),
        SizedBox(height: 6.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    readOnly: onTap != null,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: TextStyle(fontSize: 14.sp, color: const Color(0xFF9CA3AF)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    style: TextStyle(fontSize: 14.sp, color: const Color(0xFF111827)),
                    onTap: onTap,
                  ),
                ),
                if (onTap != null)
                  Icon(Icons.calendar_today_outlined, size: 20.sp, color: const Color(0xFF9CA3AF)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTravellersCard() {
    final total = _adults + _children + _seniors;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(Icons.person_add_alt_1, size: 22.sp, color: const Color(0xFF7C3AED)),
              ),
              SizedBox(width: 12.w),
              Text(
                'Number of Travellers',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF111827),
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildTravellerRow('Adults', 'Age 18+', _adults, () => setState(() => _adults = (_adults - 1).clamp(0, 99)), () => setState(() => _adults++)),
          SizedBox(height: 12.h),
          _buildTravellerRow('Children', 'Age 2-17', _children, () => setState(() => _children = (_children - 1).clamp(0, 99)), () => setState(() => _children++)),
          SizedBox(height: 12.h),
          _buildTravellerRow('Seniors', 'Age 60+', _seniors, () => setState(() => _seniors = (_seniors - 1).clamp(0, 99)), () => setState(() => _seniors++)),
          SizedBox(height: 14.h),
          Row(
            children: [
              Icon(Icons.people_outline, size: 20.sp, color: const Color(0xFF6B7280)),
              SizedBox(width: 8.w),
              Text(
                'Travellers',
                style: TextStyle(fontSize: 14.sp, color: const Color(0xFF6B7280), fontFamily: 'Roboto'),
              ),
              SizedBox(width: 6.w),
              Text(
                '$total (${_adults} Adults${_children > 0 ? ', $_children Child${_children > 1 ? 'ren' : ''}' : ''}${_seniors > 0 ? ', $_seniors Senior${_seniors > 1 ? 's' : ''}' : ''})',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF111827), fontFamily: 'Roboto'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTravellerRow(String label, String subLabel, int value, VoidCallback onMinus, VoidCallback onPlus) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: const Color(0xFF111827), fontFamily: 'Roboto')),
              Text(subLabel, style: TextStyle(fontSize: 12.sp, color: const Color(0xFF9CA3AF), fontFamily: 'Roboto')),
            ],
          ),
        ),
        Row(
          children: [
            _buildCounterButton(Icons.remove, onMinus, value == 0),
            SizedBox(width: 16.w),
            Text('$value', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: const Color(0xFF111827), fontFamily: 'Roboto')),
            SizedBox(width: 16.w),
            _buildCounterButton(Icons.add, onPlus, false),
          ],
        ),
      ],
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onTap, bool disabled) {
    return Material(
      color: disabled ? const Color(0xFFF3F4F6) : const Color(0xFFFF9820),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: disabled ? null : onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 36.w,
          height: 36.w,
          child: Icon(icon, size: 20.sp, color: disabled ? const Color(0xFF9CA3AF) : Colors.white),
        ),
      ),
    );
  }

  // ---------- Step 1: Trip Basics ----------
  Widget _buildTripBasics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomizeTripSectionTitle('Trip Basics'),
        _buildTripNameCard(),
        CustomizeTripSectionTitle('Destination & Dates'),
        _buildDestinationCard(),
        CustomizeTripSectionTitle('Travel Preferences'),
        _buildTravelStyleCard(),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildTripNameCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(20.r)),
                child: Icon(Icons.edit_outlined, size: 22.sp, color: const Color(0xFFFF9820)),
              ),
              SizedBox(width: 12.w),
              Text('Trip Name', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: const Color(0xFF111827), fontFamily: 'Roboto')),
            ],
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _tripNameController,
            decoration: InputDecoration(
              hintText: "Give your trip a name",
              hintStyle: TextStyle(fontSize: 14.sp, color: const Color(0xFF9CA3AF)),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none),
              contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            ),
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF111827)),
          ),
          SizedBox(height: 4.h),
          Text("e.g., 'Spiritual Nashik Tour'", style: TextStyle(fontSize: 12.sp, color: const Color(0xFF9CA3AF), fontFamily: 'Roboto')),
        ],
      ),
    );
  }

  Widget _buildDestinationCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(20.r)),
                child: Icon(Icons.location_on_outlined, size: 22.sp, color: const Color(0xFF16A34A)),
              ),
              SizedBox(width: 12.w),
              Text('Destination', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: const Color(0xFF111827), fontFamily: 'Roboto')),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                Icon(Icons.search, size: 22.sp, color: const Color(0xFF9CA3AF)),
                SizedBox(width: 12.w),
                Expanded(
                  child: TextField(
                    controller: _destinationController,
                    decoration: InputDecoration(
                      hintText: 'Search destination...',
                      hintStyle: TextStyle(fontSize: 14.sp, color: const Color(0xFF9CA3AF)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    style: TextStyle(fontSize: 14.sp, color: const Color(0xFF111827)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _destinationCategories.map((cat) {
                final isSelected = _destinationCategory == cat;
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: Material(
                    color: isSelected ? const Color(0xFFFFF7ED) : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(9999.r),
                    child: InkWell(
                      onTap: () => setState(() => _destinationCategory = cat),
                      borderRadius: BorderRadius.circular(9999.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              cat == 'Temples' ? Icons.temple_hindu : cat == 'Vineyards' ? Icons.wine_bar : cat == 'Trek spots' ? Icons.terrain : cat == 'Waterfalls' ? Icons.water_drop : Icons.account_balance,
                              size: 18.sp,
                              color: isSelected ? const Color(0xFFFF9820) : const Color(0xFF6B7280),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              cat,
                              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: isSelected ? const Color(0xFFFF9820) : const Color(0xFF6B7280), fontFamily: 'Roboto'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
            decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(10.r), border: Border.all(color: const Color(0xFFE5E7EB))),
            child: Row(
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(18.r)),
                  child: Icon(Icons.schedule, size: 20.sp, color: const Color(0xFFFF9820)),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Trip Duration', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF111827), fontFamily: 'Roboto')),
                      Text('Auto-calculated', style: TextStyle(fontSize: 12.sp, color: const Color(0xFF9CA3AF), fontFamily: 'Roboto')),
                    ],
                  ),
                ),
                Text('$_tripDurationDays', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700, color: const Color(0xFFFF9820), fontFamily: 'Roboto')),
                SizedBox(width: 4.w),
                Text('Days', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF6B7280), fontFamily: 'Roboto')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelStyleCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(color: const Color(0xFFFCE7F3), borderRadius: BorderRadius.circular(20.r)),
                child: Icon(Icons.explore_outlined, size: 22.sp, color: const Color(0xFFDB2777)),
              ),
              SizedBox(width: 12.w),
              Text('Preferred Travel Style', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: const Color(0xFF111827), fontFamily: 'Roboto')),
            ],
          ),
          SizedBox(height: 14.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: _travelStyles.map((style) {
              final label = style['label'] as String;
              final isSelected = _travelStyle == label;
              return Material(
                color: isSelected ? const Color(0xFFFF9820) : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10.r),
                child: InkWell(
                  onTap: () => setState(() => _travelStyle = label),
                  borderRadius: BorderRadius.circular(10.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_travelStyleIcon(label), size: 20.sp, color: isSelected ? Colors.white : const Color(0xFF6B7280)),
                        SizedBox(width: 8.w),
                        Text(
                          label,
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : const Color(0xFF6B7280), fontFamily: 'Roboto'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  IconData _travelStyleIcon(String label) {
    switch (label) {
      case 'Relaxed':
        return Icons.coffee;
      case 'Moderate':
        return Icons.directions_walk;
      case 'Adventure':
        return Icons.hiking;
      case 'Pilgrimage':
        return Icons.volunteer_activism;
      case 'Food & Wine':
        return Icons.restaurant;
      case 'Cultural':
        return Icons.theater_comedy;
      case 'Nature / Scenic':
        return Icons.park;
      default:
        return Icons.explore;
    }
  }

  // ---------- Step 2: Travel Preferences (Recommended places) ----------
  Widget _buildTravelPreferences() {
    final sectionTitle = _preferenceFilter == 'All' ? 'Recommended Spiritual Places' : 'Recommended ${_preferenceFilter} Places';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomizeTripSectionTitle('Travel Preferences'),
        Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              Icon(Icons.search, size: 22.sp, color: const Color(0xFF9CA3AF)),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Search temples, vineyards, waterfalls...',
                  style: TextStyle(fontSize: 14.sp, color: const Color(0xFF9CA3AF), fontFamily: 'Roboto'),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _preferenceFilters.map((f) {
              final isSelected = _preferenceFilter == f;
              return Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: Material(
                  color: isSelected ? const Color(0xFFFF9820) : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(9999.r),
                  child: InkWell(
                    onTap: () => setState(() => _preferenceFilter = f),
                    borderRadius: BorderRadius.circular(9999.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                      child: Text(
                        f,
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : const Color(0xFF6B7280), fontFamily: 'Roboto'),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        CustomizeTripSectionTitle(sectionTitle),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.72,
          ),
          itemCount: _recommendedPlaces.length,
          itemBuilder: (context, index) {
            final place = _recommendedPlaces[index];
            final name = place['name'] as String;
            final category = place['category'] as String;
            return _buildPlaceCard(
              name,
              category,
              place['rating'] as double,
              onAdd: () => _addPlaceToItinerary(name, category),
            );
          },
        ),
        SizedBox(height: 12.h),
        Center(
          child: TextButton(
            onPressed: () => context.pushNamed(AppRouteNames.discoverNashik),
            child: Text('View More', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFFFF9820), fontFamily: 'Roboto')),
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  void _addPlaceToItinerary(String name, String category) {
    setState(() {
      _morningPlaces.add({
        'name': name,
        'category': category,
        'distance': '—',
        'tagColor': 'purple',
      });
    });
    Snackbar.showSuccess('Added "$name" to Morning');
  }

  Widget _buildPlaceCard(String name, String category, double rating, {VoidCallback? onAdd}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(11.r)),
                  child: Image.asset(
                    'assets/png/trambak.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: const Color(0xFFF3F4F6), child: Icon(Icons.image, color: Colors.grey)),
                  ),
                ),
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Material(
                    color: const Color(0xFFFF9820),
                    borderRadius: BorderRadius.circular(9999.r),
                    child: InkWell(
                      onTap: onAdd,
                      borderRadius: BorderRadius.circular(9999.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                        child: Text('Add', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Roboto')),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8.h,
                  right: 8.w,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, size: 16.sp, color: const Color(0xFFFBBF24)),
                      SizedBox(width: 4.w),
                      Text('$rating', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Roboto')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: const Color(0xFF111827), fontFamily: 'Roboto'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  category,
                  style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280), fontFamily: 'Roboto'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Step 3: Plan Your Days ----------
  Widget _buildPlanYourDays() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomizeTripSectionTitle('Plan Your Days'),
        SizedBox(
          height: 48.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _dayTabs.length,
            itemBuilder: (context, index) {
              final tab = _dayTabs[index];
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
                      child: Center(
                        child: Text(
                          '${tab['label']} (${tab['date']})',
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : const Color(0xFF6B7280), fontFamily: 'Roboto'),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20.h),
        _buildTimeSlot('Morning', '8:00 AM - 12:00 PM', Icons.wb_sunny_outlined, _morningPlaces),
        SizedBox(height: 16.h),
        _buildTimeSlot('Afternoon', '12:00 PM - 5:00 PM', Icons.wb_cloudy_outlined, _afternoonPlaces),
        SizedBox(height: 16.h),
        _buildTimeSlot('Evening', '5:00 PM - 9:00 PM', Icons.nightlight_round_outlined, _eveningPlaces),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildTimeSlot(String title, String timeRange, IconData icon, List<Map<String, String>> places) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 22.sp, color: const Color(0xFFFF9820)),
            SizedBox(width: 10.w),
            Text(
              '$title ($timeRange)',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: const Color(0xFF111827), fontFamily: 'Roboto'),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ...places.map((p) {
          final name = p['name']!;
          final category = p['category']!;
          return _buildDayPlaceCard(
            name,
            category,
            p['distance']!,
            ItineraryTagColor.fromString(p['tagColor'] ?? 'purple'),
            onDelete: () {
              setState(() {
                final idx = places.indexWhere((e) => e['name'] == name && e['category'] == category);
                if (idx != -1) places.removeAt(idx);
              });
            },
          );
        }),
        SizedBox(height: 8.h),
        _buildAddPlaceButton(title),
      ],
    );
  }

  Widget _buildDayPlaceCard(String name, String category, String distance, ItineraryTagColor tagColorKey, {VoidCallback? onDelete}) {
    final tagColor = _tagColorFor(tagColorKey);
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.asset(
                'assets/png/trambak.png',
                width: 64.w,
                height: 64.w,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(width: 64.w, height: 64.w, color: const Color(0xFFF3F4F6), child: Icon(Icons.image)),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(color: tagColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(9999.r)),
                    child: Text(category, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: tagColor, fontFamily: 'Roboto')),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    name,
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: const Color(0xFF111827), fontFamily: 'Roboto'),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 14.sp, color: const Color(0xFF6B7280)),
                      SizedBox(width: 4.w),
                      Text(distance, style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280), fontFamily: 'Roboto')),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(icon: Icon(Icons.delete_outline, size: 22.sp, color: Colors.red), onPressed: onDelete),
            // Drag handle: visual only; reorder can be added later with ReorderableListView
            Icon(Icons.drag_indicator, size: 22.sp, color: const Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPlaceButton(String slotName) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB), style: BorderStyle.solid),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, size: 22.sp, color: const Color(0xFFFF9820)),
          SizedBox(width: 8.w),
          Text('Add place to $slotName', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF6B7280), fontFamily: 'Roboto')),
        ],
      ),
    );
  }

  // ---------- Step 4: Final Preview ----------
  Widget _buildFinalPreview() {
    final tripName = _tripNameController.text.trim().isEmpty ? 'Spiritual Nashik Tour' : _tripNameController.text;
    final totalTravellers = _adults + _children + _seniors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        _buildPreviewTripCard(tripName, totalTravellers),
        CustomizeTripSectionTitle('Travel Preferences'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox.shrink(),
            TextButton(
              onPressed: () => setState(() => _currentStep = 1),
              child: Text('Edit', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFFFF9820), fontFamily: 'Roboto')),
            ),
          ],
        ),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: ['Adventure', 'Heritage', 'Nature', 'Relaxed', 'Cultural'].map((label) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(9999.r),
                border: Border.all(color: const Color(0xFFFF9820).withValues(alpha: 0.5)),
              ),
              child: Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: const Color(0xFFFF9820), fontFamily: 'Roboto')),
            );
          }).toList(),
        ),
        CustomizeTripSectionTitle('Day-by-Day Timeline'),
        SizedBox(
          height: 44.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _dayTabs.length,
            itemBuilder: (context, index) {
              final tab = _dayTabs[index];
              final isSelected = _selectedDayIndex == index;
              return Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: InkWell(
                  onTap: () => setState(() => _selectedDayIndex = index),
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: isSelected ? null : Colors.white,
                      gradient: isSelected ? const LinearGradient(colors: [Color(0xFFFF994D), Color(0xFFFFB049)], begin: Alignment.centerLeft, end: Alignment.centerRight) : null,
                      border: isSelected ? null : Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Center(
                      child: Text(
                        '${tab['label']} (${tab['shortDate'] ?? tab['date']})',
                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : const Color(0xFF6B7280), fontFamily: 'Roboto'),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        _buildPreviewTimeSlot('Morning', '08:00—12:00', Icons.wb_sunny_outlined, _morningPlaces),
        _buildPreviewTimeSlot('Afternoon', '12:00—17:00', Icons.wb_cloudy_outlined, _afternoonPlaces),
        _buildPreviewTimeSlot('Evening', '17:00—21:00', Icons.nightlight_round_outlined, _eveningPlaces),
        CustomizeTripSectionTitle('Trip Summary'),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
                decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(10.r), border: Border.all(color: const Color(0xFFE5E7EB))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Distance', style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280), fontFamily: 'Roboto')),
                    Text('~45 km', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: const Color(0xFF111827), fontFamily: 'Roboto')),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
                decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(10.r), border: Border.all(color: const Color(0xFFE5E7EB))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Transport Time/Day', style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280), fontFamily: 'Roboto')),
                    Text('~2.5 hrs', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: const Color(0xFF111827), fontFamily: 'Roboto')),
                  ],
                ),
              ),
            ),
          ],
        ),
        CustomizeTripSectionTitle('Notes & Travellers'),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          child: InkWell(
            onTap: () => setState(() => _notesExpanded = !_notesExpanded),
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Trip Notes & Share', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: const Color(0xFF111827), fontFamily: 'Roboto')),
                  ),
                  Icon(_notesExpanded ? Icons.expand_less : Icons.expand_more, size: 24.sp, color: const Color(0xFF6B7280)),
                ],
              ),
            ),
          ),
        ),
        if (_notesExpanded) ...[
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Trip Notes', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF111827), fontFamily: 'Roboto')),
                SizedBox(height: 8.h),
                Text(
                  _tripNotesController.text,
                  style: TextStyle(fontSize: 13.sp, color: const Color(0xFF6B7280), height: 1.4, fontFamily: 'Roboto'),
                ),
                SizedBox(height: 16.h),
                Text('Share with Travellers', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF111827), fontFamily: 'Roboto')),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.email_outlined, size: 20.sp, color: const Color(0xFFFF9820)),
                        label: Text('Email', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFFFF9820), fontFamily: 'Roboto')),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFFF9820)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.sms_outlined, size: 20.sp, color: const Color(0xFFFF9820)),
                        label: Text('SMS', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFFFF9820), fontFamily: 'Roboto')),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFFF9820)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildPreviewTripCard(String tripName, int totalTravellers) {
    return Container(
      height: 180.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Image.asset(
              'assets/png/trambak.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: const Color(0xFFF3F4F6)),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
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
                  tripName,
                  style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700, color: Colors.white, fontFamily: 'Roboto'),
                ),
                SizedBox(height: 6.h),
                Text(
                  _tripStartDate != null && _tripEndDate != null
                      ? '${_fullDateFormat.format(_tripStartDate!)} – ${_fullDateFormat.format(_tripEndDate!)}'
                      : 'Select dates in Trip Overview',
                  style: TextStyle(fontSize: 14.sp, color: Colors.white.withValues(alpha: 0.9), fontFamily: 'Roboto'),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    _buildChip('$_tripDurationDays Days', Colors.white.withValues(alpha: 0.3)),
                    SizedBox(width: 8.w),
                    _buildChip(_tripType, Colors.white.withValues(alpha: 0.3)),
                    SizedBox(width: 8.w),
                    Row(
                      children: [
                        CircleAvatar(radius: 10.r, backgroundColor: Colors.white),
                        SizedBox(width: 4.w),
                        CircleAvatar(radius: 10.r, backgroundColor: Colors.white),
                        SizedBox(width: 4.w),
                        CircleAvatar(radius: 10.r, backgroundColor: Colors.white),
                      ],
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '$totalTravellers Travellers - $_adults Adults${_children > 0 ? ', $_children Child' : ''}${_seniors > 0 ? ', $_seniors Senior' : ''}',
                      style: TextStyle(fontSize: 12.sp, color: Colors.white.withValues(alpha: 0.9), fontFamily: 'Roboto'),
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

  Widget _buildChip(String label, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(9999.r)),
      child: Text(label, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.white, fontFamily: 'Roboto')),
    );
  }

  Widget _buildPreviewTimeSlot(String title, String timeRange, IconData icon, List<Map<String, String>> places) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20.sp, color: const Color(0xFFFF9820)),
            SizedBox(width: 8.w),
            Text('$title ($timeRange)', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF111827), fontFamily: 'Roboto')),
          ],
        ),
        SizedBox(height: 8.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...places.map((p) {
                final tagColor = _tagColorFor(ItineraryTagColor.fromString(p['tagColor'] ?? 'purple'));
                return Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: SizedBox(
                    width: 160.w,
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.asset('assets/png/trambak.png', width: 48.w, height: 48.w, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 48.w, height: 48.w, color: const Color(0xFFF3F4F6))),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                  decoration: BoxDecoration(color: tagColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(9999.r)),
                                  child: Text(p['category']!, style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: tagColor, fontFamily: 'Roboto')),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  p['name']!,
                                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: const Color(0xFF111827), fontFamily: 'Roboto'),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${p['distance']?.split(' ').take(2).join(' ')}...',
                                  style: TextStyle(fontSize: 11.sp, color: const Color(0xFF6B7280), fontFamily: 'Roboto'),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.more_vert, size: 20.sp, color: const Color(0xFF9CA3AF)),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: SizedBox(
                  width: 140.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFE5E7EB), style: BorderStyle.solid),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 20.sp, color: const Color(0xFFFF9820)),
                        SizedBox(width: 6.w),
                        Flexible(
                          child: Text(
                            'Add place to $title',
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: const Color(0xFF6B7280), fontFamily: 'Roboto'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}
