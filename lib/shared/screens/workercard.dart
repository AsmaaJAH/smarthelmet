import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/shared/functions/navigation.dart';
import 'FetchData.dart';

class WorkerCard extends StatefulWidget {
  late AsyncSnapshot<dynamic> snapshot;
  late int index;
  WorkerCard({required this.snapshot, required this.index});

  @override
  State<WorkerCard> createState() => _WorkerCardState();
}

class _WorkerCardState extends State<WorkerCard> {
  final dataBase = FirebaseDatabase.instance.ref();

  Map<Object?, Object?> alertTable = {};

  void workerNotifigation() async {
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
    workerNotifigation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        navigateTo(
            context,
            FetchData(
              snapshot: widget.snapshot,
              index: widget.index,
            ));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        height: 110,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
                height: 90,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 15),
                          blurRadius: 25,
                          color: Colors.black12),
                    ])),
            Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 90,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.snapshot.data!.docs[widget.index]["imgurl"],
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
            Positioned(
                bottom: 0,
                left: size.width * .2,
                child: SizedBox(
                  height: 90,
                  width: size.width - 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Text(
                          "Name : ${widget.snapshot.data!.docs[widget.index]["firstName"]} ${widget.snapshot.data!.docs[widget.index]["lastName"]}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Age     : ${widget.snapshot.data!.docs[widget.index]["age"]}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Spacer()
                    ],
                  ),
                )),
            Positioned(
              top: 30,
              right: 20,
              child: Container(
                child: Icon(Icons.notification_important),
                decoration: BoxDecoration(
                   color: "${widget.snapshot.data!.docs[widget.index]["uid"]}" ==
                        alertTable['uid'].toString()
                    ? Colors.redAccent
                    : Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
