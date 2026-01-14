import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nashik/android_app.dart';
import 'package:nashik/core/di/get_it.dart';
import 'package:nashik/core/router/app_router.dart';
import 'package:nashik/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:nashik/ios_app.dart';

// flutter build apk --release --split-per-abi
// flutter build appbundle --release
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Uncomment when .env file is added to assets
  // Initialize Config (loads .env file)
  // await Config.instance;

  // TODO: Uncomment when .env file is added to assets
  // Initialize Supabase with environment variables
  // await SupabaseConfig.initialize();

  // Initialize service locator (encrypted secure storage)
  await serviceLocatorInit();

  // TODO: Uncomment when Supabase is initialized
  // Initialize deep linking
  // DeepLinkService().initialize();

  // TODO: Uncomment when Supabase is initialized
  // Process any initial deep link (e.g., app opened via deep link)
  // await DeepLinkService().getInitialLink();

  // Initialize the go router
  AppRouter.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 920),
      child: MultiBlocProvider(
        providers: [
          // TODO: Uncomment when Supabase is initialized
          // BlocProvider(create: (context) => locator<AuthCubit>()),
          BlocProvider(create: (context) => ProfileCubit()),
        ],
        child: Platform.isIOS ? const IosApp() : const AndroidApp(),
      ),
    );
  }
}
