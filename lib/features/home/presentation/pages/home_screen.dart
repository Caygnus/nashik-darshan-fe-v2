import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// TODO: Uncomment when Quick Access section is enabled
// import 'package:go_router/go_router.dart';
// import 'package:nashik/features/eatery/presentation/pages/eatery_screen.dart';
// import 'package:nashik/features/hotels/presentation/pages/hotels_screen.dart';
// import 'package:nashik/features/street_food/presentation/pages/street_food_screen.dart';
// import 'package:nashik/features/transport/presentation/pages/transport_screen.dart';
import 'package:nashik/features/home/presentation/widgets/hero_image_header.dart';
import 'package:nashik/features/home/presentation/widgets/plan_journey/plan_my_journey_section.dart';
import 'package:nashik/features/home/presentation/widgets/popular_places/popular_in_nashik_section.dart';
// TODO: Uncomment when needed
// import 'package:nashik/features/home/presentation/widgets/quick_access/quick_access_section.dart';
import 'package:nashik/features/home/presentation/widgets/search_box_widget.dart';
import 'package:nashik/features/home/presentation/widgets/spiritual_experiences/spiritual_experiences_section.dart';
import 'package:nashik/features/home/presentation/widgets/spiritual_story/spiritual_story_card.dart';
import 'package:nashik/features/home/presentation/widgets/transparent_app_bar.dart';
// TODO: Uncomment when needed
// import 'package:nashik/features/home/presentation/widgets/travel_services/travel_services_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content with hero image at top
          SingleChildScrollView(
            child: Column(
              children: [
                const HeroImageHeader(),
                // Search box overlaps the hero image
                Transform.translate(
                  offset: Offset(0, -29.h),
                  child: const SearchBoxWidget(),
                ),
                // Spiritual Experiences Section
                Transform.translate(
                  offset: Offset(0, -20.h),
                  child: const SpiritualExperiencesSection(),
                ),
                // Spiritual Story of the Day Section
                Transform.translate(
                  offset: Offset(0, -10.h),
                  child: const SpiritualStoryCard(),
                ),
                // TODO: Uncomment when needed
                // Quick Access Section
                // QuickAccessSection(
                //   onDiscoverTap: () {
                //     context.pushNamed(StreetFoodScreen.routeName);
                //   },
                //   onTransportTap: () {
                //     context.pushNamed(TransportScreen.routeName);
                //   },
                //   onHotelsTap: () {
                //     context.pushNamed(HotelsScreen.routeName);
                //   },
                //   onEateryTap: () {
                //     context.pushNamed(EateryScreen.routeName);
                //   },
                // ),
                // Plan My Journey Section
                const PlanMyJourneySection(),
                SizedBox(height: 20.h),
                // Popular in Nashik Section
                const PopularInNashikSection(),
                SizedBox(height: 20.h),
                // TODO: Uncomment when needed
                // Travel Services Section
                // const TravelServicesSection(),
                // Add bottom padding to prevent content from going under bottom nav bar
                SizedBox(height: 80.h),
                // Add more content below here
              ],
            ),
          ),
          // Transparent AppBar overlay
          const TransparentAppBarWidget(),
        ],
      ),
    );
  }
}
