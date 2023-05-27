import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final dataBase = FirebaseDatabase.instance.ref();

  String Time = '';
  Map<Object?, Object?> alertTable = {};
  List alert_show = [];

  void readRealTimeDatabase() async {
    Query dbRef = FirebaseDatabase.instance.ref().child('ALERT');
    await dbRef.onValue.listen((event) {
      alertTable = event.snapshot.value as Map<Object?, Object?>;
      setState(() {
        alertTable.forEach((key, value) {
          if (value != 'normal') {
            alert_show.add(value);
          }
        });
      });
    });
  }

  void time() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        Time = DateFormat.MMMMd().add_jm().format(DateTime.now());
      });
    });
  }

  @override
  void initState() {
    readRealTimeDatabase();
    time();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Alerts')),
      ),
      body: ListView.builder(
          itemCount: alert_show.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: EdgeInsets.symmetric(horizontal: 4),
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: Icon(
                    Icons.error_outline,
                    size: 35,
                    color: Colors.red,
                  ),
                  title: Text(
                    alert_show[index],
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    Time,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                ));
          }),
    );
  }
}
