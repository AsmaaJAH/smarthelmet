import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/shared/functions/component.dart';

class AuthMethods {
  register({
    required email,
    required password,
    // required context
    // required collection
  }) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      CollectionReference users =
          FirebaseFirestore.instance.collection('userSSS');
      users.doc(credential.user!.uid).set({});
    } on FirebaseAuthException catch (e) {
      showToast(text: "ERROR :  ${e.code} ", color: Colors.white, time: 5);
    } catch (e) {
      print(e);
    }
  }
}
