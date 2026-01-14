import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nashik/core/di/get_it.dart';
import 'package:nashik/core/error/failures/server_failure.dart';
import 'package:nashik/core/router/route_names.dart';
import 'package:nashik/core/supabase/config.dart';
import 'package:nashik/features/auth/domain/dtos/signup_request.dart';
import 'package:nashik/features/auth/domain/repositories/auth_repository.dart';
import 'package:nashik/features/auth/presentation/cubit/auth_cubit.dart';

class OAuthCallbackPage extends StatefulWidget {
  const OAuthCallbackPage({super.key});

  static const routeName = 'OAuthCallbackPage';
  static const routePath = '/oauth-callback';

  @override
  State<OAuthCallbackPage> createState() => _OAuthCallbackPageState();
}

class _OAuthCallbackPageState extends State<OAuthCallbackPage> {
  bool _isProcessing = true;
  String? _errorMessage;
  bool _hasHandledCallback = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasHandledCallback) {
      _hasHandledCallback = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleOAuthCallback();
      });
    }
  }

  Future<void> _handleOAuthCallback() async {
    try {
      // Check if Supabase has already created a session from the OAuth redirect
      // (Supabase may auto-process the deep link when the app receives it)
      var session = SupabaseConfig.client.auth.currentSession;
      var supabaseUser = SupabaseConfig.client.auth.currentUser;

      // If session doesn't exist yet, create it from the deep link URI
      if (session == null || supabaseUser == null) {
        // Get the deep link URI from route
        final routeState = GoRouterState.of(context);
        final deepLinkParam = routeState.uri.queryParameters['deep_link'];
        final originalUri = deepLinkParam != null
            ? Uri.parse(deepLinkParam)
            : routeState.uri;

        try {
          // Create Supabase session from the deep link
          await SupabaseConfig.client.auth.getSessionFromUrl(originalUri);
        } catch (e) {
          // If getSessionFromUrl fails (e.g., flow_state_not_found),
          // check again if session was created by Supabase's auto-processing
          session = SupabaseConfig.client.auth.currentSession;
          supabaseUser = SupabaseConfig.client.auth.currentUser;

          // If still no session, rethrow the error
          if (session == null || supabaseUser == null) {
            rethrow;
          }

          // Session exists now, continue
          debugPrint('Session was created by Supabase auto-processing');
        }

        // Get the session after creating it (or if it was auto-created)
        session = SupabaseConfig.client.auth.currentSession;
        supabaseUser = SupabaseConfig.client.auth.currentUser;
      }

      // Verify we have a valid session with access token
      if (session == null || session.accessToken.isEmpty) {
        throw Exception(
          'Failed to create or retrieve session from OAuth callback',
        );
      }

      if (supabaseUser == null) {
        throw Exception('No user found after OAuth callback');
      }

      // Check if user exists in backend and signup if needed
      await _handleNewOAuthUserSignup();

      // Load current user and navigate to home
      if (mounted) {
        context.read<AuthCubit>().loadCurrentUser();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            context.goNamed(AppRouteNames.home);
          }
        });
      }
    } catch (e) {
      debugPrint('OAuth callback error: $e');
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _errorMessage = 'Failed to complete sign in: ${e.toString()}';
        });
      }
    }
  }

  Future<void> _handleNewOAuthUserSignup() async {
    try {
      final authRepository = locator<AuthRepository>();

      // Session and user are already verified in _handleOAuthCallback
      // so we can safely get them here
      final supabaseUser = SupabaseConfig.client.auth.currentUser!;
      final session = SupabaseConfig.client.auth.currentSession!;

      // Try to get user from backend
      final getUserResult = await authRepository.getCurrentUser();

      await getUserResult.fold(
        (failure) async {
          final message = failure.message.toLowerCase();
          final isNotFound =
              (failure is ServerFailure &&
                  (failure.statusCode == 404 ||
                      (failure.statusCode == 500 &&
                          message.contains('not found')))) ||
              message.contains('not found') ||
              (message.contains('user') && message.contains('not found'));

          if (isNotFound) {
            // User doesn't exist in backend, create account
            final email = supabaseUser.email;
            final name =
                supabaseUser.userMetadata?['full_name'] as String? ??
                supabaseUser.userMetadata?['name'] as String? ??
                supabaseUser.userMetadata?['display_name'] as String? ??
                email?.split('@').first ??
                'User';
            final phone = supabaseUser.phone;

            if (email == null) {
              throw Exception('Missing email for OAuth user signup');
            }

            final signupRequest = SignupRequest(
              email: email,
              name: name,
              phone: phone,
              accessToken: session.accessToken,
            );

            final signupResult = await authRepository.signup(signupRequest);

            signupResult.fold(
              (signupFailure) {
                throw Exception(
                  'Backend signup failed: ${signupFailure.message}',
                );
              },
              (_) {
                debugPrint('✅ OAuth user successfully signed up in backend');
              },
            );
          } else {
            throw Exception('Error getting current user: ${failure.message}');
          }
        },
        (_) {
          debugPrint('✅ User already exists in backend');
        },
      );
    } catch (e) {
      debugPrint('Error handling new OAuth user signup: $e');
      rethrow;
    }
  }

  void _handleRetry() {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });
    _handleOAuthCallback();
  }

  void _handleGoToHome() {
    context.goNamed(AppRouteNames.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: _isProcessing
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 24),
                    Text(
                      'Completing sign in...',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                )
              : _errorMessage != null
              ? Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Sign In Failed',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 32),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          OutlinedButton(
                            onPressed: _handleGoToHome,
                            child: const Text('Go to Home'),
                          ),
                          ElevatedButton(
                            onPressed: _handleRetry,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
