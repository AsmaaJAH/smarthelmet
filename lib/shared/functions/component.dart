

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({
  required String text,
  required Color color,
  required time,
}) =>
    Fluttertoast.showToast(
      backgroundColor: color,
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: time,
      textColor: Colors.white,
      fontSize: 16.0,
    );
