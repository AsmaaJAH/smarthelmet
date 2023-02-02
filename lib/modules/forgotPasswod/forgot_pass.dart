import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../shared/functions/snackbar.dart';
import '../SignIn/SignIn.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  var emailController = TextEditingController();
  bool Loading = false;

  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  resetpass() async {
    Loading = true;
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      if (!mounted) return;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => SignInScreen()));
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "Erroe : ${e.code}");
    }
    Loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Enter your email"),
                const SizedBox(
                  height: 15,
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
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formkey.currentState!.validate()) {
                      resetpass();
                    } else {
                      showSnackBar(context, "Error");
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
                                'Reset Password',
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
