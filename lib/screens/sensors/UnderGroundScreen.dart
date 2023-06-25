import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/shared/constants/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class UnderGroundScreen extends StatefulWidget {
  UnderGroundScreen({super.key});

  @override
  State<UnderGroundScreen> createState() => _UnderGroundScreenState();
}

class _UnderGroundScreenState extends State<UnderGroundScreen>
    with TickerProviderStateMixin {
  late ChartSeriesController _chartSeriesController;
  final dataBase = FirebaseDatabase.instance.ref();
  late double undergroundX ;
  late double undergroundY ;
  Map<Object?, Object?> sensorsTable = {};
  List<ChartData> data = <ChartData>[
    ChartData(x: 0, y: 0),
  ];
  void read() async {
    Query dbRef = FirebaseDatabase.instance.ref().child('sensors');
    await dbRef.onValue.listen((event) {
      sensorsTable = event.snapshot.value as Map<Object?, Object?>;
      undergroundX =
          double.tryParse('${sensorsTable['undergroundX']}'.toString()) ?? 0.0;
      undergroundY =
          double.tryParse('${sensorsTable['undergroundY']}'.toString()) ?? 0.0;
    });
  }

  void updateDataSource(Timer timer) {
    data.add(ChartData(x: undergroundX, y: undergroundY));
    _chartSeriesController.updateDataSource(addedDataIndex: data.length - 1);
  }

  @override
  void initState() {
    read();
    Timer.periodic(const Duration(milliseconds: 1000), updateDataSource);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: SfCartesianChart(
                  isTransposed: true,
                  plotAreaBorderWidth: 0,
                  primaryXAxis: NumericAxis(
                    title: AxisTitle(text: 'X(s)'),
                    majorGridLines:
                        const MajorGridLines(color: Colors.transparent),
                  ),
                  primaryYAxis: NumericAxis(title: AxisTitle(text: 'Y(s)')),
                  series: <LineSeries<ChartData, num>>[
                LineSeries<ChartData, num>(
                  onRendererCreated: (ChartSeriesController controller) {
                    _chartSeriesController = controller;
                  },
                  dataSource: data,
                  animationDuration: 0,
                  xValueMapper: (ChartData moves, _) => moves.x,
                  yValueMapper: (ChartData moves, _) => moves.y,
                  width: 2,
                ),
              ])),
        ],
      ),
      appBar: AppBar(
        title: const Text(
          'UnderGround Tracking',
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
      ),
    );
  }
}

class ChartData {
  final double x;
  final double y;
  ChartData({required this.x, required this.y});
}
