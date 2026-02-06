import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nashik/features/auth/domain/entities/user.dart';
import 'package:nashik/features/auth/domain/use_cases/get_current_user.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required GetCurrentUser getCurrentUser})
      : _getCurrentUser = getCurrentUser,
        super(ProfileInitial());

  final GetCurrentUser _getCurrentUser;

  Future<void> loadUser() async {
    emit(ProfileLoading());
    final result = await _getCurrentUser();
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (user) => emit(ProfileLoaded(user)),
    );
  }
}
