import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class WebViewScreen extends StatelessWidget {
  final String url;
  final bool showDownloadButton;
  final double scale = 0.9;

  const WebViewScreen({
    Key? key,
    required this.url,
    this.showDownloadButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Transform.scale(
            scale: scale,
            child: WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ),
          // Weitere UI-Elemente hier
          if (showDownloadButton)
            Positioned(
              top: 40.0,
              right: 60.0,
              child: SafeArea(
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: IconButton(
                    icon: const Icon(Icons.download, color: Colors.white),
                    onPressed: () async {
                      await _downloadFile(context, url);
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _downloadFile(BuildContext context, String url) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final externalDir = await getExternalStorageDirectory();
      await FlutterDownloader.enqueue(
        url: url,
        savedDir: externalDir!.path,
        showNotification: true,
        openFileFromNotification: true,
      );
    } else {
      // Prüfen Sie, ob das Widget noch gemountet ist, bevor Sie den BuildContext verwenden
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Berechtigung zum Speichern erforderlich')),
      );
    }
  }
}

class EvaluationScreen extends StatelessWidget {
  const EvaluationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Auswertung der Algos"),
      ),
      body: const Center(
        child: Text("Inhalt der Auswertungsseite"),
      ),
    );
  }
}
