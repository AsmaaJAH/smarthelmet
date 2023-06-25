import 'package:flutter/material.dart';
import 'package:smarthelmet/modules/Emergency%20Contacts/Components/splash_screen.dart';
import 'package:smarthelmet/modules/Emergency%20Contacts/home_tabs.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class EmergencyScreen extends StatefulWidget {
  late String index;
  EmergencyScreen(this.index);

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Emergency Help',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: Colors.white,
            fontFamily: 'Ubuntu',
          ),
        ),
        backgroundColor: Colors.amber,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: AnimatedSplashScreen(
          duration: 500,
          splash: const SplashScreen(),
          nextScreen: HomeScreenTabs(widget.index),
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.white),
    );
  }
}
