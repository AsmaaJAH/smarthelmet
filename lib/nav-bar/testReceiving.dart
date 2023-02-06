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

    await dbRef.get().then((value) {
      value.children.forEach((element) {
        data[element.key.toString()] = element.value.toString();
        print(element.value.toString());
      });
    });
    print(data);
  setState(() {

  });
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
        child:  Container(
        height: double.infinity,
        child: listItem(student: data, context: context)
      )
        // child: Column(
        //   children: [
        //     Text(
        //       "Received Data from Sensors",
        //       style: TextStyle(color: Colors.white, fontSize: 44),
        //     ),
        //     Text(
        //       data.toString(),
        //       style: TextStyle(color: Colors.white, fontSize: 18),
        //     ),
        //   ],
        // ),
      ),
    );
  }

  Widget listItem({required Map student, required context}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 110,
      color: Colors.amberAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            student['CO']??"",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            student['gas']??"",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            student['temp']??"",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                 //Navigator.push(context, MaterialPageRoute(builder: (_) => UpdateRecord(studentKey: student['key'])));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              GestureDetector(
                onTap: () {
                 // reference.child(student['key']).remove();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.red[700],
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
/*
FirebaseAnimatedList(
          query: dbRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {

            // Map student = snapshot.value as Map;
            // student['key'] = snapshot.key;

            return listItem(student: data, context: context );

          },
        ),
 */
