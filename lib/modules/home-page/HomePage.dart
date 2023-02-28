

import 'package:flutter/material.dart';
import 'package:smarthelmet/modules/home-page/workers.dart';
import 'package:smarthelmet/shared/network/local/cache_helper.dart';
import 'workercard.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.cyan),
      home: Scaffold(
        extendBody: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Workers'),
        ),
        body: ListView.builder(
            itemCount: map.length,
            itemBuilder: (BuildContext context, int index) {
              CachHelper.saveData(key: "index", value: index);
              return WorkerCard(
                Index: map[index].toString(),
              );
            }),
      ),
    );
  }
}
