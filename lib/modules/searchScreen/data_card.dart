import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/shared/functions/shared_function.dart';
import '../../nav-bar/FallDeteting.dart';
import '../../nav-bar/Gas.dart';
import '../../nav-bar/Humidity.dart';
import '../../nav-bar/Tempreture.dart';
import '../../nav-bar/Tracking.dart';
import '../../nav-bar/UnderGroundScreen.dart';

class DataCard extends StatefulWidget {
  late AsyncSnapshot<dynamic> snapshot;
  late int index;

  DataCard({required this.snapshot, required this.index});

  @override
  State<DataCard> createState() => _DataCardState();
}

class _DataCardState extends State<DataCard> with TickerProviderStateMixin {
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

    _DataCardInit(temp, humdity);
    super.initState();
  }

  _DataCardInit(double temp, double humid) {
    progressController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 50)); //5s

    tempAnimation =
        Tween<double>(begin: 0, end: temp).animate(progressController)
          ..addListener(() {
            setState(() {});
          });

    progressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final test = dataBase.child("write now/");
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(203, 255, 255, 255),
      // drawer: NavBar(),
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 0.0,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                height: size.height * .3,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey,
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
                      left: size.width * .5,
                      child: Text(
                        "Name : ${widget.snapshot.data!.docs[widget.index]["firstName"]}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      top: size.height * .16,
                      left: size.width * .5,
                      child: Text(
                        "age     : ${widget.snapshot.data!.docs[widget.index]["age"]}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )),
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
                            'Temperature : ${tempAnimation.value.toInt()} °C',
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
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: InkWell(
                    onTap: () {
                      navigateTo(context, FallDetection());
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
                                height: 95,
                                width: 100,
                                child: Image.asset(
                                  'assets/images/icons8-error-100.png',
                                  color: Colors.blue,
                                )),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Fall detector',
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
                  padding: const EdgeInsets.all(18.0),
                  child: InkWell(
                    onTap: () {
                      navigateTo(context, Tracking());
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
      ),
    );
  }
}
