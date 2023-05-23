import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class AlertInfo extends StatefulWidget {
  String data;
  String alertname;
  double fontsize;

  AlertInfo(
      {required this.data, required this.alertname, required this.fontsize});

  @override
  State<AlertInfo> createState() => _AlertInfoState();
}

class _AlertInfoState extends State<AlertInfo> {
  var Group = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          AutoSizeText(
            '- ${widget.alertname}:  ',
            group: Group,
            minFontSize: 10,
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          widget.data == 'normal'
              ? Expanded(
                  child: AutoSizeText(
                    "All Good",
                    maxLines: 2,
                    group: Group,
                    style: TextStyle(
                        fontSize: widget.fontsize,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                )
              : Expanded(
                  child: AutoSizeText(
                    widget.data,
                    maxLines: 2,
                    group: Group,
                    minFontSize: 10,
                    style: TextStyle(
                        fontSize: widget.fontsize,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                    overflowReplacement: Text('Sorry String too long'),
                  ),
                ),
        ],
      ),
    );
  }
}
