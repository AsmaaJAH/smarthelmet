import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smarthelmet/shared/functions/shared_function.dart';
import 'dart:io';
import '../../models/workerModel.dart';
import '../../pageview.dart';
import '../../shared/functions/component.dart';
import 'package:path/path.dart' show basename;

class AddWorker extends StatefulWidget {
  const AddWorker({super.key});

  @override
  State<AddWorker> createState() => _AddWorkerState();
}

class _AddWorkerState extends State<AddWorker> {
  final workercollection = FirebaseFirestore.instance.collection("Workers");
  var firstnameController = TextEditingController();
  var lastnameController = TextEditingController();
  var ageController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  bool loading = false;
  File? imgPath;
  String? imgName;
  String? uid;
  String? workerimg;

  addworker() async {
    setState(() {
      loading = true;
    });
    WorkerModel worker = WorkerModel(
      firstName: firstnameController.text,
      lastName: lastnameController.text,
      imgurl: workerimg!,
      age: ageController.text,
    );

    try {
      await workercollection.add(worker.toMap()).then((DocumentReference doc) {
        uid = doc.id;
      });
    } on Exception catch (e) {
      showToast(text: "ERROR :  ${e} ", color: Colors.white, time: 3);
    }
    setState(() {
      loading = false;
    });
  }

  // updateinfo() async {
  //   WorkerInfo workerInfo = WorkerInfo(
  //     firstName: firstnameController.text,
  //     lastName: lastnameController.text,
  //     imgurl: workerimg!,
  //     age: ageController.text,
  //     uid: uid!,
  //   );

  //   try {
  //     workercollection.doc(uid).update(workerInfo.toMap());
  //   } on Exception catch (e) {
  //     showToast(text: "ERROR :  ${e} ", color: Colors.white, time: 3);
  //   }
  // }

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
        workerimg = url;
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
        child: Form(
          key: formKey,
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
                          ),
                          child: ClipOval(
                            child: imgPath == null
                                ? Image.network(
                                    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
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
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () async {
            if (formKey.currentState!.validate() &&
                imgName != null &&
                imgPath != null) {
              try {
                await addworker();
                try {
                  await workercollection.doc(uid).update({'uid': uid!});
                } catch (e) {
                  showToast(
                      text: "ERROR :  ${e} ", color: Colors.white, time: 3);
                }
                showToast(
                    text: 'Worker added successfully',
                    color: Colors.white,
                    time: 5);
                navigateAndFinish(context, PageViewScreen());
              } catch (e) {
                showToast(text: e.toString(), color: Colors.white, time: 5);
              }
            } else if (imgName == null && imgPath == null) {
              showToast(
                  text: "Please select an img", color: Colors.white, time: 3);
            }
          },
          child: Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.cyan),
            child: Center(
                child: loading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        'Add Worker',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
          ),
        ),
      ),
    );
  }
}
