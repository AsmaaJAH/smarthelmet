import 'package:flutter/material.dart';
import 'package:smarthelmet/modules/AboutUs/aboutus.dart';
import 'package:smarthelmet/modules/AboutUs/teamcard.dart';
import 'package:smarthelmet/modules/AboutUs/teammembers.dart';
import 'package:smarthelmet/shared/functions/shared_function.dart';

class TeamViewScreen extends StatefulWidget {
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
          title: Text(
            "Team Members",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.black45,
          leading: IconButton(
              onPressed: () {
                navigateAndFinish(context, AboutScreen());
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        body:ListView.builder(
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
