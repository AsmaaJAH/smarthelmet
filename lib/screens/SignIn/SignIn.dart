import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smarthelmet/screens/signup/SignUp.dart';
import 'package:smarthelmet/shared/functions/showtoast.dart';
import 'package:smarthelmet/shared/functions/navigation.dart';
import '../../pageview.dart';
import '../../shared/network/local/cache_helper.dart';
import '../forgotPasswod/forgot_pass.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool secure = true;
  var formKey = GlobalKey<FormState>();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .1,
                ),
                const Center(
                  child: CircleAvatar(
                    radius: 70.0,
                    backgroundImage: AssetImage('assets/images/helmet.jpeg'),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .1,
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
                  height: MediaQuery.of(context).size.height * .03,
                ),
                TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty) 
                    return 'This field is requreid';
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
                  height: MediaQuery.of(context).size.height * .2,
                ),
                TextButton(
                    onPressed: (() {
                      navigateTo(context, const ForgotPass());
                    }),
                    child: const Text(
                      "Forgot Password ?",
                      style: TextStyle(
                          fontSize: 15, decoration: TextDecoration.underline),
                    )),
                Container(
                  height: MediaQuery.of(context).size.height * .01,
                ),
                InkWell(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text)
                          .then((value) {
                        CachHelper.saveData(key: "uid", value: value.user!.uid);
                        navigateAndFinish(context, PageViewScreen());
                      }).catchError((onError) {
                        showToast(
                            text: onError.toString(),
                            color: Colors.red,
                            time: 5000);
                      });
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
                      'Log In',
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
            const Text('Do not have an account? '),
            TextButton(
                onPressed: () {
                  navigateTo(context, const SignUpScreen());
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                      decoration: TextDecoration.underline, color: Colors.blue),
                )),
          ],
        ),
      ),
    );
  }
}
