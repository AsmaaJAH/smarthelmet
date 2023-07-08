import 'package:flutter/material.dart';
import 'package:smarthelmet/screens/AboutUs/teamcard.dart';
import 'package:smarthelmet/screens/AboutUs/teammembers.dart';

class TeamViewScreen extends StatefulWidget {
  const TeamViewScreen({super.key});

  @override
  State<TeamViewScreen> createState() => _TeamViewScreenState();
}

class _TeamViewScreenState extends State<TeamViewScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Team Members",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.black45,
        ),
        body: ListView.builder(
            itemCount: Members.length,
            itemBuilder: (BuildContext context, int index) {
              return Teamcard(
                Index: index,
              );
            }),
      ),
    );
  }
}
