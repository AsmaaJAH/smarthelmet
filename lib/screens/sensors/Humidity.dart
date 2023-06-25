import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/shared/constants/colors.dart';
import 'package:smarthelmet/shared/functions/CircleProgress.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HumidityScreen extends StatefulWidget {
  HumidityScreen({super.key});

  @override
  State<HumidityScreen> createState() => _HumidityScreenState();
}

class _HumidityScreenState extends State<HumidityScreen>
    with TickerProviderStateMixin {
  double hum = 20;
  int min = 10;
  final dataBase = FirebaseDatabase.instance.ref();
  late Animation<double> humAnimation;
  late AnimationController progressController;
  late ChartSeriesController _chartSeriesController;
  Map<Object?, Object?> sensorsTable = {};
  List<ChartData> data = [
    ChartData(x: 0, y: 0),
    ChartData(x: 1, y: 0),
    ChartData(x: 2, y: 0),
    ChartData(x: 3, y: 0),
    ChartData(x: 4, y: 0),
    ChartData(x: 5, y: 0),
    ChartData(x: 6, y: 0),
    ChartData(x: 7, y: 0),
    ChartData(x: 8, y: 0),
    ChartData(x: 9, y: 0),
  ];
  void read() async {
    tables.forEach((key, value) async {
      Query dbRef = FirebaseDatabase.instance.ref().child(key);
      await dbRef.onValue.listen((event) {
        if (key == "sensors")
          sensorsTable = event.snapshot.value as Map<Object?, Object?>;
        String? nullableString = '${sensorsTable['Humdity']}'.toString();
        hum = double.tryParse(nullableString) ?? 0.0;
        setState(() {
          _HumidityScreenInit(hum);
        });
      });
    });
  }

  Map<String, List<String>> tables = {
    "sensors": [
      'CO PPM value',
      'Humdity',
      'LPG PPM value',
      'temp',
      'underGround'
    ],
  };

  void updateDataSource(Timer timer) {
    data.add(ChartData(x: min, y: hum));
    min++;
    data.removeAt(0);
    _chartSeriesController.updateDataSource(
        addedDataIndex: data.length - 1, removedDataIndex: 0);
  }

  @override
  void initState() {
    Timer.periodic(const Duration(minutes: 1), updateDataSource);

    read();
    hum = double.tryParse('${sensorsTable['Humdity']}') ?? 0.0;

    _HumidityScreenInit(hum);
    super.initState();
  }

  _HumidityScreenInit(double hum) {
    progressController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1)); //5s

    humAnimation = Tween<double>(begin: 0, end: hum).animate(progressController)
      ..addListener(() {
        setState(() {});
      });

    progressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CustomPaint(
                  foregroundPainter: CircleProgress(humAnimation.value, true),
                  child: Container(
                    width: 180,
                    height: 180,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Humidity'),
                          Text(
                            '${humAnimation.value.toInt()}',
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '%',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SfCartesianChart(
              primaryXAxis: NumericAxis(
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  interval: 1,
                  majorGridLines: const MajorGridLines(width: 0),
                  title: AxisTitle(text: 'Time (minutes)')),
              primaryYAxis: NumericAxis(
                  axisLine: AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                  majorGridLines: MajorGridLines(color: Colors.transparent),
                  title: AxisTitle(text: 'Humidity (g.m^3)')),
              series: <LineSeries<ChartData, num>>[
                LineSeries<ChartData, num>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController = controller;
                    },
                    dataSource: data,
                    xValueMapper: (ChartData value, _) => value.x,
                    yValueMapper: (ChartData value, _) => value.y,
                    width: 2,
                    markerSettings: MarkerSettings(isVisible: true))
              ],
            ),
          )
        ],
      ),
      appBar: AppBar(
        title: const Text(
          'Humidity',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: Colors.white,
            fontFamily: 'Ubuntu',
          ),
        ),
        backgroundColor: navBarColor,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
    );
  }
}

class ChartData {
  final int x;
  final double y;
  ChartData({required this.x, required this.y});
}
