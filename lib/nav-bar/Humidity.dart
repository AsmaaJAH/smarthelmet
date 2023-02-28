import 'package:flutter/material.dart';
import 'package:kdgaugeview/kdgaugeview.dart';


class HumidityScreen extends StatefulWidget {
  
  @override
  State<HumidityScreen> createState() => _HumidityScreenState();
}

class _HumidityScreenState extends State<HumidityScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Humidity'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 400,
              height: 400,
              padding: EdgeInsets.all(10),
              child: KdGaugeView(
                minSpeed: 0,
                maxSpeed: 100,
                speed: 100,
                animate: true,
                duration: Duration(seconds: 5),
                alertSpeedArray: [40, 80, 90],
                alertColorArray: [Colors.orange, Colors.indigo, Colors.red],
                unitOfMeasurement: "Humidity%",
                gaugeWidth: 20,
                fractionDigits: 1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
