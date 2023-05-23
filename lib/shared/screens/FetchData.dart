import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/shared/functions/navigation.dart';
import 'package:smarthelmet/shared/network/position.dart';
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
  List screens = [];

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
            gpsTable = event.snapshot.value as Map<Object?, Object?>;
            positions[0].latitude = double.parse('${gpsTable['latitude1']}');
            positions[0].longitude = double.parse('${gpsTable['longitude1']}');
        }
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
    ],
  };

  @override
  void initState() {

    readRealTimeDatabase();
    screens = [
      TempretureScreen(),
      HumidityScreen(),
      GasScreen(),
      Tracking(
        snapshot: widget.snapshot,
        index: widget.index,
      ),
      UnderGroundScreen()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      backgroundColor: Color.fromARGB(203, 255, 255, 255),
      body: ListView(
        children: <Widget>[
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
              height: size.height * .245,
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
                    top: size.height * .017,
                    left: size.width * .05,
                    child: SizedBox(
                      height: size.height * .2,
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
                    left: size.width * .42,
                    child: AutoSizeText(
                      "Name: ${widget.snapshot.data!.docs[widget.index]["firstName"]}  ${widget.snapshot.data!.docs[widget.index]["lastName"]}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      maxLines: 1,
                    ),
                  ),
                  Positioned(
                    top: size.height * .16,
                    left: size.width * .42,
                    child: Text(
                      "Age   : ${widget.snapshot.data!.docs[widget.index]["age"]}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )),),

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
                    navigateTo(
                        context,
                        Tracking( snapshot: widget.snapshot, index: widget.index ),
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
                                color: Colors.blue,
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
                Center(
                  child: Text(
                    "Emergency Alerts",
                    style: TextStyle(color: Colors.cyan, fontSize: 38),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      "HUM: ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
                    ),
                    Text(
                      alert['HUM'] == null ? "" : alert['HUM'],
                      // sensors['temp']?? "",

                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400,  color: Colors.red,),
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
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400,  color: Colors.red,),
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
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400,  color: Colors.red,),
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
                      alert['TEMP'] == null ? "" : alert['TEMP'] ,
                      // sensors['temp']?? "",

                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400 ,  color: Colors.red,),
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
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400,  color: Colors.red,),
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
                      alert['object'] == null ? "" : alert['object'],

                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400,  color: Colors.red,),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: ElevatedButton(
                    child: Text('1 click to Call Emergency'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.cyan,
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontStyle: FontStyle.normal),
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      shadowColor: Colors.lightBlue,
                    ),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                EmergencyScreen(widget.snapshot.data!.docs[widget.index]["uid"]))),
                  ),
                ),
              ]),
        ));
  }
}
