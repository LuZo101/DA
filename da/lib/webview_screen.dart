import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'permission_info_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class WebViewScreen extends StatelessWidget {
  final String url;
  final bool showDownloadButton;

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
                  icon: Icon(Icons.arrow_back, color: Colors.white),
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
      // Fügen Sie hier Ihren Download-Code ein
    }
  }
}
