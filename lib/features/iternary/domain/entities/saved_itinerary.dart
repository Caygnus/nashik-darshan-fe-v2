/// Saved itinerary entity (domain layer, pure Dart).
/// Used when passing saved itinerary data to UI; no Flutter dependency.
class SavedItineraryData {
  const SavedItineraryData({
    required this.tripName,
    required this.savedAt,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.tripType,
    required this.adults,
    required this.children,
    required this.seniors,
    required this.preferenceTags,
    required this.dayPlans,
  });

  final String tripName;
  final DateTime savedAt;
  final DateTime startDate;
  final DateTime endDate;
  final int totalDays;
  final String tripType;
  final int adults;
  final int children;
  final int seniors;
  final List<String> preferenceTags;
  final List<SavedDayPlan> dayPlans;
}

class SavedDayPlan {
  const SavedDayPlan({
    required this.dayIndex,
    required this.shortDate,
    required this.slots,
  });

  final int dayIndex;
  final String shortDate;
  final List<SavedSlotPlan> slots;
}

class SavedSlotPlan {
  const SavedSlotPlan({
    required this.slotName,
    required this.timeRange,
    required this.activities,
    this.travelTimeAfter,
  });

  final String slotName;
  final String timeRange;
  final List<SavedActivity> activities;
  final String? travelTimeAfter;
}

class SavedActivity {
  const SavedActivity({
    required this.name,
    required this.category,
    required this.description,
    required this.duration,
    required this.distance,
    required this.tagColorKey,
  });

  final String name;
  final String category;
  final String description;
  final String duration;
  final String distance;
  /// 'purple' | 'orange' | 'blue' for tag color
  final String tagColorKey;
}
