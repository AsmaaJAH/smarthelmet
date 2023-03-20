import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/modules/home-page/workers.dart';
import 'package:smarthelmet/shared/functions/shared_function.dart';
import 'package:smarthelmet/shared/network/position.dart';
import '../modules/home-page/HomePage.dart';
import 'FallDeteting.dart';
import 'Gas.dart';
import 'Humidity.dart';
import 'Tempreture.dart';
import 'Tracking.dart';
import 'UnderGroundScreen.dart';

class FetchData extends StatefulWidget {
  String? index;
  FetchData({required this.index});

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
          print("----------------------Alerts---------------");
          alertTable = event.snapshot.value as Map<Object?, Object?>;
        } else if (key == "sensors") {
          print("-------------///sensors///------------------");
          sensorsTable = event.snapshot.value as Map<Object?, Object?>;
        } else if (key == "gps") {
          for (int i = 0; i < 1000; i++) {
            gpsTable = event.snapshot.value as Map<Object?, Object?>;
            positions[i].latitude = double.parse('${gpsTable['latitude1']}');
            positions[i].longitude = double.parse('${gpsTable['longitude1']}');
            i++;

            positions[i].latitude = double.parse('${gpsTable['latitude2']}');
            positions[i].longitude = double.parse('${gpsTable['longitude2']}');
            i++;

            positions[i].latitude = double.parse('${gpsTable['latitude3']}');
            positions[i].longitude = double.parse('${gpsTable['longitude3']}');
            i++;

            positions[i].latitude = double.parse('${gpsTable['latitude4']}');
            positions[i].longitude = double.parse('${gpsTable['longitude4']}');
            i++;
          }
        }
        setState(() {});
      });
    });
  }

  Map<String, List<String>> tables = {
    "ALERT": ['HUM', 'LPG', 'CO', 'TEMP'],
    "sensors": ['CO PPM value', 'Humdity', 'LPG PPM value', 'temp'],
    "gps": [
      'latitude1',
      'longitude1',
      'latitude2',
      'longitude2',
      'latitude3',
      'longitude3',
      'latitude4',
      'longitude4',
    ],
  };

  @override
  void initState() {
    readRealTimeDatabase();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final test = dataBase.child("write now/");
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(203, 255, 255, 255),
      body: ListView(
        children: <Widget>[
          Container(
              height: size.height * .3,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.cyan,
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
                        child: Image.asset(
                          map[widget.index]!.imgpath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height * .1,
                    left: size.width * .5,
                    child: Text(
                      'Name : ${map[widget.index]!.workername}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                    top: size.height * .16,
                    left: size.width * .5,
                    child: Text(
                      'age     : ${map[widget.index]!.age}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )),
          SingleChildScrollView(
            child: Container(
                height: 300,
                child: listItem(
                    alert: alertTable,
                    context: context,
                    sensors: sensorsTable)),
          ),
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
                                color: Colors.blue,
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
                                color: Colors.blue,
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
                                color: Colors.blueAccent,
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
                    navigateTo(context,
                        Tracking(index: map[widget.index]!.workername));
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
                                color: Colors.blue,
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
              // Padding(
              //   padding: const EdgeInsets.all(18.0),
              //   child: InkWell(
              //     onTap: () {
              //       navigateTo(context, UnderGroundScreen());
              //     },
              //     child: Container(
              //       height: 150,
              //       width: MediaQuery.of(context).size.width * 0.4,
              //       decoration: BoxDecoration(
              //           color: Color.fromARGB(255, 236, 235, 235),
              //           borderRadius: BorderRadius.circular(15)),
              //       child: Column(
              //         children: [
              //           Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: SizedBox(
              //                 height: 100,
              //                 width: 100,
              //                 child: Image.asset(
              //                   'assets/images/icons8-road-map-66.png',
              //                   scale: sqrt1_2,
              //                   color: Colors.blue,
              //                 )),
              //           ),
              //           Text(
              //             'Under ground tracking',
              //             style: TextStyle(
              //                 fontSize: 14, fontWeight: FontWeight.bold),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ],
      ),
    );
  }

  Widget listItem(
      {required Map alert, required context, required Map sensors}) {
    return Container(
        height: 800,
        margin: const EdgeInsets.fromLTRB(10, 1, 10, 10),
        padding: const EdgeInsets.fromLTRB(10, 1, 10, 10),
        color: Colors.white,
        child: SingleChildScrollView(
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      alert['HUM'] == null ? "" : alert['HUM'],
                      // sensors['temp']?? "",

                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      alert['CO'] ?? "",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      alert['LPG'] ?? "",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      alert['TEMP'] == null ? "" : alert['TEMP'] + ' °C',
                      // sensors['temp']?? "",

                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      "Fall Detector: ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      alert['fall'] == null ? "" : alert['fall'],
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      "object Falling Detector: ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      alert['ultrasonic'] == null ? "" : alert['ultrasonic'],
                      // sensors['temp']?? "",

                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
              ]),
        ));
  }

  //         Text(
  //           "Received Data from Sensors",
  //           style: TextStyle(color: Colors.cyan, fontSize: 40),
  //           textAlign: TextAlign.center,
  //         ),
  //         Row(
  //           children: [
  //             Text(
  //               "CO PPM value: ",
  //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //             ),
  //             Text(
  //               sensors['CO PPM value'] ?? "",
  //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
  //             ),
  //           ],
  //         ),
  //         Row(
  //           children: [
  //             Text(
  //               "Humdity: ",
  //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //             ),
  //             Text(
  //               sensors['Humdity'] ?? "",
  //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
  //             ),
  //           ],
  //         ),
  //         Row(
  //           children: [
  //             Text(
  //               "LPG PPM value: ",
  //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //             ),
  //             Text(
  //               sensors['LPG PPM value'] ?? "",
  //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
  //             ),
  //           ],
  //         ),
  //         Row(
  //           children: [
  //             Text(
  //               "temp: ",
  //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //             ),
  //             Text(
  //               sensors['temp'] ?? "",
  //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
