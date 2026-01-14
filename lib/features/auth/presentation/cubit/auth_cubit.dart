import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nashik/core/auth/google_auth_service.dart';
import 'package:nashik/core/supabase/config.dart';
import 'package:nashik/features/auth/domain/use_cases/get_current_user.dart';
import 'package:nashik/features/auth/domain/use_cases/signin_with_email.dart';
import 'package:nashik/features/auth/domain/use_cases/signup_with_email.dart';
import 'package:nashik/features/auth/presentation/cubit/auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

class AuthCubit extends Cubit<AuthState> {
  final SignupWithEmail signupWithEmail;
  final SigninWithEmail signinWithEmail;
  final GetCurrentUser getCurrentUser;

  AuthCubit({
    required this.signupWithEmail,
    required this.signinWithEmail,
    required this.getCurrentUser,
  }) : super(const AuthState.initial()) {
    _initializeAuthState();
  }

  void _initializeAuthState() {
    // TODO: Uncomment when Supabase is initialized
    // SupabaseConfig.client.auth.onAuthStateChange.listen((data) {
    //   final AuthChangeEvent event = data.event;
    //   final Session? session = data.session;

    //   if (event == AuthChangeEvent.signedIn && session != null) {
    //     try {
    //       final currentLocation = AppRouter.router.location;
    //       if (!currentLocation.contains(OAuthCallbackPage.routePath)) {
    //         _loadCurrentUser();
    //       }
    //     } catch (e) {
    //     _loadCurrentUser();
    //     }
    //   } else if (event == AuthChangeEvent.signedOut) {
    //     emit(const AuthState.unauthenticated());
    //   }
    // });

    // TODO: Uncomment when Supabase is initialized
    // final user = SupabaseConfig.client.auth.currentUser;
    // if (user != null) {
    //   _loadCurrentUser();
    // } else {
    //   emit(const AuthState.unauthenticated());
    // }
    
    // Temporary: Set unauthenticated state when Supabase is not initialized
    emit(const AuthState.unauthenticated());
  }

  Future<void> _loadCurrentUser() async {
    final result = await getCurrentUser();
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  void loadCurrentUser() {
    _loadCurrentUser();
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    emit(const AuthState.loading());

    final params = SignupWithEmailParams(
      email: email,
      password: password,
      name: name,
      phone: phone,
    );

    final result = await signupWithEmail(params);

    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) async => _loadCurrentUser(),
    );
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    emit(const AuthState.loading());

    final params = SigninWithEmailParams(email: email, password: password);

    final result = await signinWithEmail(params);

    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(const AuthState.loading());
      await GoogleAuthService().signInWithGoogle();
    } catch (e) {
      emit(AuthState.error('Failed to sign in with Google: ${e.toString()}'));
    }
  }

  Future<void> signOut() async {
    try {
      await GoogleAuthService().signOut();
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.error('Failed to sign out: ${e.toString()}'));
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      emit(const AuthState.loading());
      await SupabaseConfig.client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'com.caygnus.nashikdarshan://reset-password/',
      );
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(
        AuthState.error('Failed to send password reset email: ${e.toString()}'),
      );
    }
  }

  Future<void> verifyEmail(String token, String email) async {
    try {
      emit(const AuthState.loading());
      final response = await SupabaseConfig.client.auth.verifyOTP(
        type: OtpType.email,
        token: token,
        email: email,
      );

      if (response.session != null) {
        await _loadCurrentUser();
      } else {
        emit(const AuthState.unauthenticated());
      }
    } catch (e) {
      emit(AuthState.error('Failed to verify email: ${e.toString()}'));
    }
  }
}
