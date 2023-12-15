import 'package:permission_handler/permission_handler.dart';
import 'package:da/evaluation_screen.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'permission_info_screen.dart';

class WebViewScreen extends StatelessWidget {
  final String url;
  final bool showDownloadButton;
  final bool showEvaluationButton;

  const WebViewScreen({
    Key? key,
    required this.url,
    this.showDownloadButton = false,
    this.showEvaluationButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
          ),
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

  void _checkPermissions(BuildContext context) async {
    if (!await Permission.storage.isGranted) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const PermissionInfoScreen(),
      ));
    } else {
      // Leiten Sie den Benutzer zur PermissionInfoScreen weiter, um die Berechtigung zu erläutern
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const PermissionInfoScreen(),
      ));
    }
  }
}
