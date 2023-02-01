import 'package:flutter/material.dart';
import 'package:smarthelmet/modules/SignIn/SignIn.dart';
import 'package:smarthelmet/shared/constants/Constants.dart';
import 'package:smarthelmet/shared/functions/shared_function.dart';
import 'package:smarthelmet/shared/network/local/cache_helper.dart';

class LogOutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Log out',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: Colors.white,
            fontFamily: 'Ubuntu',
          ),
        ),
        backgroundColor: navBarColor,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            navigateAndFinish(context, SignInScreen());
            CachHelper.removeAllData();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
    );
  }
}
