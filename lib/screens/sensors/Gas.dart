import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kdgaugeview/kdgaugeview.dart';
import 'package:smarthelmet/shared/constants/colors.dart';
import 'package:smarthelmet/shared/functions/CircleProgress.dart';

class GasScreen extends StatefulWidget {

    GasScreen({super.key});

  @override
  State<GasScreen> createState() => _GasScreenState();
}

class _GasScreenState extends State<GasScreen> with TickerProviderStateMixin {
  double co = 20;
  double lpg = 20;

  final dataBase = FirebaseDatabase.instance.ref();
  late Animation<double> coAnimation;
    late Animation<double> lpgAnimation;
  late AnimationController progressController;

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

        co = double.tryParse('${sensorsTable['CO PPM value']}'.toString())??0.0;
        lpg = double.tryParse('${sensorsTable['LPG PPM value']}'.toString())??0.0;


       
        setState(() {
        _TempretureScreenInit(co,lpg );


        });
      });
    });
  }

  Map<String, List<String>> tables = {
    "ALERT": ['HUM', 'LPG', 'CO', 'TEMP','fall','object'],
    "sensors": ['CO PPM value', 'Humdity', 'LPG PPM value', 'temp','underGround'],
    "gps": [
      'latitude1',
      'longitude1',
    ],
  };

  @override
  void initState() {
    read();
    co = double.tryParse('${sensorsTable['CO PPM value']}') ?? 0.0;
    lpg = double.tryParse('${sensorsTable['LPG PPM value']}')??0.0;

    _TempretureScreenInit(co, lpg);
    super.initState();
  }

  _TempretureScreenInit(double co, double lpg) {
    progressController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1)); //5s

    coAnimation =
        Tween<double>(begin: 0, end: co).animate(progressController)
          ..addListener(() {
            setState(() {});
          });
    lpgAnimation =
        Tween<double>(begin: 0, end: lpg).animate(progressController)
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CustomPaint(
                    foregroundPainter:
                        CircleProgress(coAnimation.value, false),
                    child: Container(
                      width: 200,
                      height: 200,
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
                    foregroundPainter:
                        CircleProgress(lpgAnimation.value, false),
                    child: Container(
                      width: 200,
                      height: 200,
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