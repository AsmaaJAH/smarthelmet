import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../shared/functions/component.dart';
import '../../shared/functions/shared_function.dart';
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
      showToast(color: Colors.lightBlue, text: "Erroe : ${e.code}", time: 5);
    }
    Loading = false;
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
          "Reset Password",
          style:
          TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
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
                      await resetpass();
                      navigateAndFinish(context, SignInScreen());
                    } else {
                      showToast(
                          color: Colors.lightBlue, text: "Error", time: 5);
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
