import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'itinerary_state.dart';

class ItineraryCubit extends Cubit<ItineraryState> {
  ItineraryCubit() : super(ItineraryInitial());
}
