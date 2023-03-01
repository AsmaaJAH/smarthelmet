// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchWorker extends StatefulWidget {
  const SearchWorker({Key? key}) : super(key: key);

  @override
  State<SearchWorker> createState() => _SearchState();
}

class _SearchState extends State<SearchWorker> {
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    myController.addListener(showUser);
  }

  showUser() {
    setState(() {});
  }

  @override
  void dispose() {
    myController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.cyan,
          title: TextFormField(
            controller: myController,
            decoration: InputDecoration(labelText: 'Search for a worker...',),
          ),
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('Workers')
              .where("firstName", isEqualTo: myController.text)
              .get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  SizedBox(height: 20,),
                  Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            onTap: () {},
                            title: Text(snapshot.data!.docs[index]["firstName"]),
                            leading: CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  NetworkImage(snapshot.data!.docs[index]["imgurl"]),
                            ),
                          );
                        }),
                  ),
                ],
              );
            }

            return Center(
                child: CircularProgressIndicator(
              color: Colors.cyan ,
            ));
          },
        ));
  }
}
