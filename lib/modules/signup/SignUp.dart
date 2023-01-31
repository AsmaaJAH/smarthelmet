import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  var usernameController = TextEditingController();
  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children:  [
            SizedBox(height: 60,),
            Center(
              child: CircleAvatar(
                radius: 60,
                child: Image(
                  image: AssetImage('assets/images/helmet.jpeg'),
                ),
              ),
            ),
            SizedBox(height: 10,),
            defaultTextFormFieldColumn(
                controller: usernameController,
                validatorFunction: (value) {
                  if(value.length == 0)
                    return 'this field is requreid';
                },
                textInputType: TextInputType.text,
                labelText: 'User name'
            ),
            SizedBox(height: 10,),
            defaultTextFormFieldColumn(
                controller: emailController,
                validatorFunction: (value) {
                  if(value.length == 0)
                    return 'this field is requreid';

                },
                textInputType: TextInputType.emailAddress,
                labelText: 'Email address',
                prefixIcon: Icon(Icons.email)
            ),
            SizedBox(height: 10,),
            defaultTextFormFieldColumn(
                controller: emailController,
                validatorFunction: (value) {
                  if(value.length == 0)
                    return 'this field is requreid';

                },
                textInputType: TextInputType.visiblePassword,
                labelText: 'Password',
                prefixIcon: Icon(Icons.email)
            )
          ],
        ),
      ),
    );
  }
  Widget defaultTextFormFieldColumn({
    required TextEditingController controller,
    required String labelText ,
    required Function validatorFunction,
    required TextInputType textInputType,
    Function? suffixIconFunction,
    Icon? prefixIcon ,
    IconData? suffixIcon,
    bool isSecure = false,
  }) =>
      Container( // email address
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
      )
  ;
}
