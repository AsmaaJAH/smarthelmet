import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/shared/constants/Constants.dart';

import '../shared/functions/CircleProgress.dart';

class HumidityScreen extends StatefulWidget {
  HumidityScreen({super.key});

  @override
  State<HumidityScreen> createState() => _HumidityScreenState();
}

class _HumidityScreenState extends State<HumidityScreen> with TickerProviderStateMixin {
  double hum = 20;
  final dataBase = FirebaseDatabase.instance.ref();
  late Animation<double> humAnimation;
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
        String? nullableString = '${sensorsTable['Humdity']}'.toString();
        print(nullableString);
        hum = double.tryParse(nullableString ?? '') ?? 0.0;

       
        setState(() {
        _HumidityScreenInit(hum,0.0 );


        });
      });
    });
  }

  Map<String, List<String>> tables = {
    "ALERT": ['HUM', 'LPG', 'CO', 'TEMP'],
    "sensors": ['CO PPM value', 'Humdity', 'LPG PPM value', 'temp']
  };

  @override
  void initState() {
    read();
    hum = double.tryParse('${sensorsTable['Humdity']}' ?? '') ?? 0.0;

    double temp = 20;
    //humidity = sensorsTable['Humdity'] as double;

    _HumidityScreenInit(temp, hum);
    super.initState();
  }

  _HumidityScreenInit(double temp, double humid) {
    progressController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 5000)); //5s

    humAnimation =
        Tween<double>(begin: -50, end: hum).animate(progressController)
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
                        CircleProgress(humAnimation.value, false),
                    child: Container(
                      width: 200,
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Humidity'),
                            Text(
                              '${humAnimation.value.toInt()}',
                              style: TextStyle(
                                  fontSize: 50, fontWeight: FontWeight.bold),
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
          ],
        ),
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