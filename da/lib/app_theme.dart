// Importiert das Flutter-Material-Paket.
import 'package:flutter/material.dart';

// Definiert eine Funktion `appTheme`, die ein ThemeData-Objekt zurückgibt.
ThemeData appTheme() {
  return ThemeData(
    // Setzt die Helligkeit des Themas auf dunkel.
    brightness: Brightness.dark,
    // Definiert die primäre Farbe des Themas.
    primaryColor: Colors.green[800],
    // Setzt die Standard-Schriftfamilie für die App.
    fontFamily: 'Courier',
    // Definiert das Textthema für verschiedene Textstile.
    textTheme: const TextTheme(
      // Spezifiziert den Stil für mittelgroßen Text.
      bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Courier'),
    ),
  );
}
