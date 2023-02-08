import 'package:flutter/material.dart';

import 'teammembers.dart';

class Teamcard extends StatefulWidget {
  int? Index;
  Teamcard({required this.Index});

  @override
  State<Teamcard> createState() => _TeamcardState();
}

class _TeamcardState extends State<Teamcard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: 160,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
              height: 140,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: Colors.white54,
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
                height: 100,
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    Members[widget.Index!].imgpath,
                    fit: BoxFit.cover,
                  ),
                ),
              )),
          Positioned(
              bottom: 0,
              right: 0,
              child: SizedBox(
                height: 100,
                width: size.width - 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      child: Text(
                        Members[widget.Index!].name,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60),
                      child: Text(
                        Members[widget.Index!].team,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        Members[widget.Index!].qual,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
