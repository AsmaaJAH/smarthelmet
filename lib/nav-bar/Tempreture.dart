
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/shared/constants/Constants.dart';

import '../shared/functions/CircleProgress.dart';

class TempretureScreen extends StatefulWidget {

  @override
  State<TempretureScreen> createState() => _TempretureScreenState();
}

class _TempretureScreenState extends State<TempretureScreen> with TickerProviderStateMixin {

  late Animation<double> tempAnimation;
  late AnimationController progressController;

  @override
  void initState() {
    super.initState();
 double temp = 20;
    // temp = sensorsTable['temp'] as double;
    double humdity = 100;
    //humidity = sensorsTable['Humdity'] as double;

    _FetchDataInit(temp, humdity);
   
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
    return Scaffold(
      body: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CustomPaint(
                    foregroundPainter:
                        CircleProgress(tempAnimation.value, true),
                    child: Container(
                      width: 200,
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Temperature'),
                            Text(
                              '${tempAnimation.value.toInt()}',
                              style: TextStyle(
                                  fontSize: 50, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '°C',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],

              ),
            ),
          ],
      ),
    
    appBar: AppBar(
        title: const Text(
          'Temperature',
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
          icon:  const Icon(Icons.arrow_back_ios_new),
        ),
      ),
    );
  }
}