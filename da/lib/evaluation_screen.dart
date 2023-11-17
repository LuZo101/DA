import 'package:flutter/material.dart';

class EvaluationScreen extends StatelessWidget {
  const EvaluationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Auswertung"),
      ),
      body: const Center(
        child: Text("Inhalt der Auswertungsseite"),
      ),
    );
  }
}
