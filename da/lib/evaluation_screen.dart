import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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

enum DisplayMode { rawData, barChart, lineChart }

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
              IconButton(
                icon: const Icon(Icons.show_chart),
                onPressed: () =>
                    setState(() => displayMode = DisplayMode.lineChart),
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
                    case DisplayMode.lineChart:
                      return MyLineChart(data: snapshot.data!);
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
    List<BarChartGroupData> barGroups = data
        .map((e) => BarChartGroupData(
              x: e.algorithmId,
              barRods: [
                BarChartRodData(
                  toY: e.pathLength.toDouble(),
                  color: getColorForAlgorithmId(e.algorithmId),
                  width: 20,
                ),
              ],
            ))
        .toList();

    return BarChart(
      BarChartData(
        barGroups: barGroups,
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

class MyLineChart extends StatelessWidget {
  final List<LabyrinthData> data;

  MyLineChart({required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<LabyrinthData, DateTime>> seriesList =
        _createSeriesList();

    return charts.TimeSeriesChart(
      seriesList,
      animate: true,
    );
  }

  List<charts.Series<LabyrinthData, DateTime>> _createSeriesList() {
    return [
      charts.Series<LabyrinthData, DateTime>(
        id: 'Labyrinth',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LabyrinthData data, _) => DateTime.parse(data.elapsedTime),
        measureFn: (LabyrinthData data, _) => data.pathLength,
        data: data,
      )
    ];
  }
}
