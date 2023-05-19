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
                left: size.width * .3,
                child: SizedBox(
                  height: 80,
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
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "age     : ${widget.snapshot.data!.docs[widget.index]["age"]}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Spacer()
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}