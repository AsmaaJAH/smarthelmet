import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/shared/constants/colors.dart';
import 'package:smarthelmet/shared/functions/CircleProgress.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TempretureScreen extends StatefulWidget {
  TempretureScreen({super.key});

  @override
  State<TempretureScreen> createState() => _TempretureScreenState();
}

class _TempretureScreenState extends State<TempretureScreen>
    with TickerProviderStateMixin {
  double temp = 20;
  int c = 10;
  final dataBase = FirebaseDatabase.instance.ref();
  late Animation<double> tempAnimation;
  late AnimationController progressController;
  late ChartSeriesController _chartSeriesController;

  Map<Object?, Object?> alertTable = {};
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
        if (key == "ALERT")
          alertTable = event.snapshot.value as Map<Object?, Object?>;
        else if (key == "sensors")
          sensorsTable = event.snapshot.value as Map<Object?, Object?>;
        String? nullableString = '${sensorsTable['temp']}'.toString();
        temp = double.tryParse(nullableString) ?? 0.0;
        setState(() {
          _TempretureScreenInit(temp);
        });
      });
    });
  }

  Map<String, List<String>> tables = {
    "ALERT": ['HUM', 'LPG', 'CO', 'TEMP', 'fall', 'object'],
    "sensors": [
      'CO PPM value',
      'Humdity',
      'LPG PPM value',
      'temp',
      'underGround'
    ],
    "gps": [
      'latitude1',
      'longitude1',
    ],
  };

  void updateDataSource(Timer timer) {
    data.add(ChartData(x: c, y: temp));
    c++;
    data.removeAt(0);
    _chartSeriesController.updateDataSource(
        addedDataIndex: data.length - 1, removedDataIndex: 0);
  }

  @override
  void initState() {
    Timer.periodic(const Duration(minutes: 1), updateDataSource);
    read();
    temp = double.tryParse('${sensorsTable['temp']}') ?? 0.0;
    _TempretureScreenInit(temp);
    super.initState();
  }

  _TempretureScreenInit(double temp) {
    progressController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1)); //5s

    tempAnimation =
        Tween<double>(begin: 0, end: temp).animate(progressController)
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
                  foregroundPainter: CircleProgress(tempAnimation.value, true),
                  child: Container(
                    width: 200,
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Temperature'),
                          Text(
                            '${tempAnimation.value.toInt()}',
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '°C',
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
                  title: AxisTitle(text: 'Temperature (°C)')),
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
          'Temperature',
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
