import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'package:http/http.dart' as http;

class Try extends StatefulWidget {
  Try({super.key});

  @override
  State<Try> createState() => _TryState();
}

class _TryState extends State<Try> {
  final dataBase = FirebaseDatabase.instance.reference();

  Query dbRef = FirebaseDatabase.instance.ref().child('ALRET');

  Map<String, dynamic> data = {};

  void read() async {
    dbRef.onValue.listen((event) {
     data = event.snapshot.value as Map <String, dynamic> ;
      print(data);
    });

    await dbRef.get().then((value) {
      value.children.forEach((element) {
        data[element.key.toString()] = element.value.toString();
        print(element.value.toString());
      });
    });
    print(data);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    read();
    super.initState();
  }

  // Future<http.Response> fetchAlbum() {
  @override
  Widget build(BuildContext context) {
    final test = dataBase.child("write now/");

    //final readDatabase = fetchAlbum();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Worker 1',
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
      floatingActionButton: FloatingActionButton(onPressed: () {
        read();
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
            sensors['temp'] ?? "",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
