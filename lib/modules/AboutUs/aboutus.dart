import 'package:flutter/material.dart';
import 'package:smarthelmet/modules/AboutUs/teamcard.dart';
import 'package:smarthelmet/modules/AboutUs/teammembers.dart';
import 'package:smarthelmet/shared/functions/shared_function.dart';
import '../home-page/HomePage.dart';

class AboutScreen extends StatelessWidget {
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
            "About us",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.black45,
          leading: IconButton(
              onPressed: () {
                navigateAndFinish(context, HomePageScreen());
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
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
