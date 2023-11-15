import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionInfoScreen extends StatelessWidget {
  const PermissionInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Berechtigung erforderlich'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Zum Herunterladen der Datei ist eine Speicherberechtigung erforderlich.',
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: () => _requestPermission(context),
              child: const Text('Berechtigung anfordern'),
            ),
          ],
        ),
      ),
    );
  }

  void _requestPermission(BuildContext context) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      Navigator.pop(context); // Zurück zum WebViewScreen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berechtigung nicht erteilt')),
      );
    }
  }
}
