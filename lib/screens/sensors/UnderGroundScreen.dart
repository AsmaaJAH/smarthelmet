import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/shared/constants/colors.dart';
import 'package:smarthelmet/shared/functions/CircleProgress.dart';

class UnderGroundScreen extends StatefulWidget {
  UnderGroundScreen({super.key});

  @override
  State<UnderGroundScreen> createState() => _UnderGroundScreenState();
}

class _UnderGroundScreenState extends State<UnderGroundScreen>
    with TickerProviderStateMixin {
  double temp = 20;
  final dataBase = FirebaseDatabase.instance.ref();

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
        String? nullableString = '${sensorsTable['temp']}'.toString();
        print(nullableString);
        temp = double.tryParse(nullableString) ?? 0.0;

        setState(() {
          _TempretureScreenInit(temp, 0.0);
        });
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
      'latitude2',
      'longitude2',
      'latitude3',
      'longitude3',
      'latitude4',
      'longitude4',
    ]
  };

  @override
  void initState() {
    read();
    temp = double.tryParse('${sensorsTable['temp']}') ?? 0.0;

    double humdity = 100;

    _TempretureScreenInit(temp, humdity);
    super.initState();
  }

  _TempretureScreenInit(double temp, double humid) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Container(
        height: 500,
        width: 400,
        alignment:Alignment.center,
        margin: const EdgeInsets.fromLTRB(10,50,10,10),
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(15)),
         child: Center(
            child: SelectionArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                      Text(
                        "The Results of The UnderGround Tracking: ",
                        style:
                            TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,

                      ),
                      Text(
                        "${sensorsTable['underGround'] == null ? "" : sensorsTable['underGround']}",
                        style:
                            TextStyle(fontSize: 30, fontWeight: FontWeight.w400,),
                        
                      ),
                    ],
                  ),
              ),
            ),
       ),
      appBar: AppBar(
        title: const Text(
          'UnderGround Tracking',
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
