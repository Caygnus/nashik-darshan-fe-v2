import 'package:go_router/go_router.dart';
import 'package:nashik/core/di/get_it.dart';
import 'package:nashik/core/router/app_router.dart';
import 'package:nashik/core/router/route_names.dart';
import 'package:nashik/core/router/route_paths.dart';
import 'package:nashik/features/discover_nashik/presentation/pages/discover_nashik_page.dart';
import 'package:nashik/features/eatery/presentation/pages/eatery_screen.dart';
import 'package:nashik/features/events/presentation/pages/event_detail_page.dart';
import 'package:nashik/features/events/presentation/pages/saved_events_page.dart';
import 'package:nashik/features/events/presentation/pages/upcoming_events_page.dart';
import 'package:nashik/features/hotels/presentation/pages/hotels_screen.dart';
import 'package:nashik/features/iternary/domain/entities/saved_itinerary.dart';
import 'package:nashik/features/iternary/presentation/pages/add_stops_page.dart';
import 'package:nashik/features/iternary/presentation/pages/customize_trip_page.dart';
import 'package:nashik/features/iternary/presentation/pages/itinerary_detail_page.dart';
import 'package:nashik/features/iternary/presentation/pages/my_itineraries_page.dart';
import 'package:nashik/features/iternary/presentation/pages/saved_itineraries_page.dart';
import 'package:nashik/features/iternary/presentation/pages/saved_itinerary_page.dart';
import 'package:nashik/features/places/domain/repositories/place_repository.dart';
import 'package:nashik/features/places/presentation/pages/category_detail_page.dart';
import 'package:nashik/features/places/presentation/pages/place_detail_page.dart';
import 'package:nashik/features/spiritual/presentation/pages/aarti_timing_page.dart';
import 'package:nashik/features/spiritual/presentation/pages/saved_spiritual_stories_page.dart';
import 'package:nashik/features/spiritual/presentation/pages/temple_darshan_page.dart';
import 'package:nashik/features/street_food/presentation/pages/street_food_screen.dart';
import 'package:nashik/features/transport/presentation/pages/transport_screen.dart';
import 'package:nashik/features/wishlist/presentation/pages/wishlist_page.dart';

/// Feature routes (standalone screens)
class FeatureRoutes {
  FeatureRoutes._();

  /// Get all feature routes
  static List<RouteBase> getRoutes() {
    return [
      GoRoute(
        path: AppRoutePaths.myItineraries,
        name: AppRouteNames.myItineraries,
        pageBuilder: (context, state) => AppRouter.getPage(
          child: const MyItinerariesPage(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.savedItinerariesList,
        name: AppRouteNames.savedItinerariesList,
        pageBuilder: (context, state) => AppRouter.getPage(
          child: const SavedItinerariesPage(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.wishlist,
        name: AppRouteNames.wishlist,
        pageBuilder: (context, state) => AppRouter.getPage(
          child: const WishlistPage(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.savedSpiritualStories,
        name: AppRouteNames.savedSpiritualStories,
        pageBuilder: (context, state) => AppRouter.getPage(
          child: const SavedSpiritualStoriesPage(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.itineraryDetail,
        name: AppRouteNames.itineraryDetail,
        pageBuilder: (context, state) {
          final itineraryId = state.pathParameters['itineraryId'] ?? '';
          final title = state.uri.queryParameters['title'] ?? 'Itinerary';
          return AppRouter.getPage(
            child: ItineraryDetailPage(
              itineraryId: itineraryId,
              title: title,
            ),
            state: state,
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.addStops,
        name: AppRouteNames.addStops,
        pageBuilder: (context, state) {
          final tripTitle = state.uri.queryParameters['tripTitle'] ?? 'Your Nashik Trip';
          return AppRouter.getPage(
            child: AddStopsPage(tripTitle: tripTitle),
            state: state,
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.customizeTrip,
        name: AppRouteNames.customizeTrip,
        pageBuilder: (context, state) => AppRouter.getPage(
          child: const CustomizeTripPage(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.savedItinerary,
        name: AppRouteNames.savedItinerary,
        pageBuilder: (context, state) {
          final extra = state.extra;
          return AppRouter.getPage(
            child: SavedItineraryPage(data: extra is SavedItineraryData ? extra : null),
            state: state,
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.discoverNashik,
        name: AppRouteNames.discoverNashik,
        pageBuilder: (context, state) => AppRouter.getPage(
          child: const DiscoverNashikPage(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.streetFood,
        name: AppRouteNames.streetFood,
        pageBuilder: (context, state) => AppRouter.getPage(
          child: const StreetFoodScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.transport,
        name: AppRouteNames.transport,
        pageBuilder: (context, state) => AppRouter.getPage(
          child: const TransportScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.hotels,
        name: AppRouteNames.hotels,
        pageBuilder: (context, state) => AppRouter.getPage(
          child: const HotelsScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.eatery,
        name: AppRouteNames.eatery,
        pageBuilder: (context, state) => AppRouter.getPage(
          child: const EateryScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.templeDarshan,
        name: AppRouteNames.templeDarshan,
        pageBuilder: (context, state) => AppRouter.getPage(
          child: const TempleDarshanPage(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.aartiTiming,
        name: AppRouteNames.aartiTiming,
        pageBuilder: (context, state) => AppRouter.getPage(
          child: const AartiTimingPage(),
          state: state,
        ),
      ),
      // Places Routes
      GoRoute(
        path: AppRoutePaths.categoryDetail,
        name: AppRouteNames.categoryDetail,
        pageBuilder: (context, state) {
          final categoryId = state.pathParameters['categoryId'] ?? '';
          return AppRouter.getPage(
            child: CategoryDetailPage(
              categoryId: categoryId,
              placeRepository: locator<PlaceRepository>(),
            ),
            state: state,
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.placeDetail,
        name: AppRouteNames.placeDetail,
        pageBuilder: (context, state) {
          final placeId = state.pathParameters['placeId'] ?? '';
          return AppRouter.getPage(
            child: PlaceDetailPage(
              placeId: placeId,
              placeRepository: locator<PlaceRepository>(),
            ),
            state: state,
          );
        },
      ),
      // Events Routes
      GoRoute(
        path: AppRoutePaths.eventDetail,
        name: AppRouteNames.eventDetail,
        pageBuilder: (context, state) {
          final eventId = state.pathParameters['eventId'] ?? '';
          final eventTitle = state.uri.queryParameters['title'] ?? 'Event';
          return AppRouter.getPage(
            child: EventDetailPage(
              eventId: eventId,
              eventTitle: eventTitle,
            ),
            state: state,
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.upcomingEvents,
        name: AppRouteNames.upcomingEvents,
        pageBuilder: (context, state) => AppRouter.getPage(
          child: const UpcomingEventsPage(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.savedEvents,
        name: AppRouteNames.savedEvents,
        pageBuilder: (context, state) => AppRouter.getPage(
          child: const SavedEventsPage(),
          state: state,
        ),
      ),
    ];
  }
}
