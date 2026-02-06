import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nashik/android_app.dart';
import 'package:nashik/core/deep_link/deep_link_service.dart';
import 'package:nashik/core/di/get_it.dart';
import 'package:nashik/core/env/config.dart';
import 'package:nashik/core/router/app_router.dart';
import 'package:nashik/core/supabase/config.dart';
import 'package:nashik/features/auth/domain/use_cases/get_current_user.dart';
import 'package:nashik/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nashik/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:nashik/ios_app.dart';

// flutter build apk --release --split-per-abi
// flutter build appbundle --release
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 1. Load env first (required for Supabase and API base URL)
    developer.log('Loading .env configuration');
    await Config.instance;
    developer.log('Env loaded successfully');

    // 2. Initialize Supabase once, before any auth or runApp
    developer.log('Initializing Supabase');
    await SupabaseConfig.initialize();
    developer.log('Supabase initialized successfully');

    // 3. DI (uses Config.I.baseUrl for API client)
    await serviceLocatorInit();

    // 4. Deep linking (must be after Supabase so OAuth callback can use session)
    DeepLinkService().initialize();
    await DeepLinkService().getInitialLink();

    // 5. Router
    AppRouter.init();

    runApp(const MyApp());
  } catch (e, st) {
    developer.log('App bootstrap failed', error: e, stackTrace: st);
    runApp(_BootstrapErrorApp(message: e.toString()));
  }
}

/// Shown when Config or Supabase init fails (e.g. missing .env)
class _BootstrapErrorApp extends StatelessWidget {
  const _BootstrapErrorApp({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Startup Error',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                const Text(
                  'Ensure .env exists (copy from .env.example), add it to pubspec.yaml assets, then run: flutter clean && flutter pub get && flutter run',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 920),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => locator<AuthCubit>()),
          BlocProvider(
            create: (context) =>
                ProfileCubit(getCurrentUser: locator<GetCurrentUser>()),
          ),
        ],
        child: Platform.isIOS ? const IosApp() : const AndroidApp(),
      ),
    );
  }
}
