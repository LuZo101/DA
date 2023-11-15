import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.green[800],
    fontFamily: 'Courier',
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Courier'),
    ),
  );
}
