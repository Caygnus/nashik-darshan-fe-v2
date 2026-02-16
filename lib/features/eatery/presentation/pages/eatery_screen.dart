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

/// Eatery Screen
/// Displays restaurants and food options in Nashik
class EateryScreen extends StatefulWidget {
  static const routeName = 'EateryScreen';
  static const routePath = '/EateryScreen';

  const EateryScreen({super.key});

  @override
  State<EateryScreen> createState() => _EateryScreenState();
}

class _EateryScreenState extends State<EateryScreen> {
  String selectedCategory = 'Restaurants';
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
          'Restaurants',
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
                hintText: 'Search restaurant',
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
                filters: const ['All', 'Veg Only', 'Budget', 'Top Rated'],
                selectedFilter: selectedFilter,
                onFilterSelected: (filter) {
                  setState(() {
                    selectedFilter = filter;
                  });
                },
              ),
              SizedBox(height: 12.h),

              // Result Count
              const ResultCountWidget(count: 150, itemType: 'Restaurants'),
              SizedBox(height: 16.h),

              // Promotional Box
              const PromotionalBoxWidget(
                heading: 'Don\'t Miss Out',
                subheading: 'Traditional Misal Pav Spots',
                iconPath: 'assets/svg/spoun.svg',
              ),
              SizedBox(height: 16.h),

              // Restaurant Cards
              ListingCardWidget(
                imagePath: 'assets/images/home-hero.png',
                category: 'Wine & Dine',
                name: 'Sula Vineyard Restaurant',
                rating: '4.4',
                ratingColor: const Color(0xFF22C55E),
                type: 'Continental • Wine Tasting',
                description:
                    'Perfect vineyard retreat with wine tasting experience',
                price: '999',
                location: '12 km from city',
                feature: 'Wine Tours',
                featureIcon: Icons.wine_bar,
                buttonText: 'Book Tour',
                onButtonPressed: () {
                  // Handle book tour
                },
              ),
              SizedBox(height: 16.h),

              ListingCardWidget(
                imagePath: 'assets/images/home-hero.png',
                category: 'Popular Choice',
                name: 'Prasad Bhavan',
                rating: '4.4',
                ratingColor: const Color(0xFF22C55E),
                type: 'Satvik • Temple Food',
                description:
                    'Pure satvik meals perfect for pilgrims and devotees, Jain food is also Available',
                price: '452',
                location: 'Near Trimbakeshwar',
                feature: 'Jain Friendly',
                featureIcon: Icons.circle,
                buttonText: 'View Menu',
                onButtonPressed: () {
                  // Handle view menu
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

              // User Review Card
              UserReviewCardWidget(
                profileImage: 'assets/images/home-hero.png',
                name: 'Priya Sharma',
                city: 'Mumbai',
                planTitle: 'Solo Spiritual Journey',
                planDescription:
                    'Perfect 1-day plan for peaceful darshan and meditation',
                rating: '4.8',
                reviewCount: '124',
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
