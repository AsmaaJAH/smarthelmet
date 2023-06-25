// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreData extends StatefulWidget {
  final String documentId;

  const FirestoreData({Key? key, required this.documentId}) : super(key: key);

  @override
  State<FirestoreData> createState() => _FirestoreDataState();
}

class _FirestoreDataState extends State<FirestoreData> {
  final editdialogcontroller = TextEditingController();
  final credential = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  EditDialog(Map data, dynamic key) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          child: Container(
            padding: EdgeInsets.all(22),
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                    controller: editdialogcontroller,
                    decoration:
                        InputDecoration(hintText: "  ${data[key]}    ")),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () async {
                          if (key == 'email') {
                            await credential
                                ?.updateEmail(editdialogcontroller.text);
                            await users
                                .doc(credential!.uid)
                                .update({key: editdialogcontroller.text});
                          } else {
                            await users
                                .doc(credential!.uid)
                                .update({key: editdialogcontroller.text});
                          }

                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                        child: Text(
                          "Edit",
                          style: TextStyle(fontSize: 17),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: 17),
                        )),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 9,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Username: ${data['userName']}",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          EditDialog(data, 'userName');
                        },
                        icon: Icon(Icons.edit))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Email: ${data['email']}",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          EditDialog(data, 'email');
                        },
                        icon: Icon(Icons.edit))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Phone: ${data['phone']} ",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          EditDialog(data, 'phone');
                        },
                        icon: Icon(Icons.edit))
                  ],
                ),
              ],
            ),
          );
        }

        return Text("loading");
      },
    );
  }
}
