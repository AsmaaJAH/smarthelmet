import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/shared/constants/colors.dart';
import 'package:smarthelmet/shared/functions/CircleProgress.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TempretureScreen extends StatefulWidget {
  const TempretureScreen({super.key});

  @override
  State<TempretureScreen> createState() => _TempretureScreenState();
}

class _TempretureScreenState extends State<TempretureScreen>
    with TickerProviderStateMixin {
      
  late double temp;
  int min = 10;

  final dataBase = FirebaseDatabase.instance.ref();

  late Animation<double> tempAnimation;
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
      Query dbRef = FirebaseDatabase.instance.ref().child('sensors');
      dbRef.onValue.listen((event) {
          sensorsTable = event.snapshot.value as Map<Object?, Object?>;
        String? nullableString = '${sensorsTable['temp']}'.toString();
        temp = double.tryParse(nullableString) ?? 0.0;
        setState(() {
          _TempretureScreenInit(temp);
        });
      });
  }
  Map<String, List<String>> tables = {
    "ALERT": ['HUM', 'LPG', 'CO', 'TEMP', 'fall', 'object','uid','medicalAssistance'],
    "sensors": [
      'CO PPM value',
      'Humdity',
      'LPG PPM value',
      'temp',
      'undergroundX',
      'undergroundY',
    ],
    "gps": [
      'latitude1',
      'longitude1',
    ],
  };

  void updateDataSource(Timer timer) {
    data.add(ChartData(x: min, y: temp));
    min++;
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
        vsync: this, duration: const Duration(milliseconds: 1)); //5s

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
                  child: SizedBox(
                    width: 180,
                    height: 180,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text('Temperature'),
                          Text(
                            '${tempAnimation.value.toInt()}',
                            style: const TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                          const Text(
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
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                  majorGridLines: const MajorGridLines(color: Colors.transparent),
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
                    markerSettings: const MarkerSettings(isVisible: true))
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
