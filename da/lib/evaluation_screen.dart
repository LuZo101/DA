import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

class LabyrinthData {
  final int algorithmId;
  final int pathLength;
  final int cellsVisited;
  final String elapsedTime;

  LabyrinthData(
      {required this.algorithmId,
      required this.pathLength,
      required this.cellsVisited,
      required this.elapsedTime});

  factory LabyrinthData.fromJson(Map<String, dynamic> json) {
    return LabyrinthData(
      algorithmId: int.parse(json['algorithm_id'].toString()),
      pathLength: int.parse(json['path_length'].toString()),
      cellsVisited: int.parse(json['cells_visited'].toString()),
      elapsedTime: json['elapsed_time'].toString(),
    );
  }
}

Future<List<LabyrinthData>> fetchLabyrinthData() async {
  final url =
      Uri.parse('http://192.168.1.144/DA/Robin-Star-Algorythm/insertData.php');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => LabyrinthData.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load labyrinth data');
  }
}

enum DisplayMode { rawData, barChart }

class EvaluationScreen extends StatefulWidget {
  const EvaluationScreen({Key? key}) : super(key: key);

  @override
  _EvaluationScreenState createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  DisplayMode displayMode = DisplayMode.rawData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Auswertung"),
      ),
      body: Column(
        children: [
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.list),
                onPressed: () =>
                    setState(() => displayMode = DisplayMode.rawData),
              ),
              IconButton(
                icon: const Icon(Icons.bar_chart),
                onPressed: () =>
                    setState(() => displayMode = DisplayMode.barChart),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<LabyrinthData>>(
              future: fetchLabyrinthData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (displayMode) {
                    case DisplayMode.rawData:
                      return RawDataView(data: snapshot.data!);
                    case DisplayMode.barChart:
                      return MyBarChart(data: snapshot.data!);
                    default:
                      return const SizedBox.shrink();
                  }
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RawDataView extends StatelessWidget {
  final List<LabyrinthData> data;

  const RawDataView({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        var item = data[index];
        return ListTile(
          title: Text(
              'Pfadlänge: ${item.pathLength}, Besuchte Zellen: ${item.cellsVisited}, Verstrichene Zeit: ${item.elapsedTime}'),
        );
      },
    );
  }
}

class MyBarChart extends StatelessWidget {
  final List<LabyrinthData> data;
  MyBarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups = data.map((e) {
      return BarChartGroupData(
        x: e.algorithmId,
        barRods: [
          BarChartRodData(
            toY: e.pathLength
                .toDouble(), // Verwenden Sie die Pfadlänge für die Balkenhöhe
            color: getColorForAlgorithmId(e.algorithmId),
            width: 20,
            rodStackItems: [
              BarChartRodStackItem(0, e.pathLength.toDouble(),
                  getColorForAlgorithmId(e.algorithmId)),
            ],
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: e.pathLength.toDouble(),
              color: getColorForAlgorithmId(e.algorithmId).withOpacity(0.2),
            ),
          ),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();

    return BarChart(
      BarChartData(
        barGroups: barGroups,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 16.0,
                  child: Text(getAlgorithmName(value.toInt())),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.grey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                data[group.x.toInt()].elapsedTime + '\n',
                TextStyle(color: Colors.white),
              );
            },
          ),
        ),
      ),
    );
  }

  Color getColorForAlgorithmId(int algorithmId) {
    switch (algorithmId) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.red;
      case 3:
        return Colors.green;
      case 4:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

String getAlgorithmName(int algorithmId) {
  switch (algorithmId) {
    case 1:
      return "Best-First";
    case 2:
      return "Dijkstra";
    case 3:
      return "Tremaux";
    case 4:
      return "A-Star";
    default:
      return "Unbekannt";
  }
}

int convertTimeToMilliseconds(String timeString) {
  List<String> parts = timeString.split(':');
  int mins = int.parse(parts[0]);
  int secs = int.parse(parts[1]);
  int msecs = int.parse(parts[2]);
  return (mins * 60 + secs) * 1000 + msecs;
}
