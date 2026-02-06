import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nashik/core/presentation/widgets/category_selection_widget.dart';
import 'package:nashik/core/presentation/widgets/filter_buttons_widget.dart';
import 'package:nashik/core/presentation/widgets/listing_card_widget.dart';
import 'package:nashik/core/presentation/widgets/promotional_box_widget.dart';
import 'package:nashik/core/presentation/widgets/result_count_widget.dart';
import 'package:nashik/core/presentation/widgets/search_bar_widget.dart';
import 'package:nashik/core/presentation/widgets/section_title_widget.dart';
import 'package:nashik/core/presentation/widgets/user_review_card_widget.dart';
import 'package:nashik/core/presentation/widgets/view_all_button_widget.dart';

/// Street Food Screen
/// Displays street food and local food stalls in Nashik
class StreetFoodScreen extends StatefulWidget {
  static const routeName = 'StreetFoodScreen';
  static const routePath = '/StreetFoodScreen';

  const StreetFoodScreen({super.key});

  @override
  State<StreetFoodScreen> createState() => _StreetFoodScreenState();
}

class _StreetFoodScreenState extends State<StreetFoodScreen> {
  String selectedCategory = 'Street Food';
  String selectedFilter = 'All';

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
          'Street Food',
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
                hintText: 'Search street food',
                onFilterTap: () {
                  // Handle filter tap
                },
              ),
              SizedBox(height: 16.h),

              // Category Selection
              CategorySelectionWidget(
                categories: const ['Street Food', 'Chaat', 'Snacks'],
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
                filters: const ['All', 'Veg Only', 'Spicy', 'Popular'],
                selectedFilter: selectedFilter,
                onFilterSelected: (filter) {
                  setState(() {
                    selectedFilter = filter;
                  });
                },
              ),
              SizedBox(height: 12.h),

              // Result Count
              const ResultCountWidget(
                count: 125,
                itemType: 'Street Food Stalls',
              ),
              SizedBox(height: 16.h),

              // Promotional Box
              const PromotionalBoxWidget(
                heading: 'Must Try!',
                subheading: 'Famous Nashik Street Food',
                iconPath: 'assets/svg/spoun.svg',
              ),
              SizedBox(height: 16.h),

              // Street Food Cards
              ListingCardWidget(
                imagePath: 'assets/images/home-hero.png',
                category: 'Famous Spot',
                name: 'Misal Pav Junction',
                rating: '4.7',
                ratingColor: const Color(0xFF22C55E),
                type: 'Street Food • Misal Specialist',
                description:
                    'Authentic Nashik-style spicy misal pav with farsan and lemon',
                price: '60',
                location: 'Old CBS Road',
                feature: 'Must Try',
                featureIcon: Icons.local_fire_department,
                buttonText: 'Get Directions',
                onButtonPressed: () {
                  // Handle get directions
                },
              ),
              SizedBox(height: 16.h),

              ListingCardWidget(
                imagePath: 'assets/images/home-hero.png',
                category: 'Local Favorite',
                name: 'Sabudana Vada Corner',
                rating: '4.5',
                ratingColor: const Color(0xFF22C55E),
                type: 'Street Food • Vada Specialist',
                description:
                    'Crispy sabudana vada with special green chutney, perfect for fasting',
                price: '40',
                location: 'Panchavati Area',
                feature: 'Fasting Food',
                featureIcon: Icons.verified,
                buttonText: 'Get Directions',
                onButtonPressed: () {
                  // Handle get directions
                },
              ),
              SizedBox(height: 16.h),

              ListingCardWidget(
                imagePath: 'assets/images/home-hero.png',
                category: 'Chaat Special',
                name: 'Nashik Chaat Bhandar',
                rating: '4.6',
                ratingColor: const Color(0xFF22C55E),
                type: 'Chaat • Multiple Varieties',
                description:
                    'Delicious pani puri, sev puri, and dahi puri with authentic taste',
                price: '50',
                location: 'Mahatma Nagar',
                feature: 'Hygienic',
                featureIcon: Icons.clean_hands,
                buttonText: 'Get Directions',
                onButtonPressed: () {
                  // Handle get directions
                },
              ),
              SizedBox(height: 16.h),

              ListingCardWidget(
                imagePath: 'assets/images/home-hero.png',
                category: 'Popular Choice',
                name: 'Batata Vada Express',
                rating: '4.4',
                ratingColor: const Color(0xFF22C55E),
                type: 'Street Food • Vada Pav',
                description:
                    'Hot and crispy batata vada with spicy chutney and garlic powder',
                price: '25',
                location: 'College Road',
                feature: 'Quick Bite',
                featureIcon: Icons.speed,
                buttonText: 'Get Directions',
                onButtonPressed: () {
                  // Handle get directions
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
                name: 'Sneha Patil',
                city: 'Nashik',
                planTitle: 'Street Food Trail',
                planDescription:
                    'Complete guide to best street food spots in old city area',
                rating: '4.9',
                reviewCount: '215',
                onUsePlanTap: () {
                  // Handle use plan
                },
              ),
              SizedBox(height: 16.h),

              UserReviewCardWidget(
                profileImage: 'assets/images/home-hero.png',
                name: 'Amit Joshi',
                city: 'Pune',
                planTitle: 'Evening Snacks Tour',
                planDescription:
                    'Perfect evening route covering 5 famous food stalls',
                rating: '4.8',
                reviewCount: '178',
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
}
