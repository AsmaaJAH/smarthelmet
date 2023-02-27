import 'package:flutter/material.dart';

class SearchWorker extends StatefulWidget {
  const SearchWorker({super.key});

  @override
  State<SearchWorker> createState() => _SearchWorkerState();
}

class _SearchWorkerState extends State<SearchWorker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('seaaaaa'),
      ),
    );
  }
}