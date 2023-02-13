import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:smarthelmet/nav-bar/NavBarScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

import '../shared/functions/CircleProgress.dart';
// import 'package:http/http.dart' as http;

class FetchData extends StatefulWidget {
  FetchData({super.key});

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> with TickerProviderStateMixin {
  final dataBase = FirebaseDatabase.instance.ref();
  late Animation<double> tempAnimation;
  late AnimationController progressController;

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
    "ALERT": ['HUM', 'LPG', 'CO', 'TEMP'],
    "sensors": ['CO PPM value', 'Humdity', 'LPG PPM value', 'temp']
  };

  @override
  void initState() {
    readRealTimeDatabase();

    double temp = 20;
    //temp = sensorsTable['temp'] as double;
    double humdity = 100;
    //humidity = sensorsTable['Humdity'] as double;

    _FetchDataInit(temp, humdity);
    super.initState();
  }

  _FetchDataInit(double temp, double humid) {
    progressController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 5000)); //5s

    tempAnimation =
        Tween<double>(begin: -50, end: temp).animate(progressController)
          ..addListener(() {
            setState(() {});
          });

    progressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final test = dataBase.child("write now/");
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: const Text(
          'Worker',
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
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
          foregroundColor: Colors.cyan,
          onPressed: () {
            readRealTimeDatabase();
            test
                .set({"a": '5000'})
                .then((value) => print('done'))
                .catchError((onError) => print("error ${onError.toString()}"));
          }),
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
                  Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(bottom: 22),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                      ),
                      height: 500,
                      width: double.infinity,
                      child: Container(
                          height: double.infinity,
                          child: listItem(
                              alert: alertTable,
                              context: context,
                              sensors: sensorsTable))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listItem(
      {required Map alert, required context, required Map sensors}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10,1,10,10),
      padding: const EdgeInsets.all(10),
      height: 200,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Emergency Alerts",
            style: TextStyle(color: Colors.cyan, fontSize: 44),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            children: [
              Text(
                "HUM: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                alert['HUM'] == null ? "" : alert['HUM'],
                // sensors['temp']?? "",

                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                "CO: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                alert['CO'] ?? "",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                "LPG: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                alert['LPG'] ?? "",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                "TEMP: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                alert['TEMP'] == null ? "" : alert['TEMP'] + ' °C',
                // sensors['temp']?? "",

                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            "Received Data from Sensors",
            style: TextStyle(color: Colors.cyan, fontSize: 40),
            textAlign: TextAlign.center,
          ),
          Row(
            children: [
              Text(
                "CO PPM value: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                sensors['CO PPM value'] ?? "",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "Humdity: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                sensors['Humdity'] ?? "",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "LPG PPM value: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                sensors['LPG PPM value'] ?? "",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "temp: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                sensors['temp'] ?? "",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
    // "ALERT": ['HUM', 'LPG', 'CO', 'TEMP'],
    // "sensors": ['CO PPM value', 'Humdity', 'LPG PPM value', 'temp']