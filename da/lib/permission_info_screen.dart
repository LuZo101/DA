// Importiert die notwendigen Flutter-Material- und Berechtigungspakete.
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// Definiert eine zustandslose Klasse `PermissionInfoScreen`.
class PermissionInfoScreen extends StatelessWidget {
  // Standardkonstruktor mit optionaler Key-Übergabe.
  const PermissionInfoScreen({Key? key}) : super(key: key);

  @override
  // Erstellt das visuelle Layout des Berechtigungsinformationsbildschirms.
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar mit einem Titel.
      appBar: AppBar(
        title: const Text('Berechtigung erforderlich'),
      ),
      // Zentriert eine Spalte von Widgets im Hauptteil der Seite.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text, der den Zweck der Berechtigungsanfrage erklärt.
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Zum Herunterladen der Datei ist eine Speicherberechtigung erforderlich.',
                textAlign: TextAlign.center,
              ),
            ),
            // Schaltfläche zum Anfordern der Berechtigung.
            ElevatedButton(
              onPressed: () => _requestPermission(context),
              child: const Text('Berechtigung anfordern'),
            ),
          ],
        ),
      ),
    );
  }

  // Methode zum Anfordern der Speicherberechtigung.
  void _requestPermission(BuildContext context) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      // Schließt den Bildschirm bei erteilter Berechtigung.
      Navigator.pop(context);
    } else {
      // Zeigt eine Snackbar bei verweigerter Berechtigung.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berechtigung nicht erteilt')),
      );
    }
  }
}
