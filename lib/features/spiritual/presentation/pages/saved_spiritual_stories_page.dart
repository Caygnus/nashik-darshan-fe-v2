import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nashik/core/theme/colors.dart';

class _SavedStoryItem {
  const _SavedStoryItem({
    required this.id,
    required this.title,
    required this.description,
    required this.savedAt,
    required this.thumbnailPath,
  });

  final String id;
  final String title;
  final String description;
  final DateTime savedAt;
  final String thumbnailPath;
}

String _formatSavedAt(DateTime d) {
  return DateFormat('MMM d, yyyy • HH:mm').format(d);
}

/// Saved Spiritual Stories page: app bar, hero banner, search bar, list of story cards.
class SavedSpiritualStoriesPage extends StatefulWidget {
  const SavedSpiritualStoriesPage({super.key});

  static const routeName = 'SavedSpiritualStoriesPage';
  static const routePath = '/saved-spiritual-stories';

  @override
  State<SavedSpiritualStoriesPage> createState() => _SavedSpiritualStoriesPageState();
}

class _SavedSpiritualStoriesPageState extends State<SavedSpiritualStoriesPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<_SavedStoryItem> _items = [
    _SavedStoryItem(
      id: '1',
      title: 'The Sacred Godavari',
      description:
          'The holy Godavari river flows through Nashik, making it one of the four sacred Kumbh Mela sites. Pilgrims gather here for sacred baths and rituals that have been performed for centuries.',
      savedAt: DateTime(2025, 1, 15, 8, 10),
      thumbnailPath: 'assets/png/herohome-bg.png',
    ),
    _SavedStoryItem(
      id: '2',
      title: 'The Bells of Kashi',
      description:
          'A mystical tale of the ancient temples and the resonance of bells that echo through the ghats of Nashik, connecting devotees to a timeless spiritual heritage.',
      savedAt: DateTime(2025, 1, 14, 16, 30),
      thumbnailPath: 'assets/png/trambak.png',
    ),
    _SavedStoryItem(
      id: '3',
      title: 'Trimbak: Where the Ganga Begins',
      description:
          'The source of the Godavari at Trimbakeshwar holds profound significance. Discover the legends and the spiritual journey that draws millions to this sacred town.',
      savedAt: DateTime(2025, 1, 12, 9, 0),
      thumbnailPath: 'assets/png/trambak.png',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20.sp, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Saved Spiritual Stories',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.darkText,
            fontFamily: GoogleFonts.roboto().fontFamily,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeroBanner(),
            Transform.translate(
              offset: Offset(0, -24.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _buildSearchBar(),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 80.h),
              child: Column(
                children: _items.map((item) => Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: _StoryCard(
                        item: item,
                        onTap: () {},
                        onUnsave: () {
                          setState(() {
                            _items.removeWhere((e) => e.id == item.id);
                          });
                        },
                      ),
                    )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Stack(
      children: [
        SizedBox(
          height: 200.h,
          width: double.infinity,
          child: Image.asset(
            'assets/png/herohome-bg.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
        ),
        Container(
          height: 200.h,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.2),
                Colors.black.withValues(alpha: 0.6),
              ],
            ),
          ),
        ),
        Positioned(
          left: 20.w,
          right: 20.w,
          bottom: 32.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Saved Spiritual Stories',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Read, listen, or share the moments that moved you.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.white.withValues(alpha: 0.95),
                  fontFamily: GoogleFonts.roboto().fontFamily,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 24.sp, color: AppColors.grey),
          SizedBox(width: 14.w),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.darkText,
                fontFamily: GoogleFonts.roboto().fontFamily,
              ),
              decoration: InputDecoration(
                hintText: 'Search stories, saints, temples...',
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
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({
    required this.item,
    required this.onTap,
    required this.onUnsave,
  });

  final _SavedStoryItem item;
  final VoidCallback onTap;
  final VoidCallback onUnsave;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  item.thumbnailPath,
                  width: 100.w,
                  height: 100.h,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 100.w,
                    height: 100.h,
                    color: AppColors.lightGrey,
                    child: Icon(Icons.image_not_supported, size: 32.sp, color: AppColors.grey),
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkText,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.grey,
                        height: 1.4,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Saved ${_formatSavedAt(item.savedAt)}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.grey,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              IconButton(
                onPressed: onUnsave,
                icon: Icon(Icons.favorite, size: 24.sp, color: AppColors.primary),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(minWidth: 40.w, minHeight: 40.h),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
