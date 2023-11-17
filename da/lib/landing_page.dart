import 'package:flutter/material.dart';
import 'webview_screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landing Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildButton(
                context, 'Zu den Algos', "http://192.168.1.85:80", false, true),
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

  Widget _buildButton(BuildContext context, String label, String url,
      bool showDownloadButton, bool showEvaluationButton) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WebViewScreen(
            url: url,
            showDownloadButton: showDownloadButton,
            showEvaluationButton: showEvaluationButton,
          ),
        ));
      },
      child: Text(label),
    );
  }
}
