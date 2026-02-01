import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nashik/core/auth/google_auth_service.dart';
import 'package:nashik/core/auth/unauthorized_notifier.dart';
import 'package:nashik/core/storage/secure_token_storage.dart';
import 'package:nashik/core/supabase/config.dart';
import 'package:nashik/features/auth/domain/use_cases/get_current_user.dart';
import 'package:nashik/features/auth/domain/use_cases/signin_with_email.dart';
import 'package:nashik/features/auth/domain/use_cases/signup_with_email.dart';
import 'package:nashik/features/auth/presentation/cubit/auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required SignupWithEmail signupWithEmail,
    required SigninWithEmail signinWithEmail,
    required GetCurrentUser getCurrentUser,
    required SecureTokenStorage tokenStorage,
    required UnauthorizedNotifier unauthorizedNotifier,
  })  : _signupWithEmail = signupWithEmail,
        _signinWithEmail = signinWithEmail,
        _getCurrentUser = getCurrentUser,
        _tokenStorage = tokenStorage,
        super(const AuthState.initial()) {
    unauthorizedNotifier.setCallback(signOut);
    _initializeAuthState();
  }

  final SignupWithEmail _signupWithEmail;
  final SigninWithEmail _signinWithEmail;
  final GetCurrentUser _getCurrentUser;
  final SecureTokenStorage _tokenStorage;

  void _initializeAuthState() async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      await _loadCurrentUser();
      return;
    }
    emit(const AuthState.unauthenticated());
  }

  Future<void> _loadCurrentUser() async {
    final result = await _getCurrentUser();
    result.fold(
      (failure) => emit(const AuthState.unauthenticated()),
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

    final result = await _signupWithEmail(params);

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

    final result = await _signinWithEmail(params);

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
      await _tokenStorage.deleteAccessToken();
      await GoogleAuthService().signOut();
      emit(const AuthState.unauthenticated());
    } catch (e) {
      await _tokenStorage.deleteAccessToken();
      emit(const AuthState.unauthenticated());
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
