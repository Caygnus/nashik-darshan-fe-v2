import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nashik/core/auth/unauthorized_notifier.dart';
import 'package:nashik/core/supabase/config.dart';
import 'package:nashik/features/auth/domain/params/signin_with_email_params.dart';
import 'package:nashik/features/auth/domain/params/signup_with_email_params.dart';
import 'package:nashik/features/auth/domain/entities/user.dart';
import 'package:nashik/features/auth/domain/params/verify_email_params.dart';
import 'package:nashik/features/auth/domain/use_cases/get_current_user.dart';
import 'package:nashik/features/auth/domain/use_cases/reset_password.dart';
import 'package:nashik/features/auth/domain/use_cases/sign_in_with_google.dart';
import 'package:nashik/features/auth/domain/use_cases/sign_out.dart';
import 'package:nashik/features/auth/domain/use_cases/signin_with_email.dart';
import 'package:nashik/features/auth/domain/use_cases/signup_with_email.dart';
import 'package:nashik/features/auth/domain/use_cases/verify_email.dart';
import 'package:nashik/features/auth/presentation/cubit/auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthChangeEvent;
// Stream payload has .event (AuthChangeEvent) and .session (Session?) from Supabase auth

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required SignupWithEmail signupWithEmail,
    required SigninWithEmail signinWithEmail,
    required GetCurrentUser getCurrentUser,
    required SignOut signOut,
    required SignInWithGoogle signInWithGoogle,
    required ResetPassword resetPassword,
    required VerifyEmail verifyEmail,
    required UnauthorizedNotifier unauthorizedNotifier,
  })  : _signupWithEmail = signupWithEmail,
        _signinWithEmail = signinWithEmail,
        _getCurrentUser = getCurrentUser,
        _signOut = signOut,
        _signInWithGoogle = signInWithGoogle,
        _resetPassword = resetPassword,
        _verifyEmail = verifyEmail,
        _unauthorizedNotifier = unauthorizedNotifier,
        super(const AuthState.initial()) {
    unauthorizedNotifier.setCallback(this.signOut);
    _initializeAuthState();
    _authSubscription = SupabaseConfig.client.auth.onAuthStateChange.listen(_onAuthStateChange);
  }

  StreamSubscription<dynamic>? _authSubscription;

  final SignupWithEmail _signupWithEmail;
  final SigninWithEmail _signinWithEmail;
  final GetCurrentUser _getCurrentUser;
  final SignOut _signOut;
  final SignInWithGoogle _signInWithGoogle;
  final ResetPassword _resetPassword;
  final VerifyEmail _verifyEmail;
  final UnauthorizedNotifier _unauthorizedNotifier;

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    _authSubscription = null;
    _unauthorizedNotifier.clearCallback();
    return super.close();
  }

  /// Handles Supabase auth state changes: session restore, sign-in, sign-out, token refresh.
  void _onAuthStateChange(dynamic data) {
    final event = data.event as AuthChangeEvent?;
    if (event == null) return;
    if (event == AuthChangeEvent.signedOut) {
      emit(const AuthState.unauthenticated());
      return;
    }
    if (event == AuthChangeEvent.initialSession ||
        event == AuthChangeEvent.signedIn ||
        event == AuthChangeEvent.tokenRefreshed) {
      if (data.session != null) {
        _loadCurrentUser();
      } else {
        emit(const AuthState.unauthenticated());
      }
    }
  }

  /// Initializes auth state from current session (app startup / session persistence).
  void _initializeAuthState() async {
    final result = await _getCurrentUser();
    result.fold(
      (_) => emit(const AuthState.unauthenticated()),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  void loadCurrentUser() {
    _loadCurrentUser();
  }

  /// Sets the authenticated user (e.g. after OAuth callback returns user).
  /// Use this when you already have the user and want to avoid an extra getCurrentUser call.
  void setAuthenticatedUser(User user) {
    emit(AuthState.authenticated(user));
  }

  Future<void> _loadCurrentUser() async {
    final result = await _getCurrentUser();
    result.fold(
      (failure) => emit(const AuthState.unauthenticated()),
      (user) => emit(AuthState.authenticated(user)),
    );
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
    emit(const AuthState.loading());
    final result = await _signInWithGoogle();
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.loading()),
    );
  }

  Future<void> signOut() async {
    final result = await _signOut();
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }

  Future<void> resetPassword(String email) async {
    emit(const AuthState.loading());
    final result = await _resetPassword(email);
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }

  Future<void> verifyEmail(String token, String email) async {
    emit(const AuthState.loading());
    final result = await _verifyEmail(VerifyEmailParams(token: token, email: email));
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }
}
