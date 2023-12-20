// Importiert das Material Design-Paket und eine zusätzliche Klasse für die WebView-Funktionalität.
import 'package:flutter/material.dart';
import 'webview_screen.dart';

// Definiert eine zustandslose Klasse `LandingPage` für die Startseite der App.
class LandingPage extends StatelessWidget {
  // Standardkonstruktor mit optionaler Key-Übergabe.
  const LandingPage({Key? key}) : super(key: key);

  @override
  // Erstellt das visuelle Layout der Startseite.
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar mit dem Titel 'Welcome'.
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      // Zentrale Spalte mit Schaltflächen.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Drei Schaltflächen, die zu unseren Webinhalten führen.
            _buildButton(context, 'Zu den Algos',
                "http://192.168.1.144/DA/Robin-Star-Algorythm/", false, true),
            _buildButton(
                context, 'Homepage', "https://www.bulme.at/", false, false),
            _buildButton(
                context,
                'Zur Diplomarbeit',
                "https://docs.google.com/document/d/1lz6akasL-0GFXRB1J_aWF2DIi-dOwn3Wv29YsnuJc-Q/edit?usp=sharing",
                true,
                false),
          ],
        ),
      ),
    );
  }

  // Hilfsmethode zum Erstellen von Schaltflächen.
  Widget _buildButton(BuildContext context, String label, String url,
      bool showDownloadButton, bool showEvaluationButton) {
    return ElevatedButton(
      onPressed: () {
        // Navigiert zur WebView-Seite beim Klick auf die Schaltfläche.
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WebViewScreen(
              url: url,
              showDownloadButton: showDownloadButton,
              showEvaluationButton: showEvaluationButton),
        ));
      },
      child: Text(label),
    );
  }
}
