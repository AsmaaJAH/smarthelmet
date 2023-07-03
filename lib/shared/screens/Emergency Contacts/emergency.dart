import 'package:flutter/material.dart';
import 'home_tabs.dart';
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
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: Colors.white,
            fontFamily: 'Ubuntu',
          ),
        ),
        backgroundColor: Colors.amber,
        elevation: 0.0,
        leading: Icon(
           Icons.call
        ),
      ),
      body:  HomeScreenTabs(widget.index),
          
    );
  }
}
