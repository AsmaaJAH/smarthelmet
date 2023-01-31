import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController =  TextEditingController();
  var prefixIcon = Icons.lock;
  var suffexIcon = Icons.visibility_off;
  var secure = true;
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              Center(
                child: CircleAvatar(
                  radius: 60,
                  child: Image(
                    image: AssetImage('assets/images/helmet.jpeg'),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              defaultTextFormFieldColumn(
                  controller: usernameController,
                  validatorFunction: (value) {
                    if (value.length == 0) return 'this field is requreid';
                  },
                  textInputType: TextInputType.text,
                  labelText: 'User name'),
              SizedBox(
                height: 10,
              ),
              defaultTextFormFieldColumn(
                  controller: emailController,
                  validatorFunction: (value) {
                    if (value.length == 0) return 'this field is requreid';
                  },
                  textInputType: TextInputType.emailAddress,
                  labelText: 'Email address',
                  prefixIcon: Icon(Icons.email)),
              SizedBox(
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
                    suffexIcon = secure ? Icons.visibility_off: Icons.visibility;
                    setState(() {});
                  }),
              SizedBox(
                height: 10,
              ),
              defaultTextFormFieldColumn(
                  controller: phoneController,
                  validatorFunction: (value) {
                    if (value.length == 0) return 'this field is requreid';
                    else if (value.length != 13) return 'phone is in valid';
                  },
                  textInputType: TextInputType.number,
                  labelText: 'Phone number',
                  prefixIcon: Icon(Icons.phone),
                  ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text('Have an account? '),
                  TextButton(
                      onPressed: () {

                      },
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          color: Colors.blue
                        ),
                      )
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              InkWell(
                onTap: () {
                    if(formKey.currentState!.validate()) {
                      print("All done");
                    }
                },
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue
                  ),
                  child:const  Center(child: Text('Create an acount'
                  ,style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )

                  ),
                ),
              ),
            ],
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
            border: OutlineInputBorder(),
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
