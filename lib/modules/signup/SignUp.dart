// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smarthelmet/modules/SignIn/SignIn.dart';
import 'package:smarthelmet/shared/functions/shared_function.dart';
import '../../models/userModel.dart';
import '../../shared/functions/passwordcheck.dart';

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
  }) async {
    setState(() {
      Loading = true;
    });
    // FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      UserModel user = UserModel(email, value.user!.uid, userName, phone);
      FirebaseFirestore.instance
          .collection("Users")
          .doc(value.user!.uid)
          .set(user.toMap());
    });

    setState(() {
      Loading = false;
    });
  }

  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var secure = true;
  var formKey = GlobalKey<FormState>();

  bool Loading = false;
  bool is8digits = false;
  bool hasUpper = false;
  bool hasLower = false;
  bool hasDigit = false;
  bool hsaSpecial = false;

  PasswordInteraction(String password) {
    is8digits = false;
    hasUpper = false;
    hasLower = false;
    hasDigit = false;
    hsaSpecial = false;
    setState(() {
      if (password.contains(RegExp(r'.{8,}'))) {
        is8digits = true;
      }
      if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        hsaSpecial = true;
      }
      if (password.contains(RegExp(r'[a-z]'))) {
        hasLower = true;
      }
      if (password.contains(RegExp(r'[0-9]'))) {
        hasDigit = true;
      }
      if (password.contains(RegExp(r'[A-Z]'))) {
        hasUpper = true;
      }
    });
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              navigateAndFinish(context, SignInScreen());
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.lightBlueAccent,
            )),
        title: Text(
          "Sign up",
          style:
          TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .001,
                ),
                const Center(
                  child: CircleAvatar(
                    radius: 70.0,
                    backgroundImage: AssetImage('assets/images/helmet.jpeg'),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .03,
                ),
                TextFormField(
                    controller: usernameController,
                    validator: (value) {
                      if (value!.isEmpty) return 'This field is requreid';
                    },
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        labelText: 'User name',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.person))),
                Container(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                TextFormField(
                    controller: phoneController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field is requreid';
                      } else if (value.length != 13) {
                        return 'Please enter a valid number';
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Phone number',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.phone))),
                Container(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is requreid';
                    } else if (!(value.contains(RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")))) {
                      return "Please enter a valid e-mail";
                    }
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      labelText: 'Email address',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.email)),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                TextFormField(
                  controller: passwordController,
                  onChanged: (value) {
                    PasswordInteraction(value);
                  },
                  validator: (value) {
                    if (value!.isEmpty) return 'This field is requreid';
                    if (value.length < 8) return 'Please enter valid password';
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: secure ? true : false,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              secure = !secure;
                            });
                          },
                          icon: secure
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off))),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                CheckCard("Has Uppercase", hasUpper),
                const SizedBox(
                  height: 8,
                ),
                CheckCard("Has Lowercase", hasLower),
                const SizedBox(
                  height: 8,
                ),
                CheckCard("Has Special Character", hsaSpecial),
                const SizedBox(
                  height: 8,
                ),
                CheckCard("At least one number", hasDigit),
                const SizedBox(
                  height: 8,
                ),
                CheckCard("At least 8 digits", is8digits),
                Container(
                  height: MediaQuery.of(context).size.height * .03,
                ),
                InkWell(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      createUser(
                        email: emailController.text,
                        password: passwordController.text,
                        userName: usernameController.text,
                        phone: phoneController.text,
                      );
                      navigateAndFinish(context, SignInScreen());
                    }
                  },
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue),
                    child: Center(
                        child: Loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
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
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Already have an account? '),
            TextButton(
                onPressed: () {
                  navigateAndFinish(context, SignInScreen());
                },
                child: const Text(
                  'Sign in',
                  style: TextStyle(
                      decoration: TextDecoration.underline, color: Colors.blue),
                )),
          ],
        ),
      ),
    );
  }
}
