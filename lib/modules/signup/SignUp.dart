// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/modules/SignIn/SignIn.dart';
import 'package:smarthelmet/shared/functions/shared_function.dart';

import '../home-page/HomePage.dart';

import '../../models/userModel.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  void createUser({
    required email,
    required password,
    required userName,
    required phone,
    required role,
  }) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      UserModel user =
          UserModel(email, password, value.user!.uid, userName, phone, role);
      FirebaseFirestore.instance
          .collection("Users")
          .doc(value.user!.uid)
          .set(user.toMap());
    });
  }

  int _radioSelected = 2;
  String role = "worker";
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var prefixIcon = Icons.lock;
  var suffexIcon = Icons.visibility_off;
  var secure = true;
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                const Center(
                  child: CircleAvatar(
                    radius: 70.0,
                    backgroundImage: AssetImage('assets/images/helmet.jpeg'),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                defaultTextFormFieldColumn(
                    controller: usernameController,
                    validatorFunction: (value) {
                      if (value.length == 0) return 'this field is requreid';
                    },
                    textInputType: TextInputType.text,
                    labelText: 'User name'),
                const SizedBox(
                  height: 10,
                ),
                defaultTextFormFieldColumn(
                    controller: emailController,
                    validatorFunction: (value) {
                      if (value.length == 0) return 'this field is requreid';
                    },
                    textInputType: TextInputType.emailAddress,
                    labelText: 'Email address',
                    prefixIcon: const Icon(Icons.email)),
                const SizedBox(
                  height: 10,
                ),
                defaultTextFormFieldColumn(
                    controller: passwordController,
                    validatorFunction: (value) {
                      if (value.length == 0) return 'this field is requreid';
                      if (value.length < 8) return 'password is too short';
                    },
                    textInputType: TextInputType.visiblePassword,
                    labelText: 'Password',
                    prefixIcon: Icon(prefixIcon),
                    isSecure: secure,
                    suffixIcon: suffexIcon,
                    suffixIconFunction: () {
                      secure = !secure;
                      prefixIcon = secure ? Icons.lock : Icons.lock_open;
                      suffexIcon =
                          secure ? Icons.visibility_off : Icons.visibility;
                      setState(() {});
                    }),
                const SizedBox(
                  height: 10,
                ),
                defaultTextFormFieldColumn(
                  controller: phoneController,
                  validatorFunction: (value) {
                    if (value.length == 0)
                      return 'this field is requreid';
                    else if (value.length != 13) return 'phone is in valid';
                  },
                  textInputType: TextInputType.number,
                  labelText: 'Phone number',
                  prefixIcon: const Icon(Icons.phone),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Choose Role'),
                    const SizedBox(height: 7),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: (() => {
                                setState(() {
                                  _radioSelected = 1;
                                  role = "supervisor";
                                })
                              }),
                          child: Container(
                            width: 150,
                            height: 40,
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.grey)),
                            child: Row(children: [
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'Supervisor',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Radio(
                                value: 1,
                                groupValue: _radioSelected,
                                activeColor: Colors.blue,
                                onChanged: (value) {
                                  setState(() {
                                    _radioSelected = 1;
                                    role = "supervisor";
                                  });
                                },
                              ),
                            ]),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: (() => {
                                setState(() {
                                  _radioSelected = 2;
                                  role = "worker";
                                })
                              }),
                          child: Container(
                            width: 130,
                            height: 40,
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.grey)),
                            child: Row(children: [
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'Worker',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Radio(
                                value: 2,
                                groupValue: _radioSelected,
                                activeColor: Colors.blue,
                                onChanged: (value) {
                                  setState(() {
                                    _radioSelected = 2;
                                    role = "worker";
                                  });
                                },
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text('Have an account? '),
                    TextButton(
                        onPressed: () {
                          navigateTo(context, SignInScreen());
                        },
                        child: const Text(
                          'Sign in',
                          style: TextStyle(color: Colors.blue),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      print("All done");
                      createUser(
                          email: emailController.text,
                          password: passwordController.text,
                          userName: usernameController.text,
                          phone: phoneController.text,
                          role: role);
                      navigateAndFinish(context, SignInScreen());
                    }
                  },
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue),
                    child: const Center(
                        child: Text(
                      'Create an acount',
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
      Container(
        // email address
        height: 50.0,
        child: TextFormField(
          validator: (value) {
            return validatorFunction(value);
          },
          obscureText: isSecure,
          controller: controller,
          keyboardType: textInputType,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            prefix: Padding(
              padding: const EdgeInsets.all(8.0),
              child: prefixIcon,
            ),
            suffixIcon: IconButton(
              icon: Icon(suffixIcon),
              onPressed: () {
                return suffixIconFunction!();
              },
            ),
          ),
        ),
      );
}
