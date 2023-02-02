import 'package:flutter/material.dart';

class CheckCard extends StatefulWidget {
  bool variable = false;
  String text = "";

  CheckCard(this.text, this.variable, {super.key});

  @override
  State<CheckCard> createState() => _CheckCardState();
}

class _CheckCardState extends State<CheckCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              shape: BoxShape.circle,
              color: widget.variable ? Colors.green : Colors.white),
          child: const Icon(
            Icons.check,
            size: 15,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(widget.text),
      ],
    );
  }
}
