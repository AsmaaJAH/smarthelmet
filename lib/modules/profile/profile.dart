import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/shared/functions/shared_function.dart';

import '../../shared/functions/component.dart';
import '../home-page/getfirestoredata.dart';
import '../SignIn/SignIn.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final credential = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.cyan,
        title: Center(
          child: Text("Profile Page"),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FirestoreData(documentId: credential!.uid),
                Container(
                  height: MediaQuery.of(context).size.height * .5,
                ),
            InkWell(
              onTap: () async {
                await FirebaseAuth.instance
                    .sendPasswordResetEmail(email: credential!.email!);
                showToast(
                    color: Colors.lightBlue,
                    text: "Please check your e-mail",
                    time: 5);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.cyan),
                  child: const Center(
                      child: Text(
                    'Reset Psasword',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ),
              ),
            ),

            InkWell(
              onTap: () async {
                users.doc(credential!.uid).delete();
                credential!.delete();
                navigateAndFinish(context, SignInScreen());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.cyan),
                  child: const Center(
                      child: Text(
                    'Delete Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
