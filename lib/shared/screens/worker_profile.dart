import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show basename;

import '../functions/showtoast.dart';

class WorkerProfile extends StatefulWidget {
  late AsyncSnapshot<dynamic> snapshot;
  late int index;
  WorkerProfile({required this.snapshot, required this.index});
  @override
  State<WorkerProfile> createState() => _WorkerProfileState();
}

class WorkerView {
  late var data;
  late IconData photo;
  WorkerView({required this.data, required this.photo});
}

class _WorkerProfileState extends State<WorkerProfile> {
  TextEditingController editdialogcontroller = TextEditingController();
  final CollectionReference workerscollection =
      FirebaseFirestore.instance.collection('Workers');
  File? imgPath;
  String? imgName;
  late List<dynamic> workerdata = [
    WorkerView(
        data: widget.snapshot.data!.docs[widget.index]["firstName"],
        photo: Icons.person),
    WorkerView(
        data: widget.snapshot.data!.docs[widget.index]["lastName"],
        photo: Icons.person),
    WorkerView(
        data: widget.snapshot.data!.docs[widget.index]["bloodgroup"],
        photo: Icons.bloodtype),
    WorkerView(
        data: widget.snapshot.data!.docs[widget.index]["address"],
        photo: Icons.maps_home_work),
    WorkerView(
        data: widget.snapshot.data!.docs[widget.index]["contactnumber"],
        photo: Icons.contact_emergency),
    WorkerView(
        data: widget.snapshot.data!.docs[widget.index]["workernumber"],
        photo: Icons.contact_phone),
    WorkerView(
        data: widget.snapshot.data!.docs[widget.index]["age"],
        photo: Icons.date_range),
  ];

  List keys = [
    'firstName',
    'lastName',
    "bloodgroup",
    "address",
    "contactnumber",
    "workernumber",
    "age"
  ];

  EditDialog(var data, dynamic key) {
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
                    decoration: InputDecoration(hintText: "  ${data}    ")),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () {
                          workerscollection
                              .doc(widget.snapshot.data!.docs[widget.index]
                                  ["uid"])
                              .update({key: editdialogcontroller.text});

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

  uploadImage(ImageSource source) async {
    Navigator.pop(context);
    final pickedImg = await ImagePicker().pickImage(source: source);
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
        });
        int random_f = Random().nextInt(999999999);
        int random_l = Random().nextInt(999999999);
        imgName = basename(pickedImg.path);
        imgName = '$random_f$imgName$random_l';
        final storageRef = FirebaseStorage.instance.ref(imgName);
        await storageRef.putFile(imgPath!);
        String url = await storageRef.getDownloadURL();
        await workerscollection
            .doc(widget.snapshot.data!.docs[widget.index]["uid"])
            .update({
          "imgurl": url,
        });
      } else {
        showToast(text: "No img selected", color: Colors.white, time: 3);
      }
    } catch (e) {
      showToast(text: "ERROR :  ${e} ", color: Colors.white, time: 3);
    }
  }

  showmodel() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(22),
          height: 170,
          color: Colors.cyan,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  await uploadImage(ImageSource.camera);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width * .2,
                    // ),
                    Icon(
                      Icons.camera,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .05,
                    ),
                    Text(
                      "From Camera",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 22,
              ),
              GestureDetector(
                onTap: () async {
                  await uploadImage(ImageSource.gallery);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .05,
                    ),
                    Text(
                      "From Gallery",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(
          'Worker Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .04,
          ),
          Center(
            child: Stack(children: [
              Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  border: Border.all(width: 4, color: Colors.cyan),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 10,
                        color: Colors.black.withOpacity(.1),
                        offset: Offset(0, 10))
                  ],
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: imgPath == null
                      ? Image.network(
                          widget.snapshot.data!.docs[widget.index]["imgurl"],
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          imgPath!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 5, color: Colors.cyan),
                          color: Colors.cyan),
                      child: IconButton(
                        onPressed: () async {
                          await showmodel();
                          showToast(
                              text: 'Img updated succssefully',
                              color: Colors.black,
                              time: 10);
                        },
                        icon: Icon(Icons.edit),
                        color: Colors.white,
                      ))),
            ]),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .07,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: workerdata.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 70,
                        child: Card(
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .03,
                                      ),
                                      Icon(
                                        workerdata[index].photo,
                                        size: 35,
                                        color: Colors.cyan,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .05,
                                      ),
                                      Text(
                                        workerdata[index].data,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        EditDialog(workerdata[index].data,
                                            keys[index]);
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.blueGrey,
                                      ))
                                ],
                              ),
                            )),
                      ),
                    );
                  })),
        ],
      ),
    );
  }
}
