import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nashik/core/router/route_names.dart';
import 'package:nashik/features/category/domain/entities/category_entity.dart';
import 'package:nashik/features/category/domain/repositories/category_repository.dart';
import 'package:nashik/features/category/domain/usecases/get_categories.dart';
import 'package:nashik/features/places/domain/repositories/place_repository.dart';
import 'package:nashik/features/places/presentation/widgets/event_card.dart';
import '../widgets/spiritual_circuit_card.dart';

/// Returns a [TextStyle] with Roboto as the font family (safe fallback when
/// custom fonts like Poppins/Montserrat are not available).
TextStyle _getFallbackTextStyle({
  required double fontSize,
  FontWeight? fontWeight,
  Color? color,
  double? height,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight ?? FontWeight.normal,
    color: color,
    height: height,
    fontFamily: 'Roboto',
  );
}

/// Category Page
/// Main page showing all categories from API (API_BASE_URL/categories).
/// Only [status == 'published'] categories are shown.
class CategoryPage extends StatefulWidget {
  const CategoryPage({
    super.key,
    required this.getCategories,
    required this.placeRepository,
  });

  final GetCategories getCategories;
  final PlaceRepository placeRepository;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<CategoryEntity> _categories = [];
  bool _isLoading = true;
  final Set<String> _favoriteCategories = {};

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);

    final result = await widget.getCategories(
      const GetCategoriesParams(status: 'published'),
    );

    if (!mounted) return;
    result.fold(
      (failure) {
        setState(() {
          _categories = [];
          _isLoading = false;
        });
      },
      (CategoryListResult data) {
        setState(() {
          _categories = data.items
              .where((e) => e.status == 'published')
              .toList();
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          PreferredSize(
            preferredSize: Size.fromHeight(56.h),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                title: Text(
                  'Categories',
                  style: _getFallbackTextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                    height: 28 / 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                centerTitle: true,
              ),
            ),
          ),
          Expanded(
            child: Builder(
        builder: (context) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (_categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category_outlined, size: 64.sp, color: Colors.grey),
                  SizedBox(height: 16.h),
                  Text(
                    'No categories found',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ElevatedButton(
                    onPressed: _loadCategories,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 14.h),
                // Event Card Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Builder(
                    builder: (context) {
                      try {
                        return EventCard(
                          onBookNow: () {},
                        );
                      } catch (e, _) {
                        return Container(
                          width: 352.w,
                          height: 135.h,
                          color: Colors.grey[200],
                          child: Center(
                            child: Text('Event Card Error', style: TextStyle(fontSize: 12.sp)),
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 32.h),
                // Categories Grid and Spiritual Circuit Card in same padding
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Builder(
                        builder: (context) {
                          try {
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero, // Remove any default padding
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 12.h,
                                childAspectRatio: 168 / 233, // 168x233 aspect ratio
                              ),
                              itemCount: _categories.length,
                              itemBuilder: (context, index) {
                                try {
                                  final category = _categories[index];
                                  return _buildCategoryCard(category);
                                } catch (e, _) {
                                  return Container(
                                    width: 168.w,
                                    height: 233.h,
                                    color: Colors.red[100],
                                    child: Center(
                                      child: Text('Error', style: TextStyle(fontSize: 10.sp)),
                                    ),
                                  );
                                }
                              },
                            );
                          } catch (e, _) {
                            return Container(
                              height: 200.h,
                              color: Colors.orange[100],
                              child: Center(
                                child: Text('Grid Error: $e', style: TextStyle(fontSize: 12.sp)),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 12.h), // Minimal spacing between grid and card
                      // Spiritual Circuit Card - appears directly below category cards
                      SpiritualCircuitCard(
                        onBookTour: () {
                          // TODO: Navigate to tour booking page
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 85.h), // Bottom padding to prevent overlap with bottom nav bar
              ],
            ),
          );
        },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(CategoryEntity category) {
    try {
      final isFavorite = _favoriteCategories.contains(category.id);
      final imageUrl = category.imageUrl;
      final subtitle = category.subtitle ?? 'Discover the spiritual side of nashik';

      return InkWell(
        onTap: () {
          context.pushNamed(
            AppRouteNames.categoryDetail,
            pathParameters: {'categoryId': category.id},
          );
        },
        borderRadius: BorderRadius.circular(11.r),
        child: Container(
          width: 168.w,
          height: 233.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11.r),
            color: const Color(0xFFF3F4F6),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11.r),
            child: Stack(
              children: [
                // Background image (dynamic from API image_url)
                if (imageUrl != null && imageUrl.isNotEmpty)
                  Image.network(
                    imageUrl,
                    width: 168.w,
                    height: 233.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                  )
                else
                  _buildPlaceholderImage(),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11.r),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.0),
                        Colors.black.withValues(alpha: 0.5),
                      ],
                    ),
                  ),
                ),
                // Favorite icon (top right)
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (isFavorite) {
                          _favoriteCategories.remove(category.id);
                        } else {
                          _favoriteCategories.add(category.id);
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(9999.r),
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
                // Bottom content: icon (from API "icon" e.g. "category"), name, subtitle
                Positioned(
                  bottom: 12.h,
                  left: 12.w,
                  right: 12.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 31.w,
                        height: 31.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFBAC9FF),
                          borderRadius: BorderRadius.circular(9999.r),
                          border: Border.all(
                            color: const Color(0xFFE5E7EB),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            category.icon == 'category'
                                ? Icons.category
                                : Icons.category_outlined,
                            color: Colors.white,
                            size: 16.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        category.name,
                        style: _getFallbackTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: _getFallbackTextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e, _) {
      return Container(
        width: 168.w,
        height: 233.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11.r),
          color: const Color(0xFFF3F4F6),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 32.sp, color: Colors.grey),
              SizedBox(height: 8.h),
              Text(
                'Error',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 168.w,
      height: 233.h,
      color: const Color(0xFFF3F4F6),
      child: Icon(
        Icons.image_not_supported,
        color: Colors.grey,
        size: 40.sp,
      ),
    );
  }
}
