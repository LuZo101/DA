import 'package:http/http.dart' as http;
import 'dart:convert';

class LabyrinthData {
  final int pathLength;
  final int cellsVisited;
  final String elapsedTime; // Änderung hier

  LabyrinthData(
      {required this.pathLength,
      required this.cellsVisited,
      required this.elapsedTime});

  factory LabyrinthData.fromJson(Map<String, dynamic> json) {
    return LabyrinthData(
      pathLength: int.parse(json['path_length'].toString()),
      cellsVisited: int.parse(json['cells_visited'].toString()),
      elapsedTime: json['elapsed_time'], // Keine Konvertierung erforderlich
    );
  }
}

class LabyrinthDataService {
  Future<List<LabyrinthData>> fetchLabyrinthData() async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.144/DA/Robin-Star-Algorythm/insertData.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => LabyrinthData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load labyrinth data');
    }
  }

  // Hier können Sie weitere Methoden hinzufügen, falls benötigt
}