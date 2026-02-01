import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Add Stops Page
/// Add or remove places, reorder days, set durations, and save itinerary.
class AddStopsPage extends StatefulWidget {
  const AddStopsPage({
    super.key,
    this.tripTitle = 'Your Nashik Trip',
  });

  final String tripTitle;

  @override
  State<AddStopsPage> createState() => _AddStopsPageState();
}

class _AddStopsPageState extends State<AddStopsPage> {
  int _selectedDayIndex = 0;
  String _selectedFilter = 'Must-see';
  final List<String> _dayTabs = ['Day 1 • 3 stops', 'Day 2 • 4 stops'];
  final List<String> _filters = ['Must-see', 'Near me', 'Favorites', 'Trending'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20.sp, color: const Color(0xFF111827)),
          onPressed: () => context.pop(),
        ),
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
              fontFamily: 'Roboto',
            ),
            children: [
              const TextSpan(text: 'Add Stops — '),
              TextSpan(
                text: widget.tripTitle,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: SizedBox(
              height: 36.h,
              child: Material(
                color: const Color(0xFFFF9820),
                borderRadius: BorderRadius.circular(10.r),
                child: InkWell(
                  onTap: () => context.pop(),
                  borderRadius: BorderRadius.circular(10.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Center(
                      child: Text(
                        'Save',
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
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              Text(
                'Add or remove temples, vineyards & attractions. Reorder your days, set durations, and save offline.',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xFF6B7280),
                  height: 1.4,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 20.h),
              _buildDayTabs(),
              SizedBox(height: 16.h),
              _buildSearchBar(),
              SizedBox(height: 12.h),
              _buildFilterPills(),
              SizedBox(height: 16.h),
              _buildAutoOptimizeButton(),
              SizedBox(height: 24.h),
              _buildSectionTitle('Your Itinerary'),
              SizedBox(height: 12.h),
              _buildItineraryCard(
                imagePath: 'assets/png/trambak.png',
                title: 'Trimbakeshwar Temple',
                tag: 'Temple',
                tagColor: const Color(0xFFFF9820),
                visitInfo: '60 min visit • 6:00 AM - 9:00 PM',
                locationInfo: 'Start point',
                isStartPoint: true,
                onRemove: () {},
                onNotes: () {},
              ),
              SizedBox(height: 12.h),
              _buildItineraryCard(
                imagePath: 'assets/png/trambak.png',
                title: 'Pahine waterfalll',
                tag: 'Waterfall',
                tagColor: const Color(0xFFEDE9FE),
                tagTextColor: const Color(0xFF6D28D9),
                visitInfo: '2 hr visit • 10:00 AM - 7:00 PM',
                travelInfo: '25 min from previous',
                extraInfo: 'Wine tasting available • Book ahead',
                extraInfoColor: const Color(0xFF16A34A),
                onRemove: () {},
                onNotes: () {},
              ),
              SizedBox(height: 12.h),
              _buildItineraryCard(
                imagePath: 'assets/png/trambak.png',
                title: 'Pandavleni Caves',
                tag: 'Heritage',
                tagColor: const Color(0xFFDBEAFE),
                tagTextColor: const Color(0xFF2563EB),
                visitInfo: '90 min visit • 9:00 AM - 6:00 PM',
                travelInfo: '15 min from previous',
                isFavorited: true,
                onRemove: () {},
                onNotes: () {},
              ),
              SizedBox(height: 24.h),
              _buildSectionTitle('Recommended for You'),
              SizedBox(height: 12.h),
              _buildRecommendationCard(
                imagePath: 'assets/png/trambak.png',
                title: 'Kalaram Temple',
                tag: 'Temple',
                tagColor: const Color(0xFFFF9820),
                duration: '45 min',
                distance: '2.5 km',
                onAdd: () {},
              ),
              SizedBox(height: 12.h),
              _buildRecommendationCard(
                imagePath: 'assets/png/trambak.png',
                title: 'Saptashrungi Temple',
                tag: 'Temple',
                tagColor: const Color(0xFFFF9820),
                duration: '2 hr',
                distance: '60 km',
                onAdd: () {},
              ),
              SizedBox(height: 12.h),
              _buildRecommendationCard(
                imagePath: 'assets/png/trambak.png',
                title: 'Anjaneri Hills',
                tag: 'Nature',
                tagColor: const Color(0xFFDCFCE7),
                tagTextColor: const Color(0xFF16A34A),
                duration: '3 hr',
                distance: '20 km',
                onAdd: () {},
              ),
              SizedBox(height: 24.h),
              _buildSectionTitle('Heritage & Caves'),
              SizedBox(height: 12.h),
              _buildRecommendationCard(
                imagePath: 'assets/png/trambak.png',
                title: 'Harihareshwar',
                tag: 'Heritage',
                tagColor: const Color(0xFFDBEAFE),
                tagTextColor: const Color(0xFF2563EB),
                duration: '1.5 hr',
                distance: '35 km',
                onAdd: () {},
              ),
              SizedBox(height: 80.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayTabs() {
    return Row(
      children: List.generate(_dayTabs.length, (i) {
        final isSelected = _selectedDayIndex == i;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == 0 ? 10.w : 0),
            child: Material(
              color: isSelected ? const Color(0xFFFFF7ED) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(9999.r),
              child: InkWell(
                onTap: () => setState(() => _selectedDayIndex = i),
                borderRadius: BorderRadius.circular(9999.r),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9999.r),
                    border: Border.all(
                      color: isSelected ? const Color(0xFFFF9820) : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _dayTabs[i],
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? const Color(0xFFFF9820) : const Color(0xFF6B7280),
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSearchBar() {
    return Container(
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
              'Search places, e.g., Trimbakeshwar, Sula Vineyards...',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF9CA3AF),
                fontFamily: 'Roboto',
              ),
            ),
          ),
          Icon(Icons.mic_none_outlined, size: 22.sp, color: const Color(0xFF6B7280)),
        ],
      ),
    );
  }

  Widget _buildFilterPills() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((f) {
          final isSelected = _selectedFilter == f;
          return Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: Material(
              color: isSelected ? const Color(0xFFFFF7ED) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(9999.r),
              child: InkWell(
                onTap: () => setState(() => _selectedFilter = f),
                borderRadius: BorderRadius.circular(9999.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  child: Text(
                    f,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? const Color(0xFFFF9820) : const Color(0xFF6B7280),
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAutoOptimizeButton() {
    return SizedBox(
      width: double.infinity,
      height: 44.h,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(Icons.route, size: 20.sp, color: const Color(0xFFFF9820)),
        label: Text(
          'Auto-Optimize Route',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFFF9820),
            fontFamily: 'Roboto',
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFFF9820)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1F2937),
        fontFamily: 'Roboto',
      ),
    );
  }

  Widget _buildItineraryCard({
    required String imagePath,
    required String title,
    required String tag,
    required Color tagColor,
    Color tagTextColor = Colors.white,
    required String visitInfo,
    String? locationInfo,
    String? travelInfo,
    String? extraInfo,
    Color? extraInfoColor,
    bool isStartPoint = false,
    bool isFavorited = false,
    required VoidCallback onRemove,
    required VoidCallback onNotes,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.asset(
              imagePath,
              width: 80.w,
              height: 80.w,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 80.w,
                height: 80.w,
                color: const Color(0xFFF3F4F6),
                child: Icon(Icons.image_not_supported, size: 24.sp, color: Colors.grey),
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
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F2937),
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                    Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      size: 20.sp,
                      color: isFavorited ? Colors.red : const Color(0xFF9CA3AF),
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.drag_indicator, size: 20.sp, color: const Color(0xFF9CA3AF)),
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
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14.sp, color: const Color(0xFF6B7280)),
                    SizedBox(width: 4.w),
                    Text(
                      visitInfo,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF6B7280),
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                if (locationInfo != null) ...[
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 14.sp, color: const Color(0xFF6B7280)),
                      SizedBox(width: 4.w),
                      Text(
                        locationInfo,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF6B7280),
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                ],
                if (travelInfo != null) ...[
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.directions_car, size: 14.sp, color: const Color(0xFF6B7280)),
                      SizedBox(width: 4.w),
                      Text(
                        travelInfo,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF6B7280),
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                ],
                if (extraInfo != null) ...[
                  SizedBox(height: 6.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: (extraInfoColor ?? const Color(0xFF16A34A)).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      extraInfo,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: extraInfoColor ?? const Color(0xFF16A34A),
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 10.h),
                Row(
                  children: [
                    GestureDetector(
                      onTap: onRemove,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.delete_outline, size: 18.sp, color: Colors.red),
                          SizedBox(width: 4.w),
                          Text(
                            'Remove',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20.w),
                    GestureDetector(
                      onTap: onNotes,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.note_add_outlined, size: 18.sp, color: const Color(0xFF6B7280)),
                          SizedBox(width: 4.w),
                          Text(
                            'Notes',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF6B7280),
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
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

  Widget _buildRecommendationCard({
    required String imagePath,
    required String title,
    required String tag,
    required Color tagColor,
    Color tagTextColor = Colors.white,
    required String duration,
    required String distance,
    required VoidCallback onAdd,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.asset(
              imagePath,
              width: 72.w,
              height: 72.w,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 72.w,
                height: 72.w,
                color: const Color(0xFFF3F4F6),
                child: Icon(Icons.image_not_supported, size: 24.sp, color: Colors.grey),
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
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2937),
                    fontFamily: 'Roboto',
                  ),
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
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12.sp, color: const Color(0xFF6B7280)),
                    SizedBox(width: 4.w),
                    Text(
                      '$duration • $distance',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFF6B7280),
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Material(
            color: const Color(0xFFFF9820),
            borderRadius: BorderRadius.circular(10.r),
            child: InkWell(
              onTap: onAdd,
              borderRadius: BorderRadius.circular(10.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 18.sp, color: Colors.white),
                    SizedBox(width: 4.w),
                    Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 13.sp,
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
        ],
      ),
    );
  }
}
