import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  static const routeName = 'SplashScreen';
  static const routePath = '/SplashScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SplashScreen')),
      body: SafeArea(
        child: SingleChildScrollView(child: Column(children: [])),
      ),
    );
  }
}
