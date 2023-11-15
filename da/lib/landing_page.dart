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
                context, 'Zu den Algos', "http://192.168.1.85:80", Colors.red),
            _buildButton(
                context, 'Homepage', "https://www.bulme.at/", Colors.blue),
            _buildButton(
                context,
                'Zur Diplomarbeit',
                "https://docs.google.com/document/d/1lz6akasL-0GFXRB1J_aWF2DIi-dOwn3Wv29YsnuJc-Q/edit?usp=sharing",
                Colors.orange),
            _buildButton(context, 'Zum Server', "https://192.168.1.200:8006",
                Colors.purple), // URL für Ihren Server einfügen
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String label, String url, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: color),
      onPressed: () => _navigateTo(context, url),
      child: Text(label),
    );
  }

  void _navigateTo(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebViewScreen(url: url)),
    );
  }
}
