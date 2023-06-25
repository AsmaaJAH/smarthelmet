import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/shared/constants/colors.dart';

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

  @override
  void initState() {
    read();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

         body: SingleChildScrollView(
           child: Column(
                  children: [
                              CarouselSlider(
                              
                                items: [
                                  //1st Image of Slider
                                  Container(
                                    margin: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(1.0),
                                      image: DecorationImage(
                                        image: NetworkImage("https://raw.githubusercontent.com/AsmaaJAH/smarthelmet/main/assets/images/tracking_underGround/0.png"),
                                        fit: BoxFit.fill, // I use this to fill(full size) instead of cover(==crop)

                                      ),
                                    ),
                                  ),
                   
                                  //2nd Image of Slider
                                  Container(
                                    margin: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(1.0),
                                      image: DecorationImage(
                                        image: NetworkImage("https://raw.githubusercontent.com/AsmaaJAH/smarthelmet/main/assets/images/tracking_underGround/1.png"),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                   
                                  //3rd Image of Slider
                                  Container(
                                    margin: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(1.0),
                                      image: DecorationImage(
                                        image: NetworkImage("https://raw.githubusercontent.com/AsmaaJAH/smarthelmet/main/assets/images/tracking_underGround/2.png"),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                   
                                  //4th Image of Slider
                                  Container(
                                    margin: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(1.0),
                                      image: DecorationImage(
                                        image: NetworkImage("https://raw.githubusercontent.com/AsmaaJAH/smarthelmet/main/assets/images/tracking_underGround/3.png"),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                   
                                  //5th Image of Slider
                                  Container(
                                    margin: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(1.0),
                                      image: DecorationImage(
                                        image: NetworkImage("https://raw.githubusercontent.com/AsmaaJAH/smarthelmet/main/assets/images/tracking_underGround/4.png"),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      image: DecorationImage(
                                        image: NetworkImage("https://raw.githubusercontent.com/AsmaaJAH/smarthelmet/main/assets/images/tracking_underGround/5.png"),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      image: DecorationImage(
                                        image: NetworkImage("https://raw.githubusercontent.com/AsmaaJAH/smarthelmet/main/assets/images/tracking_underGround/6.png"),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      image: DecorationImage(
                                        image: NetworkImage("https://raw.githubusercontent.com/AsmaaJAH/smarthelmet/main/assets/images/tracking_underGround/7.png"),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ],
                   
                                //Slider Container properties
                                options: CarouselOptions(
                                  height: 300,
                                  enlargeCenterPage: true,
                                  autoPlay: true,
                                  aspectRatio:  16/9,
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enableInfiniteScroll: true,
                                  autoPlayAnimationDuration: Duration(milliseconds: 500),
                                  viewportFraction: 0.8,
                                ),
                              ),
                            
                          
               Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                decoration: BoxDecoration(
                    color: Colors.amber, borderRadius: BorderRadius.circular(15)),
                child: Center(
                  child: SelectionArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "The Results of The UnderGround Tracking: ",
                          style:
                              TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "${sensorsTable['underGround'] == null ? "" : sensorsTable['underGround']}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                        ),
                 ],
               ),
         ),
    );
  }
}
