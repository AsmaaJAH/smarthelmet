import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget defaultTextFormFieldColumn({
  required TextEditingController controller,
  required String labelText,
  required Function validatorFunction,
  required TextInputType textInputType,
  Function? suffixIconFunction,
  Icon? prefixIcon,
  IconData? suffixIcon,
  bool isSecure = false,
}) =>
    // email address

    SizedBox(
      // height: 50,
      child: TextFormField(
        validator: (value) {
          return validatorFunction(value);
        },
        obscureText: isSecure,
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          labelText: labelText,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(suffixIcon),
            onPressed: () {
              return suffixIconFunction!();
            },
          ),
        ),
      ),
    );
