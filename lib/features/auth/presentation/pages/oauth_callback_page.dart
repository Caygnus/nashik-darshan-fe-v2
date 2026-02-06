import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nashik/core/router/route_names.dart';
import 'package:nashik/features/auth/domain/use_cases/complete_oauth_callback.dart';
import 'package:nashik/features/auth/presentation/cubit/auth_cubit.dart';

class OAuthCallbackPage extends StatefulWidget {
  const OAuthCallbackPage({
    super.key,
    required this.completeOAuthCallback,
  });

  static const routeName = 'OAuthCallbackPage';
  static const routePath = '/oauth-callback';

  final CompleteOAuthCallback completeOAuthCallback;

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
    final routeState = GoRouterState.of(context);
    final deepLinkParam = routeState.uri.queryParameters['deep_link'];
    final uri = deepLinkParam != null
        ? Uri.tryParse(deepLinkParam) ?? routeState.uri
        : routeState.uri;

    final result = await widget.completeOAuthCallback(uri);

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _isProcessing = false;
          _errorMessage = 'Failed to complete sign in: ${failure.message}';
        });
      },
      (_) {
        context.read<AuthCubit>().loadCurrentUser();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            context.goNamed(AppRouteNames.home);
          }
        });
      },
    );
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
