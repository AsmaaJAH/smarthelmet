import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smarthelmet/screens/SignIn/SignIn.dart';
// ignore_for_file: prefer_equal_for_default_values
import 'package:firebase_core/firebase_core.dart';
import 'package:smarthelmet/pageview.dart';
import 'package:smarthelmet/shared/network/local/cache_helper.dart';
import 'firebase_options.dart';
import 'package:page_transition/page_transition.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CachHelper.init();
  // await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseDatabase.instance;
  var userID = await CachHelper.getData(key: "uid");
  Widget startWidget = SignInScreen();
  if (userID != null) {
    startWidget = PageViewScreen();
  }
  runApp(MyApp(startWidget: startWidget));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  const MyApp({
    super.key,
    required this.startWidget,
  });
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(
            duration: 3000,
            splashIconSize: 100,
            splash: Image.asset(
              'assets/images/splash.jpeg',
            ),
            nextScreen: startWidget,
            splashTransition: SplashTransition.rotationTransition,
            pageTransitionType: PageTransitionType.fade,
            backgroundColor: Colors.white));
  }
}
