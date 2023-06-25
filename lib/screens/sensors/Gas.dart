import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/shared/constants/colors.dart';
import 'package:smarthelmet/shared/functions/CircleProgress.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GasScreen extends StatefulWidget {
  GasScreen({super.key});

  @override
  State<GasScreen> createState() => _GasScreenState();
}

class _GasScreenState extends State<GasScreen> with TickerProviderStateMixin {
  double co = 20;
  double lpg = 20;
  int min = 10;

  final dataBase = FirebaseDatabase.instance.ref();

  late Animation<double> coAnimation;
  late Animation<double> lpgAnimation;
  late AnimationController progressController;
  late ChartSeriesController _chartSeriesController1;
  late ChartSeriesController _chartSeriesController2;

  Map<Object?, Object?> sensorsTable = {};

  void read() async {
    Query dbRef = FirebaseDatabase.instance.ref().child("sensors");
    await dbRef.onValue.listen((event) {
      sensorsTable = event.snapshot.value as Map<Object?, Object?>;

      co = double.tryParse('${sensorsTable['CO PPM value']}'.toString()) ?? 0.0;
      lpg =
          double.tryParse('${sensorsTable['LPG PPM value']}'.toString()) ?? 0.0;

      setState(() {
        _GasScreenInit(co, lpg);
      });
    });
  }

  List<ChartData> Codata = [
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

  List<ChartData> Lpgdata = [
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

  void updateDataSource(Timer timer) {
    Codata.add(ChartData(x: min, y: co));
    Lpgdata.add(ChartData(x: min, y: lpg));

    min++;
    Codata.removeAt(0);
    Lpgdata.removeAt(0);

    _chartSeriesController1.updateDataSource(
        addedDataIndex: Codata.length - 1, removedDataIndex: 0);
    _chartSeriesController2.updateDataSource(
        addedDataIndex: Lpgdata.length - 1, removedDataIndex: 0);
  }

  @override
  void initState() {
    Timer.periodic(const Duration(minutes: 1), updateDataSource);

    read();
    co = double.tryParse('${sensorsTable['CO PPM value']}') ?? 0.0;
    lpg = double.tryParse('${sensorsTable['LPG PPM value']}') ?? 0.0;

    _GasScreenInit(co, lpg);
    super.initState();
  }

  _GasScreenInit(double co, double lpg) {
    progressController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 0)); //5s

    coAnimation = Tween<double>(begin: 0, end: co).animate(progressController)
      ..addListener(() {
        setState(() {});
      });
    lpgAnimation = Tween<double>(begin: 0, end: lpg).animate(progressController)
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CustomPaint(
                  foregroundPainter: CircleProgress(coAnimation.value, false),
                  child: Container(
                    width: 160,
                    height: 160,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('PPM'),
                          Text(
                            '${coAnimation.value.toInt()}',
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'CO',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                CustomPaint(
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
                                fontSize: 50, fontWeight: FontWeight.bold),
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
                  title: AxisTitle(text: 'GAS (ppm)')),
              series: <SplineSeries<ChartData, num>>[
                SplineSeries<ChartData, num>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController1 = controller;
                    },
                    dataSource: Codata,
                    xValueMapper: (ChartData value, _) => value.x,
                    yValueMapper: (ChartData value, _) => value.y,
                    width: 2,
                    markerSettings: MarkerSettings(isVisible: true)),
                SplineSeries<ChartData, num>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController2 = controller;
                    },
                    dataSource: Lpgdata,
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
