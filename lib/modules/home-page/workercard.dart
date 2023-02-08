import 'package:flutter/material.dart';
import 'package:smarthelmet/modules/home-page/workers.dart';
import 'package:smarthelmet/shared/functions/shared_function.dart';
import '../../nav-bar/FetchData.dart';

class WorkerCard extends StatefulWidget {
  int? Index;
  WorkerCard({required this.Index});

  @override
  State<WorkerCard> createState() => _WorkerCardState();
}

class _WorkerCardState extends State<WorkerCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        navigateAndFinish(
          context,FetchData()
        );
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
                    child: Image.asset(
                      Workers[widget.Index!].imgpath,
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
            Positioned(
                bottom: 0,
                right: 0,
                child: SizedBox(
                  height: 80,
                  width: size.width - 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        child: Text(Workers[widget.Index!].workername,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 60),
                        child: Text("${Workers[widget.Index!].age}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),),
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
