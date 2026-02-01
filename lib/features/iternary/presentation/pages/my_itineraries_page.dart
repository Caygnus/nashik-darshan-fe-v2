import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nashik/core/router/route_names.dart';
import 'package:nashik/core/theme/colors.dart';

/// Saved itinerary status for filter and card display.
enum SavedItineraryStatus { all, upcoming, completed, draft }

String _formatSavedAt(DateTime d) {
  return DateFormat('d MMM yyyy \'at\' hh.mm a').format(d);
}

/// Lightweight model for a saved itinerary card on this page.
class _SavedItineraryItem {
  const _SavedItineraryItem({
    required this.id,
    required this.title,
    required this.savedAt,
    required this.durationDays,
    required this.groupType,
    required this.adults,
    required this.children,
    required this.status,
    required this.imagePath,
  });

  final String id;
  final String title;
  final DateTime savedAt;
  final int durationDays;
  final String groupType;
  final int adults;
  final int children;
  final SavedItineraryStatus status;
  final String imagePath;

  int get totalTravellers => adults + children;
  String get travellerBreakdown {
    final parts = <String>[];
    if (adults > 0) parts.add('$adults Adult${adults > 1 ? 's' : ''}');
    if (children > 0) parts.add('$children Child');
    return parts.join(', ');
  }
}

/// Saved itinerary page: search, filter chips, list of saved itinerary cards, Create New Itinerary button.
class MyItinerariesPage extends StatefulWidget {
  const MyItinerariesPage({super.key});

  @override
  State<MyItinerariesPage> createState() => _MyItinerariesPageState();
}

class _MyItinerariesPageState extends State<MyItinerariesPage> {
  final TextEditingController _searchController = TextEditingController();
  SavedItineraryStatus _selectedFilter = SavedItineraryStatus.all;
  static const List<String> _filterLabels = ['All', 'Upcoming', 'Completed', 'Draft'];

  static final List<_SavedItineraryItem> _allItems = [
    _SavedItineraryItem(
      id: '1',
      title: 'Spiritual Nashik Tour',
      savedAt: DateTime(2025, 1, 15, 14, 52),
      durationDays: 4,
      groupType: 'Family',
      adults: 2,
      children: 1,
      status: SavedItineraryStatus.upcoming,
      imagePath: 'assets/png/trambak.png',
    ),
    _SavedItineraryItem(
      id: '2',
      title: 'Adventure Nashik Tour',
      savedAt: DateTime(2025, 1, 10, 11, 30),
      durationDays: 2,
      groupType: 'Friends',
      adults: 3,
      children: 0,
      status: SavedItineraryStatus.completed,
      imagePath: 'assets/png/trambak.png',
    ),
    _SavedItineraryItem(
      id: '3',
      title: 'Nashik Darshan Circuit',
      savedAt: DateTime(2025, 1, 8, 09, 15),
      durationDays: 5,
      groupType: 'Family',
      adults: 5,
      children: 4,
      status: SavedItineraryStatus.draft,
      imagePath: 'assets/png/herohome-bg.png',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_SavedItineraryItem> get _filteredItems {
    if (_selectedFilter == SavedItineraryStatus.all) return _allItems;
    return _allItems.where((e) => e.status == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20.sp,
            color: AppColors.darkText,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Saved itinerary',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.darkText,
            fontFamily: GoogleFonts.roboto().fontFamily,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.h),
            _buildSearchBar(),
            SizedBox(height: 16.h),
            _buildFilterChips(),
            SizedBox(height: 16.h),
            Text(
              '${items.length} Itineraries',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.grey,
                fontFamily: GoogleFonts.roboto().fontFamily,
              ),
            ),
            SizedBox(height: 12.h),
            ...items.map((item) => Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: _SavedItineraryCard(
                    item: item,
                    onTap: () => context.pushNamed(
                      AppRouteNames.itineraryDetail,
                      pathParameters: {'itineraryId': item.id},
                      queryParameters: {'title': item.title},
                    ),
                    onMore: () => _showCardMenu(context, item),
                  ),
                )),
            SizedBox(height: 24.h),
            _buildCreateNewButton(),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 22.sp, color: AppColors.grey),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.darkText,
                fontFamily: GoogleFonts.roboto().fontFamily,
              ),
              decoration: InputDecoration(
                hintText: 'Search trips, places, or dates',
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.grey,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_filterLabels.length, (i) {
          final status = SavedItineraryStatus.values[i];
          final label = _filterLabels[i];
          final isSelected = _selectedFilter == status;
          return Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = status),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(9999.r),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.white : AppColors.darkText,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCreateNewButton() {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: FilledButton(
        onPressed: () => context.pushNamed(AppRouteNames.customizeTrip),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 24.sp),
            SizedBox(width: 10.w),
            Text(
              'Create New Itinerary',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: GoogleFonts.roboto().fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCardMenu(BuildContext context, _SavedItineraryItem item) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                leading: Icon(Icons.edit_outlined, size: 22.sp),
                title: Text('Edit', style: TextStyle(fontSize: 16.sp)),
                onTap: () {
                  Navigator.pop(ctx);
                  context.pushNamed(
                    AppRouteNames.itineraryDetail,
                    pathParameters: {'itineraryId': item.id},
                    queryParameters: {'title': item.title},
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_outline, size: 22.sp),
                title: Text('Delete', style: TextStyle(fontSize: 16.sp, color: AppColors.errorColor)),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SavedItineraryCard extends StatelessWidget {
  const _SavedItineraryCard({
    required this.item,
    required this.onTap,
    required this.onMore,
  });

  final _SavedItineraryItem item;
  final VoidCallback onTap;
  final VoidCallback onMore;

  static Color _statusColor(SavedItineraryStatus s) {
    switch (s) {
      case SavedItineraryStatus.upcoming:
        return const Color(0xFFFCD34D); // yellow
      case SavedItineraryStatus.completed:
        return AppColors.primary; // orange
      case SavedItineraryStatus.draft:
        return const Color(0xFF3B82F6); // blue
      case SavedItineraryStatus.all:
        return AppColors.lightGrey;
    }
  }

  static Color _statusTextColor(SavedItineraryStatus s) {
    switch (s) {
      case SavedItineraryStatus.draft:
        return AppColors.white;
      default:
        return AppColors.darkText;
    }
  }

  static String _statusLabel(SavedItineraryStatus s) {
    switch (s) {
      case SavedItineraryStatus.upcoming:
        return 'Upcoming';
      case SavedItineraryStatus.completed:
        return 'Completed';
      case SavedItineraryStatus.draft:
        return 'Draft';
      case SavedItineraryStatus.all:
        return 'All';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusBg = _statusColor(item.status);
    final statusTextColor = _statusTextColor(item.status);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          height: 220.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
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
                  item.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.lightGrey,
                    child: Icon(Icons.image_not_supported, size: 48.sp, color: AppColors.grey),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.2),
                        Colors.black.withValues(alpha: 0.6),
                        Colors.black.withValues(alpha: 0.85),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 14.h,
                  left: 14.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      _statusLabel(item.status),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: statusTextColor,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: IconButton(
                    onPressed: onMore,
                    icon: Icon(Icons.more_vert, size: 24.sp, color: AppColors.white),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(minWidth: 40.w, minHeight: 40.h),
                  ),
                ),
                Positioned(
                  left: 14.w,
                  right: 14.w,
                  bottom: 14.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Saved on ${_formatSavedAt(item.savedAt)}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.white.withValues(alpha: 0.95),
                          fontFamily: GoogleFonts.roboto().fontFamily,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        '${item.durationDays} Days • ${item.groupType}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          _buildAvatarStack(item.totalTravellers),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              '${item.totalTravellers} Travellers - ${item.travellerBreakdown}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.white.withValues(alpha: 0.95),
                                fontFamily: GoogleFonts.roboto().fontFamily,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
      ),
    );
  }

  Widget _buildAvatarStack(int count) {
    const int showCount = 3;
    final displayCount = count.clamp(1, showCount);
    return SizedBox(
      width: (28.w * displayCount) - (8.w * (displayCount - 1)),
      height: 28.h,
      child: Stack(
        children: List.generate(displayCount, (i) {
          return Positioned(
            left: i * 20.0.w,
            child: CircleAvatar(
              radius: 14.r,
              backgroundColor: AppColors.white,
              child: CircleAvatar(
                radius: 12.r,
                backgroundColor: AppColors.primary.withValues(alpha: 0.3),
                child: Text(
                  '${i + 1}',
                  style: TextStyle(fontSize: 10.sp, color: AppColors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
