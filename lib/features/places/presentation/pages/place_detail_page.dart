import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../places/data/repositories/place_repository_impl.dart';
import '../../domain/entities/place.dart';
import '../../domain/repositories/place_repository.dart';
import '../../domain/use_cases/get_place_details.dart';
import '../templates/adventure_place_detail_template.dart';
import '../templates/culture_place_detail_template.dart';
import '../templates/family_place_detail_template.dart';
import '../templates/nature_place_detail_template.dart';
import '../templates/shopping_place_detail_template.dart';
import '../templates/spiritual_place_detail_template.dart';

/// Place Detail Page
/// Shows detailed information about a place
/// Uses different templates based on category
class PlaceDetailPage extends StatefulWidget {
  final String placeId;

  const PlaceDetailPage({
    super.key,
    required this.placeId,
  });

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  late final PlaceRepository _repository;
  Place? _place;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _repository = PlaceRepositoryImpl(); // TODO: Inject via DI
    _loadPlace();
  }

  Future<void> _loadPlace() async {
    setState(() => _isLoading = true);

    try {
      final place = await GetPlaceDetails(_repository).call(widget.placeId);
      setState(() {
        _place = place;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Handle error
    }
  }

  Widget _buildTemplate() {
    if (_place == null) return const SizedBox.shrink();

    switch (_place!.categoryId.toLowerCase()) {
      case 'spiritual':
        return SpiritualPlaceDetailTemplate(place: _place!);
      case 'adventure':
        return AdventurePlaceDetailTemplate(place: _place!);
      case 'culture':
        return CulturePlaceDetailTemplate(place: _place!);
      case 'nature':
        return NaturePlaceDetailTemplate(place: _place!);
      case 'family':
        return FamilyPlaceDetailTemplate(place: _place!);
      case 'shopping':
        return ShoppingPlaceDetailTemplate(place: _place!);
      default:
        return _buildDefaultTemplate();
    }
  }

  Widget _buildDefaultTemplate() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Image
          Container(
            width: double.infinity,
            height: 250.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  _place!.imageUrls.isNotEmpty
                      ? _place!.imageUrls.first
                      : 'assets/png/trambak.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _place!.name,
                  style: GoogleFonts.montserrat(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  _place!.description,
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    color: const Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool get _isNaturePlace =>
      _place != null && _place!.categoryId.toLowerCase() == 'nature';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isNaturePlace ? const Color(0xFF121212) : Colors.white,
      appBar: _isNaturePlace
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => context.pop(),
              ),
              title: Text(
                _place?.name.replaceAll(' Temple', '').replaceAll(' Jyotirlinga', '') ?? 'Place Details',
                style: GoogleFonts.montserrat(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
            ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _place == null
              ? const Center(child: Text('Place not found'))
              : _buildTemplate(),
    );
  }
}
