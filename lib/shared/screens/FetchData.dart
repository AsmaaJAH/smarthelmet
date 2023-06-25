import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/shared/functions/navigation.dart';
import 'package:smarthelmet/shared/screens/Alert_info.dart';
import '../network/position.dart';
import 'Emergency Contacts/emergency.dart';
import 'worker_profile.dart';
import '../../screens/sensors/Gas.dart';
import '../../screens/sensors/Humidity.dart';
import '../../screens/sensors/Tempreture.dart';
import '../../screens/sensors/Tracking.dart';
import '../../screens/sensors/UnderGroundScreen.dart';
import 'package:auto_size_text/auto_size_text.dart';

class FetchData extends StatefulWidget {
  late AsyncSnapshot<dynamic> snapshot;
  late int index;
  FetchData({required this.snapshot, required this.index});

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> with TickerProviderStateMixin {
  final dataBase = FirebaseDatabase.instance.ref();

  late Animation<double> tempAnimation;
  late AnimationController progressController;

  Map<Object?, Object?> gpsTable = {};
  Map<Object?, Object?> alertTable = {};
  Map<Object?, Object?> sensorsTable = {};

  void readRealTimeDatabase() async {
    tables.forEach((key, value) async {
      Query dbRef = FirebaseDatabase.instance.ref().child(key);
      await dbRef.onValue.listen((event) {
        print(event.snapshot.value);
        if (key == "ALERT") {
          alertTable = event.snapshot.value as Map<Object?, Object?>;
        } else if (key == "sensors") {
          sensorsTable = event.snapshot.value as Map<Object?, Object?>;
        } else if (key == "gps") {
          gpsTable = event.snapshot.value as Map<Object?, Object?>;
          positions[0].latitude = double.parse('${gpsTable['latitude1']}');
          positions[0].longitude = double.parse('${gpsTable['longitude1']}');
        }
        setState(() {});
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
  List grid_photo = [
    'assets/images/temperature-icon-png-1.png',
    'assets/images/humidity.png',
    'assets/images/icons8-gas-mask-64.png',
    'assets/images/icons8-google-maps-old-100.png',
    'assets/images/icons8-road-map-66.png',
  ];
  @override
  void initState() {
    readRealTimeDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0.0,
      ),

      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          InkWell(
            onTap: () {
              navigateTo(
                  context,
                  WorkerProfile(
                    snapshot: widget.snapshot,
                    index: widget.index,
                  ));
            },
            child: Container(
                height: size.height * .3,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    )),
                child: Stack(
                  children: [
                    Positioned(
                      top: size.height * .02,
                      left: size.width * .05,
                      child: SizedBox(
                        height: size.height * .25,
                        width: size.width * .35,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            widget.snapshot.data!.docs[widget.index]["imgurl"],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: size.height * .1,
                      left: size.width * .45,
                      child: Container(
                        width: size.width * .5,
                        child: AutoSizeText(
                          "Name : ${widget.snapshot.data!.docs[widget.index]["firstName"]}  ${widget.snapshot.data!.docs[widget.index]["lastName"]}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      top: size.height * .16,
                      left: size.width * .45,
                      child: Text(
                        "Age   : ${widget.snapshot.data!.docs[widget.index]["age"]}",
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )),
          ),
          SizedBox(
            height: size.height * .005,
          ),
          Center(
            child: Text(
              "Emergency Alerts",
              style: TextStyle(
                color: Colors.amber,
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            height: size.height * .26,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  top: size.height * .18,
                  left: size.width * .28,
                  right:size.width * .28,
                  child: InkWell(
                    onTap: () {
                      navigateTo(
                          context,
                          EmergencyScreen(
                            widget.snapshot.data!.docs[widget.index]["uid"],
                          ));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        ' Call Emergency',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            ),
                       textAlign: TextAlign.center,),
                    ),
                  ),
                ),
                Positioned(
                    top: size.height * .01,
                    left: size.width * .05,
                    bottom: size.height * .09,
                    child: Container(
                      height: size.height,
                      width: size.width * .44,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AlertInfo(
                            data: alertTable['CO'].toString(),
                            alertname: 'CO',
                            fontsize: 16,
                          ),
                          AlertInfo(
                            data: alertTable['LPG'].toString(),
                            alertname: 'LPG',
                            fontsize: 16,
                          ),
                          AlertInfo(
                              data: alertTable['object'].toString(),
                              alertname: 'Falling object:',
                              fontsize: 11),
                        ],
                      ),
                    )),
                Positioned(
                    top: size.height * .01,
                    right: size.width * .09,
                    bottom: size.height * .09,
                    child: Container(
                      height: size.height,
                      width: size.width * .44,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AlertInfo(
                            data: alertTable['TEMP'].toString(),
                            alertname: 'TEMP',
                            fontsize: 16,
                          ),
                          AlertInfo(
                            data: alertTable['HUM'].toString(),
                            alertname: 'HUM',
                            fontsize: 16,
                          ),
                          AlertInfo(
                            data: alertTable['fall'].toString(),
                            alertname: 'Fall Detector',
                            fontsize: 14,
                          ),
                          AlertInfo(
                            data: alertTable['medicalAssistance'].toString(),
                            alertname: 'Medical Help',
                            fontsize: 13,
                          ),


                        ],
                      ),
                    )),
                
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: InkWell(
                        onTap: () {
                          navigateTo(context, TempretureScreen());
                        },
                        child: Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 236, 235, 235),
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Image.asset(
                                      'assets/images/temperature-icon-png-1.png',
                                      color: Colors.amber,
                                    )),
                              ),
                              Text(
                                'Temperature : ${sensorsTable['temp']} °C',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: InkWell(
                        onTap: () {
                          navigateTo(context, HumidityScreen());
                        },
                        child: Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 236, 235, 235),
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Image.asset(
                                      'assets/images/humidity.png',
                                      color: Colors.amber,
                                    )),
                              ),
                              Text(
                                'Humidity : ${sensorsTable['Humdity']} %',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: InkWell(
                        onTap: () {
                          navigateTo(context, GasScreen());
                        },
                        child: Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 236, 235, 235),
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Image.asset(
                                      'assets/images/icons8-gas-mask-64.png',
                                      scale: sqrt1_2,
                                      color: Colors.amber,
                                    )),
                              ),
                              Text(
                                'Gas Detection ',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: InkWell(
                        onTap: () {
                          navigateTo(
                            context,
                            Tracking(
                                snapshot: widget.snapshot, index: widget.index),
                          );
                        },
                        child: Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 236, 235, 235),
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Image.asset(
                                      'assets/images/icons8-google-maps-old-100.png',
                                      color: Colors.amber,
                                    )),
                              ),
                              Text(
                                'GPS Tracking',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: InkWell(
                        onTap: () {
                          navigateTo(context, UnderGroundScreen());
                        },
                        child: Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 236, 235, 235),
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Image.asset(
                                      'assets/images/icons8-road-map-66.png',
                                      scale: sqrt1_2,
                                      color: Colors.amber,
                                    )),
                              ),
                              Text(
                                'Under ground tracking',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
