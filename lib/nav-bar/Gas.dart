import 'package:flutter/material.dart';
import 'package:kdgaugeview/kdgaugeview.dart';

import '../modules/humidity_slider/screen/humidity_screen.dart';

class GasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
       body: Center(
        child:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 400,
                height: 350,
                
                padding: EdgeInsets.fromLTRB(10,20,10,10),
                child: KdGaugeView(
                  minSpeed: 0,
                  maxSpeed: 10000,
                  speed: 600,
                  animate: true,
                  duration: Duration(seconds: 5),
                  alertSpeedArray: [600, 1000, 2000],
                  alertColorArray: [Colors.orange, Colors.indigo, Colors.red],
                  unitOfMeasurement: "CO PPM",
                  unitOfMeasurementTextStyle: TextStyle(fontSize: 20 , color: Colors.black, fontWeight: FontWeight.bold),

                  gaugeWidth: 30,
                  fractionDigits: 1,
                ),
              ),
            
              Container(
                width: 400,
                height: 350,
                padding: EdgeInsets.all(10),
                child: KdGaugeView(
                  minSpeed: 0,
                  maxSpeed: 10000,
                  speed: 1500,
                  animate: true,
                  duration: Duration(seconds: 5),
                  alertSpeedArray: [600, 1000, 2000],
                  alertColorArray: [Colors.orange, Colors.indigo, Colors.red],
                  unitOfMeasurement: "LPG PPM",
                  unitOfMeasurementTextStyle: TextStyle(fontSize: 20 , color: Colors.black, fontWeight: FontWeight.bold),
                  gaugeWidth: 30,
                  fractionDigits: 1,
                ),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Gas',
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
