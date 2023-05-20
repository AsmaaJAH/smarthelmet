import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/shared/constants/colors.dart';
import 'package:smarthelmet/shared/functions/CircleProgress.dart';


class TempretureScreen extends StatefulWidget {
  TempretureScreen({super.key});

  @override
  State<TempretureScreen> createState() => _TempretureScreenState();
}

class _TempretureScreenState extends State<TempretureScreen> with TickerProviderStateMixin {
  double temp = 20;
  final dataBase = FirebaseDatabase.instance.ref();
  late Animation<double> tempAnimation;
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
        print(sensorsTable);
        String? nullableString = '${sensorsTable['temp']}'.toString();
        print(nullableString);
        temp = double.tryParse(nullableString ) ?? 0.0;

       
        setState(() {
        _TempretureScreenInit(temp,0.0 );


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
    temp = double.tryParse('${sensorsTable['temp']}') ?? 0.0;

    double humdity = 100;

    _TempretureScreenInit(temp, humdity);
    super.initState();
  }

  _TempretureScreenInit(double temp, double humid) {
    progressController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 0)); //5s

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CustomPaint(
                    foregroundPainter:
                        CircleProgress(tempAnimation.value, true),
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
          ],
        ),
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