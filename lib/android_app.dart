import 'package:flutter/material.dart';
import 'package:nashik/core/keys.dart';
import 'package:nashik/core/router/app_router.dart';
import 'package:nashik/core/theme/app_theme.dart';

class AndroidApp extends StatelessWidget {
  const AndroidApp({super.key});

  @override
  Widget build(final BuildContext context) {
    return MaterialApp.router(
      title: 'Nashik Darshan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      scaffoldMessengerKey: scaffoldMessengerKey,
      themeMode: ThemeMode.light,
      routerConfig: AppRouter.router,
    );
  }
}
