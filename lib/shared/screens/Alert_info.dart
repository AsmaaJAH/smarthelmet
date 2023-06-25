import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AlertInfo extends StatefulWidget {
  String data;
  String alertname;
  double fontsize;
  late AsyncSnapshot<dynamic> snapshot;
  late int index;
  AlertInfo(
      {required this.data, required this.alertname, required this.fontsize, required this.snapshot, required this.index});

  @override
  State<AlertInfo> createState() => _AlertInfoState();
}

class _AlertInfoState extends State<AlertInfo> {
  var Group = AutoSizeGroup();
  final dataBase = FirebaseDatabase.instance.ref();

  Map<Object?, Object?> alertTable = {};

  void showNormal() async {
    tables.forEach((key, value) async {
      Query dbRef = FirebaseDatabase.instance.ref().child(key);
      await dbRef.onValue.listen((event) {
        print(event.snapshot.value);
        if (key == "ALERT") {
          alertTable = event.snapshot.value as Map<Object?, Object?>;
        }
        setState(() {});
      });
    });
  }

  Map<String, List<String>> tables = {
    "ALERT": [
      'HUM',
      'LPG',
      'CO',
      'TEMP',
      'fall',
      'object',
      'uid',
      'medicalAssistance'
    ],
    "sensors": [
      'CO PPM value',
      'Humdity',
      'LPG PPM value',
      'temp',
      'undergroundX',
      'undergroundY',
    ],
    "gps": [
      'latitude1',
      'longitude1',
    ],
  };

  @override
  void initState() {
    showNormal();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Text(
            '- ${widget.alertname}:  ',
          
            style: TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        widget.data == 'normal'
              ? Expanded(
                  child: Text(
                    "Normal",
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: widget.fontsize,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                )
              : widget.data == 'not required' 
              ? Expanded(
                  child: Text(
                    "Not Required",
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: widget.fontsize,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                )
              :"${widget.snapshot.data!.docs[widget.index]["uid"]}" == alertTable['uid'].toString()?
              Expanded(
                  child: Text(
                    widget.data,

                    style: TextStyle(
                        fontSize: widget.fontsize,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                )
                :
                Expanded(
                  child: Text(
                    "Normal",

                    style: TextStyle(
                        fontSize: widget.fontsize,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                )

        ],
      ),
    );
  }
}
