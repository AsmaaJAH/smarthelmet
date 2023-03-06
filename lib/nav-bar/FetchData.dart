import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/modules/home-page/workers.dart';
import 'package:smarthelmet/pageview.dart';
import 'package:smarthelmet/shared/functions/shared_function.dart';
import 'FallDeteting.dart';
import 'Gas.dart';
import 'Humidity.dart';
import 'Tempreture.dart';
import 'Tracking.dart';
import 'UnderGroundScreen.dart';
// import 'dart:developer';
// import 'package:smarthelmet/nav-bar/NavBarScreen.dart';
// import '../shared/functions/CircleProgress.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';

class FetchData extends StatefulWidget {
  int index;
  FetchData({required this.index});

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
        // title:  Text(
        //   Workers[widget.index].workername,
        //   style: TextStyle(
        //     fontSize: 22.0,
        //     fontWeight: FontWeight.bold,
        //     letterSpacing: 2.0,
        //     color: Colors.white,
        //     fontFamily: 'Ubuntu',
        //   ),
        // ),
        // leading: IconButton(
        //     onPressed: () {
        //       navigateAndFinish(context, PageViewScreen());
        //     },
        //     icon: Icon(
        //       Icons.arrow_back,
        //       color: Colors.white,
        //     )),
        backgroundColor: Colors.grey,
        elevation: 0.0,
        // leading: Builder(builder: (context) {
        //   return IconButton(
        //     onPressed: () {
        //       Scaffold.of(context).openDrawer();
        //     },
        //     icon: const Icon(
        //       Icons.menu,
        //       color: Colors.white,
        //     ),
        //   );
        // }),
      ),
      // floatingActionButton: FloatingActionButton(
      //     backgroundColor: Colors.grey,
      //     onPressed: () {
      //       readRealTimeDatabase();
      //       test
      //           .set({"a": '5000'})
      //           .then((value) => print('done'))
      //           .catchError((onError) => print("error ${onError.toString()}"));
      //     }),
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
                          child: Image.asset(
                            Workers[widget.index].imgpath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: size.height * .1,
                      left: size.width * .5,
                      child: Text(
                        'Name : ${Workers[widget.index].workername}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      top: size.height * .16,
                      left: size.width * .5,
                      child: Text(
                        'age     : ${Workers[widget.index].age}',
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
            // CustomPaint(
            //   foregroundPainter:
            //       CircleProgress(tempAnimation.value, true),
            //   child: Container(
            //     width: 200,
            //     height: 200,
            //     child: Center(
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: <Widget>[
            //           Text('Temperature'),
            //           Text(
            //             '${tempAnimation.value.toInt()}',
            //             style: TextStyle(
            //                 fontSize: 50, fontWeight: FontWeight.bold),
            //           ),
            //           Text(
            //             '°C',
            //             style: TextStyle(
            //                 fontSize: 20, fontWeight: FontWeight.bold),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // Container(
            //     padding: const EdgeInsets.all(10.0),
            //     margin: EdgeInsets.only(bottom: 22),
            //     alignment: Alignment.center,
            //     decoration: BoxDecoration(
            //       color: Colors.cyan,
            //     ),
            //     height: 500,
            //     width: double.infinity,
            //     child: Container(
            //         height: double.infinity,
            //         child: listItem(
            //             alert: alertTable,
            //             context: context,
            //             sensors: sensorsTable))),
          ],
        ),
      ),
    );
  }

  // Widget listItem(
  //     {required Map alert, required context, required Map sensors}) {
  //   return Container(
  //     margin: const EdgeInsets.fromLTRB(10, 1, 10, 10),
  //     padding: const EdgeInsets.all(10),
  //     height: 200,
  //     color: Colors.white,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           "Emergency Alerts",
  //           style: TextStyle(color: Colors.cyan, fontSize: 44),
  //           textAlign: TextAlign.center,
  //         ),
  //         const SizedBox(
  //           height: 25,
  //         ),
  //         Row(
  //           children: [
  //             Text(
  //               "HUM: ",
  //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //             ),
  //             Text(
  //               alert['HUM'] == null ? "" : alert['HUM'],
  //               // sensors['temp']?? "",

  //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(
  //           height: 5,
  //         ),
  //         Row(
  //           children: [
  //             Text(
  //               "CO: ",
  //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //             ),
  //             Text(
  //               alert['CO'] ?? "",
  //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(
  //           height: 5,
  //         ),
  //         Row(
  //           children: [
  //             Text(
  //               "LPG: ",
  //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //             ),
  //             Text(
  //               alert['LPG'] ?? "",
  //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(
  //           height: 5,
  //         ),
  //         Row(
  //           children: [
  //             Text(
  //               "TEMP: ",
  //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //             ),
  //             Text(
  //               alert['TEMP'] == null ? "" : alert['TEMP'] + ' °C',
  //               // sensors['temp']?? "",

  //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(
  //           height: 15,
  //         ),
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
