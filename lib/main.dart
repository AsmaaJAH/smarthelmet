// ignore_for_file: prefer_equal_for_default_values

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:smarthelmet/userModel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(),
    );
  }
}

void createUser({
  required email,
  required password,
  required fName,
  required lName,
  required phone,
}) async {
  await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: email, password: password)
      .then((value) {
    UserModel user =
        UserModel(email, password, value.user!.uid, fName, lName, phone);
    FirebaseFirestore.instance
        .collection("Users")
        .doc(value.user!.uid)
        .set(user.toMap());
  });
}

void login() async {
  await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: "yousef@gm.co", password: "_password");
}
