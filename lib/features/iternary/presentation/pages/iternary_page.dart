import 'package:flutter/material.dart';

class IternaryPage extends StatelessWidget {
  const IternaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IternaryPage')),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [Text('IternaryPage'), Text('IternaryPage')]),
        ),
      ),
    );
  }
}
