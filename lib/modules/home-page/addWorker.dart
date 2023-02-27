import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart' show basename;
import 'dart:io';
import '../../models/workerModel.dart';
import '../../shared/functions/component.dart';

class AddWorker extends StatefulWidget {
  const AddWorker({super.key});

  @override
  State<AddWorker> createState() => _AddWorkerState();
}

class _AddWorkerState extends State<AddWorker> {
  var firstnameController = TextEditingController();
  var lastnameController = TextEditingController();
  var ageController = TextEditingController();

  File? imgPath;
  String? imgName;
  String? uid;
  String? workerimg;

  uploadImage(ImageSource source) async {
    Navigator.pop(context);
    final pickedImg = await ImagePicker().pickImage(source: source);
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
        });
        imgName = basename(pickedImg.path);
      } else {
        showToast(text: "NO img selected", color: Colors.white, time: 3);
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  await uploadImage(ImageSource.camera);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.camera,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      "From Camera",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 22,
              ),
              GestureDetector(
                onTap: () {
                  uploadImage(ImageSource.gallery);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.photo_outlined,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      "From Gallery",
                      style: TextStyle(fontSize: 20),
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

  addworker() async {
    final storageRef = FirebaseStorage.instance.ref(imgName);
    await storageRef.putFile(imgPath!);
    String url = await storageRef.getDownloadURL();
    workerimg = url;
    WorkerModel worker = WorkerModel(
        firstName: firstnameController.text,
        lastName: lastnameController.text,
        imgurl: url,
        age: ageController.text);

    await FirebaseFirestore.instance
        .collection("Workers")
        .add(worker.toMap())
        .then((DocumentReference doc) {
      uid = doc.id;
    });
  }

  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: Text(
          'Add Worker',
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * .02,
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
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: imgPath == null
                                      ? NetworkImage(
                                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png')
                                      : NetworkImage(workerimg!))),
                        ),
                        Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 5, color: Colors.cyan),
                                    color: Colors.cyan),
                                child: imgPath == null
                                    ? IconButton(
                                        onPressed: () {
                                          showmodel();
                                        },
                                        icon: Icon(Icons.add_a_photo),
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          showmodel();
                                        },
                                        icon: Icon(Icons.edit),
                                      ))),
                      ]),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * .05,
                    ),
                    TextFormField(
                        controller: firstnameController,
                        validator: (value) {
                          if (value!.isEmpty) return 'This field is requreid';
                        },
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'First name',
                          border: OutlineInputBorder(),
                        )),
                    Container(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    TextFormField(
                        controller: lastnameController,
                        validator: (value) {
                          if (value!.isEmpty) return 'This field is requreid';
                        },
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Last name',
                          border: OutlineInputBorder(),
                        )),
                    Container(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    TextFormField(
                        controller: ageController,
                        validator: (value) {
                          if (value!.isEmpty) return 'This field is requreid';
                        },
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'age',
                          border: OutlineInputBorder(),
                        )),
                    Container(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.cyan),
                    child: Center(
                        child:
                            // ? const CircularProgressIndicator(
                            //     color: Colors.white,
                            //   )
                            // :
                            const Text(
                      'Add Worker',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
