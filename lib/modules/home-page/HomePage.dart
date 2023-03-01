import 'package:flutter/material.dart';
import 'package:smarthelmet/modules/home-page/workers.dart';
import '../../shared/functions/shared_function.dart';
import '../../shared/network/local/cache_helper.dart';
import '../SignIn/SignIn.dart';
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
          title: Text(
            'Workers',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: ListView.builder(
            itemCount: Workers.length,
            itemBuilder: (BuildContext context, int index) {
              return WorkerCard(
                Index: index,
              );
            }),
      ),
    );
  }
}
