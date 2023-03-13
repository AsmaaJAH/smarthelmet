import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/modules/home-page/workercard.dart';
import 'workerdata.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  List<WorkerData> Workers = [];
  bool isloading = false;

  getdata() async {
    setState(() {
      isloading = true;
    });
    final CollectionReference workerscollection =
        FirebaseFirestore.instance.collection('Workers');

    QuerySnapshot querySnapshot = await workerscollection.get();
    for (var document in querySnapshot.docs) {
      final uid = document.id;
      final Firstname = document.get('firstName');
      final lastname = document.get('lastName');
      final age = document.get('age');
      final imgurl = document.get('imgurl');
      WorkerData worker = WorkerData(
          firstName: Firstname,
          lastName: lastname,
          imgurl: imgurl,
          age: age,
          uid: uid);
      Workers.add(worker);
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    setState(() {
      getdata();
    });
    super.initState();
  }

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
              final worker = Workers[index];
              return isloading
                  ? CircularProgressIndicator(
                      color: Colors.cyan,
                    )
                  : WorkerCard(worker: worker);
            }),
      ),
    );
  }
}
