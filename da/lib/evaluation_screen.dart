import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

class LabyrinthData {
  final int algorithmId;
  final int cellsVisited;
  final String elapsedTime;

  LabyrinthData({
    required this.algorithmId,
    required this.cellsVisited,
    required this.elapsedTime,
  });

  factory LabyrinthData.fromJson(Map<String, dynamic> json) {
    return LabyrinthData(
      algorithmId: int.parse(json['algorithm_id'].toString()),
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

enum DisplayMode { rawData, cellsVisitedAndTimeComparison }

class EvaluationScreen extends StatefulWidget {
  const EvaluationScreen({Key? key}) : super(key: key);

  @override
  _EvaluationScreenState createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  DisplayMode displayMode = DisplayMode.rawData;

  @override
  Widget build(BuildContext context) {
    String appBarTitle = getAppBarTitle();

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Column(
        children: [
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    displayMode = DisplayMode.rawData;
                  });
                },
                child: const Text("Raw Data"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    displayMode = DisplayMode.cellsVisitedAndTimeComparison;
                  });
                },
                child: const Text("Visited/Time"),
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
                    case DisplayMode.cellsVisitedAndTimeComparison:
                      return CellsVisitedAndTimeComparisonChart(
                          data: snapshot.data!);
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

  String getAppBarTitle() {
    switch (displayMode) {
      case DisplayMode.rawData:
        return "Raw Data View";
      case DisplayMode.cellsVisitedAndTimeComparison:
        return "Visited/Time";
      default:
        return "";
    }
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
            '${getAlgorithmName(item.algorithmId)}\n-----------------\nBesuchte Zellen: ${item.cellsVisited}\nVerstrichene Zeit: ${item.elapsedTime}\n',
          ),
        );
      },
    );
  }
}

class CellsVisitedAndTimeComparisonChart extends StatefulWidget {
  final List<LabyrinthData> data;

  CellsVisitedAndTimeComparisonChart({required this.data});

  @override
  _CellsVisitedAndTimeComparisonChartState createState() =>
      _CellsVisitedAndTimeComparisonChartState();
}

class _CellsVisitedAndTimeComparisonChartState
    extends State<CellsVisitedAndTimeComparisonChart> {
  Map<int, bool> barTooltipStates = {};

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.data.length; i++) {
      barTooltipStates[i] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups =
        widget.data.asMap().entries.map((entry) {
      int index = entry.key;
      LabyrinthData e = entry.value;

      return BarChartGroupData(
        x: e.algorithmId.toInt(),
        barRods: [
          BarChartRodData(
            toY: e.cellsVisited.toDouble(),
            color: getColorForAlgorithmId(e.algorithmId),
            width: 16,
          ),
          BarChartRodData(
            toY: convertTimeToMilliseconds(e.elapsedTime).toDouble(),
            color: Colors.orange,
            width: 16,
          ),
        ],
        showingTooltipIndicators:
            barTooltipStates[index] ?? false ? [0, 1] : [],
      );
    }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width:
            100.0 * widget.data.length, // Halbiere die Breite für jeden Balken
        child: BarChart(
          BarChartData(
            barGroups: barGroups,
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            alignment: BarChartAlignment.spaceAround,
            groupsSpace: 5, // Halbiere den Abstand zwischen den Balkengruppen
            barTouchData: BarTouchData(
              touchCallback:
                  (FlTouchEvent touchEvent, BarTouchResponse? touchResponse) {
                if (touchResponse != null && touchResponse.spot != null) {
                  setState(() {
                    int index = touchResponse.spot!.touchedBarGroupIndex;
                    barTooltipStates[index] = !barTooltipStates[index]!;
                  });
                }
              },
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.blueGrey,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  if (barTooltipStates[group.x.toInt()] == true) {
                    String descriptor = rodIndex == 0
                        ? 'Visited Cells: ${rod.toY.round()}'
                        : 'Time: ${formatMilliseconds(rod.toY.round())}';
                    return BarTooltipItem(
                      descriptor,
                      TextStyle(color: Colors.yellow),
                    );
                  }
                  return null;
                },
              ),
            ),
            titlesData: FlTitlesData(
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 4.0,
                      child: Text(getAlgorithmName(value.toInt())),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String formatMilliseconds(int milliseconds) {
    int hundredths = (milliseconds % 1000) ~/ 10;
    int seconds = (milliseconds ~/ 1000) % 60;
    int minutes = milliseconds ~/ (1000 * 60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}:${hundredths.toString().padLeft(2, '0')}';
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
        return Color.fromARGB(255, 212, 247, 16);
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
