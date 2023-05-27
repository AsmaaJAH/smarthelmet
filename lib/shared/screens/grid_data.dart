import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../functions/navigation.dart';

class GridCard extends StatefulWidget {
  var screen;
  String imgpath;
  String text;

  GridCard({required this.screen, required this.imgpath, required this.text});
  @override
  State<GridCard> createState() => _GridCardState();
}

class _GridCardState extends State<GridCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateTo(context, widget.screen);
      },
      child: Container(
        height: 150,
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 236, 235, 235),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.asset(
                      widget.imgpath,
                      scale: sqrt1_2,
                      color: Colors.blueAccent,
                    )),
              ),
            ),
            AutoSizeText(
              widget.text,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              maxLines: 1,
              minFontSize: 13,
            ),
          ],
        ),
      ),
    );
  }
}
