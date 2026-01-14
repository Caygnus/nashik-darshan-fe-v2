import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nashik/core/router/app_router.dart';

class IosApp extends StatelessWidget {
  const IosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      title: 'Nashik Darshan',
      theme: const CupertinoThemeData(
        applyThemeToAll: true,
        primaryColor: Colors.purple,
      ),
      routerConfig: AppRouter.router,
    );
  }
}
