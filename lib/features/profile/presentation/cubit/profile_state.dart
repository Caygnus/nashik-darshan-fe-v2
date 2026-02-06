part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.user);
  final User user;

  @override
  List<Object?> get props => [user];
}

class ProfileError extends ProfileState {
  const ProfileError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
