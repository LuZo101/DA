import 'package:flutter/material.dart';
import 'landing_page.dart';
import 'app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diploma App',
      theme: appTheme(),
      home: const LandingPage(),
    );
  }
}
