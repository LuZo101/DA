import 'package:flutter/material.dart';
import 'labyrinth_data_service.dart';

class EvaluationScreen extends StatelessWidget {
  const EvaluationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Auswertung"),
      ),
      body: FutureBuilder<List<LabyrinthData>>(
        future: LabyrinthDataService().fetchLabyrinthData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Fehler: ${snapshot.error}');
          } else if (snapshot.hasData) {
            // Daten verarbeiten und anzeigen
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var data = snapshot.data![index];
                return ListTile(
                  title: Text(
                    'Pfadlänge: ${data.pathLength}, Besuchte Zellen: ${data.cellsVisited}, Verstrichene Zeit: ${data.elapsedTime}',
                  ),
                );
              },
            );
          } else {
            return const Text('Keine Daten verfügbar.');
          }
        },
      ),
    );
  }
}
