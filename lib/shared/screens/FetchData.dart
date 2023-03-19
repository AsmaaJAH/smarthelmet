import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/shared/functions/navigation.dart';
import 'grid_data.dart';
import 'worker_profile.dart';
import '../../screens/sensors/FallDeteting.dart';
import '../../screens/sensors/Gas.dart';
import '../../screens/sensors/Humidity.dart';
import '../../screens/sensors/Tempreture.dart';
import '../../screens/sensors/Tracking.dart';
import '../../screens/sensors/UnderGroundScreen.dart';

class FetchData extends StatefulWidget {
  late AsyncSnapshot<dynamic> snapshot;
  late int index;
  FetchData({required this.snapshot, required this.index});

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> with TickerProviderStateMixin {
  List grid_photo = [
    'assets/images/temperature-icon-png-1.png',
    'assets/images/humidity.png',
    'assets/images/icons8-gas-mask-64.png',
    'assets/images/icons8-error-100.png',
    'assets/images/icons8-google-maps-old-100.png',
    'assets/images/icons8-road-map-66.png',
  ];

  List screens = [
    TempretureScreen(),
    HumidityScreen(),
    GasScreen(),
    FallDetection(),
    Tracking(),
    UnderGroundScreen()
  ];

  late List grid_text = [
    'Temperature : ${sensorsTable['temp']} °C',
    'Humidity : ${sensorsTable['Humdity']} %',
    'Gas Detection ',
    'Fall detector',
    'GPS Tracking',
    'Under ground tracking',
  ];
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(154, 165, 163, 163),
      // drawer: NavBar(),
      appBar: AppBar(
        backgroundColor: Colors.grey,
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
                        "Name : ${widget.snapshot.data!.docs[widget.index]["firstName"]}  ${widget.snapshot.data!.docs[widget.index]["lastName"]}",
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
