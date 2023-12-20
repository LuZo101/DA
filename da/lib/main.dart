// Importiert das Flutter-Material-Paket sowie die LandingPage und AppTheme-Klassen.
import 'package:flutter/material.dart';
import 'landing_page.dart';
import 'app_theme.dart';

// Hauptfunktion, die die MyApp-Klasse ausführt.
void main() {
  runApp(const MyApp());
}

// Definiert die Klasse `MyApp`, die von StatelessWidget erbt.
class MyApp extends StatelessWidget {
  // Standardkonstruktor mit optionaler Key-Übergabe.
  const MyApp({Key? key}) : super(key: key);

  @override
  // Erstellt das Grundgerüst der App mit einem MaterialApp-Widget.
  Widget build(BuildContext context) {
    return MaterialApp(
      // Setzt den Titel der App.
      title: 'Diploma App',
      // Definiert das Design der App.
      theme: appTheme(),
      // Definiert die Startseite der App.
      home: const LandingPage(),
    );
  }
}
