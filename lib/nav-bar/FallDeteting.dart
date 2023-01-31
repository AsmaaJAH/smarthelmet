
import 'package:flutter/material.dart';

class FallDetection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fall Detection',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: Colors.white,
            fontFamily: 'Ubuntu',
          ),
        ),
        backgroundColor: Colors.amber[600],
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
    );
  }
}