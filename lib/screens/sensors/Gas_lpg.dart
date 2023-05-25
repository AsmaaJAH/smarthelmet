import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/shared/constants/colors.dart';
import 'package:smarthelmet/shared/functions/CircleProgress.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GasLpgScreen extends StatefulWidget {
  GasLpgScreen({super.key});

  @override
  State<GasLpgScreen> createState() => _GasLpgScreenState();
}

class _GasLpgScreenState extends State<GasLpgScreen>
    with TickerProviderStateMixin {
  double lpg = 20;
  int c = 10;

  final dataBase = FirebaseDatabase.instance.ref();
  late Animation<double> lpgAnimation;
  late AnimationController progressController;
  late ChartSeriesController _chartSeriesController;
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

  Map<Object?, Object?> alertTable = {};
  Map<Object?, Object?> sensorsTable = {};
  void read() async {
    tables.forEach((key, value) async {
      Query dbRef = FirebaseDatabase.instance.ref().child(key);
      await dbRef.onValue.listen((event) {
        print(event.snapshot.value);
        if (key == "ALERT")
          alertTable = event.snapshot.value as Map<Object?, Object?>;
        else if (key == "sensors")
          sensorsTable = event.snapshot.value as Map<Object?, Object?>;
        lpg = double.tryParse('${sensorsTable['LPG PPM value']}') ?? 0.0;

        setState(() {
          _TempretureScreenInit(lpg);
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
    data.add(ChartData(x: c, y: lpg));
    c++;
    data.removeAt(0);
    _chartSeriesController.updateDataSource(
        addedDataIndex: data.length - 1, removedDataIndex: 0);
  }

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), updateDataSource);
    read();
    lpg = double.tryParse('${sensorsTable['LPG PPM value']}') ?? 0.0;

    _TempretureScreenInit(lpg);
    super.initState();
  }

  _TempretureScreenInit(double lpg) {
    progressController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1)); //5s

    lpgAnimation = Tween<double>(begin: 0, end: lpg).animate(progressController)
      ..addListener(() {
        setState(() {});
      });

    progressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: CustomPaint(
                foregroundPainter: CircleProgress(lpgAnimation.value, false),
                child: Container(
                  width: 160,
                  height: 160,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('PPM'),
                        Text(
                          '${lpgAnimation.value.toInt()}',
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'LPG',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
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
      ),
      appBar: AppBar(
        title: const Text(
          'Gas Detector',
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
