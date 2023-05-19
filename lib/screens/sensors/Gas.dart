import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kdgaugeview/kdgaugeview.dart';

class GasScreen extends StatefulWidget {
    GasScreen({super.key});

  @override
  State<GasScreen> createState() => _GasScreenState();
}

class _GasScreenState extends State<GasScreen> {
  final dataBase = FirebaseDatabase.instance.ref();

  Map<Object?, Object?> alertTable = {};

  Map<Object?, Object?> sensorsTable = {};

void readRealTimeDatabase() async {
    tables.forEach((key, value) async {
      Query dbRef = FirebaseDatabase.instance.ref().child(key);
      await dbRef.onValue.listen((event) {
        print(event.snapshot.value);
        if (key == "ALERT")
          alertTable = event.snapshot.value as Map<Object?, Object?>;
        else if (key == "sensors")
          sensorsTable = event.snapshot.value as Map<Object?, Object?>;

        //print(sensorsTable);

        setState(() {});
      });
    });
  }

  Map<String, List<String>> tables = {
    "ALERT": ['HUM', 'LPG', 'CO', 'TEMP','fall','object'],
    "sensors": ['CO PPM value', 'Humdity', 'LPG PPM value', 'temp','underGround'],
    "gps": [
      'latitude1',
      'longitude1',
      'latitude2',
      'longitude2',
      'latitude3',
      'longitude3',
      'latitude4',
      'longitude4',]
  };

  @override
  void initState() {
    readRealTimeDatabase();

    //double temp = 20;
    //temp = double.parse('${sensorsTable['temp']} '.toString() );
    //double humdity = 100;
    //humidity = sensorsTable['Humdity'] as double;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
       body: Center(
        child:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 400,
                height: 350,
                
                padding: EdgeInsets.fromLTRB(10,20,10,10),
                child: KdGaugeView(
                  minSpeed: 0,
                  maxSpeed: 10000,
                  speed: double.parse('${sensorsTable['CO PPM value']} '.toString() ),
                  animate: true,
                  duration: Duration(seconds: 5),
                  alertSpeedArray: [600, 1000, 2000],
                  alertColorArray: [Colors.orange, Colors.indigo, Colors.red],
                  unitOfMeasurement: "CO PPM",
                  unitOfMeasurementTextStyle: TextStyle(fontSize: 20 , color: Colors.black, fontWeight: FontWeight.bold),

                  gaugeWidth: 30,
                  fractionDigits: 1,
                ),
              ),
            
              Container(
                width: 400,
                height: 350,
                padding: EdgeInsets.all(10),
                child: KdGaugeView(
                  minSpeed: 0,
                  maxSpeed: 10000,
                  speed: double.parse('${sensorsTable['LPG PPM value']} '.toString() ),
                  animate: true,
                  duration: Duration(seconds: 5),
                  alertSpeedArray: [600, 1000, 2000],
                  alertColorArray: [Colors.orange, Colors.indigo, Colors.red],
                  unitOfMeasurement: "LPG PPM",
                  unitOfMeasurementTextStyle: TextStyle(fontSize: 20 , color: Colors.black, fontWeight: FontWeight.bold),
                  gaugeWidth: 30,
                  fractionDigits: 1,
                ),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Gas',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: Colors.white,
            fontFamily: 'Ubuntu',
          ),
        ),
        backgroundColor: Colors.cyan,
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
