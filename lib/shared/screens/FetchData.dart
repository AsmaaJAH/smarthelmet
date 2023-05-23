import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/shared/functions/navigation.dart';
import 'package:smarthelmet/shared/screens/Alert_info.dart';
import '../network/position.dart';
import 'Emergency Contacts/main_screen.dart';
import 'grid_data.dart';
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
    "ALERT": ['HUM', 'LPG', 'CO', 'TEMP', 'fall', 'object'],
    "sensors": [
      'CO PPM value',
      'Humdity',
      'LPG PPM value',
      'temp',
      'underGround'
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
      // drawer: NavBar(),
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        elevation: 0.0,
      ),

      body: Column(
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
                      left: size.width * .5,
                      child: Text(
                        "age     : ${widget.snapshot.data!.docs[widget.index]["age"]}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      top: size.height * .22,
                      left: size.width * .5,
                      child: InkWell(
                        onTap: () {
                          navigateTo(
                              context,
                              EmergencyScreen(
                                index: widget.snapshot.data!.docs[widget.index]
                                    ["uid"],
                              ));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                              color: Colors.lightBlueAccent.shade700,
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            'Emergency Contacts',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          ),
          SizedBox(
            height: size.height * .005,
          ),
          Center(
            child: Text("Emergency Alerts",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent.shade200)),
          ),
          Container(
            height: size.height * .18,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                    top: size.height * .01,
                    left: size.width * .05,
                    bottom: size.height * .01,
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
                              alertname: 'obj_Falling Detector',
                              fontsize: 10),
                        ],
                      ),
                    )),
                Positioned(
                    top: size.height * .01,
                    right: size.width * .05,
                    bottom: size.height * .01,
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
                        ],
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 25 / 26,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 20),
                  itemCount: grid_photo.length,
                  itemBuilder: (BuildContext context, int index) {
                    List screens = [
                      TempretureScreen(),
                      HumidityScreen(),
                      GasScreen(),
                      Tracking(
                        snapshot: widget.snapshot,
                        index: widget.index,
                      ),
                      UnderGroundScreen()
                    ];

                    List grid_text = [
                      'Temperature :  ${sensorsTable['temp']} °C',
                      'Humidity : ${sensorsTable['Humdity']} %',
                      'Gas Detection ',
                      'GPS Tracking',
                      'Under ground tracking',
                    ];

                    return GridCard(
                        screen: screens[index],
                        imgpath: grid_photo[index],
                        text: grid_text[index]);
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
