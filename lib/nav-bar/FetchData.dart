import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:smarthelmet/nav-bar/NavBarScreen.dart';
// import 'package:http/http.dart' as http;

class FetchData extends StatefulWidget {
  FetchData({super.key});

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  final dataBase = FirebaseDatabase.instance.ref();

  Query dbRef = FirebaseDatabase.instance.ref().child('ALRET');
  Map<String, dynamic> data = {};
  void readRealTimeDatabase() async {
    await dbRef.onValue.listen((event) {
      data = event.snapshot.value as Map<String, dynamic>;
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    readRealTimeDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final test = dataBase.child("write now/");
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: const Text(
          'Worker',
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
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        readRealTimeDatabase();
        test
            .set({"a": '5000'})
            .then((value) => print('done'))
            .catchError((onError) => print("error ${onError.toString()}"));
      }),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          margin: EdgeInsets.only(bottom: 22),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.cyan,
          ),
          height: 322,
          width: double.infinity,
          child: Container(
              height: double.infinity,
              child: listItem(sensors: data, context: context))),
    );
  }

  Widget listItem({required Map sensors, required context}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 110,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Received Data from Sensors",
            style: TextStyle(color: Colors.cyan, fontSize: 44),
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            sensors['CO'] ?? "",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            sensors['gas'] ?? "",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            sensors['temp']?? "",
            // sensors['teml'] ?? "",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
