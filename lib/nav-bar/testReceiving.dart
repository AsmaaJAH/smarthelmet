import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'package:http/http.dart' as http;

class Try extends StatelessWidget {
  Try({super.key});
  final dataBase = FirebaseDatabase.instance.reference();
  Query dbRef = FirebaseDatabase.instance.ref().child('ALRET');
  Map<String, dynamic> data = {};
  void read() async {
    await dbRef.get().then((value) {
      value.children.forEach((element) {
        data[element.key.toString()] = element.value.toString();
        print(element.value.toString());
      });
    });
  }

  // Future<http.Response> fetchAlbum() {
  //   final response = http.get(Uri.parse(
  //       'https://smarthelmet-de844-default-rtdb.europe-west1.firebasedatabase.app/'));
  //   log(response.toString());
  //   return response;
  // }

  @override
  Widget build(BuildContext context) {
    final test = dataBase.child("write now/");

    //final readDatabase = fetchAlbum();
    return Scaffold(
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
          //borderRadius: BorderRadius.circular(15),
          color: Colors.cyan,
        ),
        height: 322,
        width: double.infinity,
        child: Column(
          children: [
            Text(
              "Received Data from Sensors",
              style: TextStyle(color: Colors.white, fontSize: 44),
            ),
            Text(
              data.toString(),
              style: TextStyle(color: Colors.white, fontSize: 18),

              ),
          ],
        ),
      ),
    );
  }
}
