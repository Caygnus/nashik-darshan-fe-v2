import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nashik/core/presentation/widgets/category_selection_widget.dart';
import 'package:nashik/core/presentation/widgets/filter_buttons_widget.dart';
import 'package:nashik/core/presentation/widgets/hotel_card_widget.dart';
import 'package:nashik/core/presentation/widgets/result_count_widget.dart';
import 'package:nashik/core/presentation/widgets/search_bar_widget.dart';
import 'package:nashik/core/presentation/widgets/section_title_widget.dart';
import 'package:nashik/core/presentation/widgets/user_review_card_widget.dart';
import 'package:nashik/core/presentation/widgets/view_all_button_widget.dart';

/// Hotels Screen
/// Displays hotels and accommodation options in Nashik
class HotelsScreen extends StatefulWidget {
  static const routeName = 'HotelsScreen';
  static const routePath = '/HotelsScreen';

  const HotelsScreen({super.key});

  @override
  State<HotelsScreen> createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  String selectedCategory = 'Hotels';
  String selectedFilter = 'All Hotels';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Hotels',
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              SearchBarWidget(
                hintText: 'Search hotels',
                onFilterTap: () {
                  // Handle filter tap
                },
              ),
              SizedBox(height: 16.h),

              // Category Selection
              CategorySelectionWidget(
                categories: const ['Restaurants', 'Hotels', 'Street Food'],
                selectedCategory: selectedCategory,
                onCategorySelected: (category) {
                  setState(() {
                    selectedCategory = category;
                  });
                },
              ),
              SizedBox(height: 16.h),

              // Filter Buttons
              FilterButtonsWidget(
                filters: const [
                  'All Hotels',
                  'Near Temples',
                  'Spiritual Stays',
                ],
                selectedFilter: selectedFilter,
                onFilterSelected: (filter) {
                  setState(() {
                    selectedFilter = filter;
                  });
                },
              ),
              SizedBox(height: 12.h),

              // Result Count
              const ResultCountWidget(count: 85, itemType: 'Hotels'),
              SizedBox(height: 16.h),

              // Festival Alert Box
              _buildFestivalAlertBox(),
              SizedBox(height: 16.h),

              // Hotel Cards
              HotelCardWidget(
                imagePath: 'assets/images/home-hero.png',
                name: 'The Gateway Hotel Nashik',
                price: '3,200',
                rating: 4.8,
                reviewCount: 1240,
                location: 'Near Trimbakeshwar Temple • 1.2 km from Bus Stand',
                nearbyInfo: '500m from Panchavati Ghats - Holy Site',
                amenities: const ['WiFi', 'Parking', 'Restaurant', 'Pool'],
                amenityIcons: const [
                  Icons.wifi,
                  Icons.local_parking,
                  Icons.restaurant,
                  Icons.pool,
                ],
                dealText: 'Family Deal: 20% off for 4+ guests',
                onViewDetails: () {
                  // Handle view details
                },
              ),
              SizedBox(height: 16.h),

              HotelCardWidget(
                imagePath: 'assets/images/home-hero.png',
                name: 'Hotel Panchavati',
                price: '1,299',
                rating: 4.2,
                reviewCount: 856,
                location: 'Panchavati Area • 500m from Sita Gufa',
                nearbyInfo: '200m from Kalaram Temple - Sacred Place',
                amenities: const ['WiFi', 'Parking', 'Restaurant', 'AC'],
                amenityIcons: const [
                  Icons.wifi,
                  Icons.local_parking,
                  Icons.restaurant,
                  Icons.ac_unit,
                ],
                dealText: 'Early Bird: 15% off on advance booking',
                onViewDetails: () {
                  // Handle view details
                },
              ),
              SizedBox(height: 16.h),

              HotelCardWidget(
                imagePath: 'assets/images/home-hero.png',
                name: 'Express Inn',
                price: '2,499',
                rating: 4.5,
                reviewCount: 642,
                location: 'Old Nashik Road • 800m from Ramkund',
                nearbyInfo: '300m from Godavari Ghat - Pilgrimage Site',
                amenities: const ['WiFi', 'Parking', 'Restaurant', 'Gym'],
                amenityIcons: const [
                  Icons.wifi,
                  Icons.local_parking,
                  Icons.restaurant,
                  Icons.fitness_center,
                ],
                dealText: 'Weekend Special: Free breakfast included',
                onViewDetails: () {
                  // Handle view details
                },
              ),
              SizedBox(height: 20.h),

              // View All Button
              ViewAllButtonWidget(
                onTap: () {
                  // Handle view all
                },
              ),
              SizedBox(height: 24.h),

              // Popular from Users Section
              const SectionTitleWidget(title: 'Popular from Users'),
              SizedBox(height: 16.h),

              // User Review Cards
              UserReviewCardWidget(
                profileImage: 'assets/images/home-hero.png',
                name: 'Rajesh Kumar',
                city: 'Delhi',
                planTitle: 'Family Weekend Getaway',
                planDescription:
                    'Perfect 2-day stay with family near all major attractions',
                rating: '4.7',
                reviewCount: '89',
                onUsePlanTap: () {
                  // Handle use plan
                },
              ),
              SizedBox(height: 16.h),

              UserReviewCardWidget(
                profileImage: 'assets/images/home-hero.png',
                name: 'Anita Desai',
                city: 'Pune',
                planTitle: 'Peaceful Pilgrimage Stay',
                planDescription:
                    'Comfortable accommodation near temples for spiritual journey',
                rating: '4.9',
                reviewCount: '156',
                onUsePlanTap: () {
                  // Handle use plan
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFestivalAlertBox() {
    return Container(
      width: 358.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF944D), Color(0xFFFFB247)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          // Left side - Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Festival Alert ',
                      style: GoogleFonts.montserrat(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 28 / 18,
                      ),
                    ),
                    Text('🪔', style: TextStyle(fontSize: 18.sp)),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  'Kumbh Mela approaching - Book early for best rates!',
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    height: 20 / 14,
                  ),
                ),
              ],
            ),
          ),
          // Right side - Calendar Icon
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.calendar_today, color: Colors.white, size: 22.sp),
          ),
        ],
      ),
    );
  }
}
