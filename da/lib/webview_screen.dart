// Importiert notwendige Pakete für Berechtigungen, Webansichten und Material Design.
import 'package:permission_handler/permission_handler.dart';
import 'package:da/evaluation_screen.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'permission_info_screen.dart';

// Definiert die Klasse `WebViewScreen`, die einen Zustand-losen Bildschirm für Webinhalte darstellt.
class WebViewScreen extends StatelessWidget {
  // Variablen für URL, Download- und Bewertungsbutton.
  final String url;
  final bool showDownloadButton;
  final bool showEvaluationButton;

  // Konstruktor, der die notwendigen Parameter erhält.
  const WebViewScreen({
    Key? key,
    required this.url,
    this.showDownloadButton = false,
    this.showEvaluationButton = false,
  }) : super(key: key);

  @override
  // Erstellt das visuelle Layout des WebViewScreen.
  Widget build(BuildContext context) {
    return Scaffold(
      // Stapelt Widgets, um eine Webansicht und optionale Schaltflächen anzuzeigen.
      body: Stack(
        children: <Widget>[
          // Webansicht, die die URL lädt.
          WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
          ),
          // Schaltfläche zum Zurückgehen.
          Positioned(
            top: 40.0,
            left: 10.0,
            child: SafeArea(
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
          // Bedingte Anzeige des Download-Buttons.
          if (showDownloadButton)
            Positioned(
              top: 40.0,
              right: 10.0,
              child: SafeArea(
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: IconButton(
                    icon: const Icon(Icons.download, color: Colors.white),
                    onPressed: () => _checkPermissions(context),
                  ),
                ),
              ),
            ),
          // Bedingte Anzeige des Bewertungs-Buttons.
          if (showEvaluationButton)
            Positioned(
              top: 40.0,
              right: 60.0,
              child: SafeArea(
                child: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: IconButton(
                    icon: const Icon(Icons.assessment, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const EvaluationScreen(),
                      ));
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Überprüft die Speicherberechtigungen und leitet ggf. zur Berechtigungsinfo-Seite weiter.
  void _checkPermissions(BuildContext context) async {
    if (!await Permission.storage.isGranted) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const PermissionInfoScreen(),
      ));
    } else {
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const PermissionInfoScreen(),
      ));
    }
  }
}
