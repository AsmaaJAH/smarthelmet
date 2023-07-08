import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Smart     ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontFamily: 'splashfont'),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    '   Safety',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontFamily: 'splashfont'),
                  ),
                ],
              ),
              SizedBox(
                width: 80,
                height: 90,
                child: Image.asset(
                  'assets/images/splash.jpeg',
                ),
              ),
            ],
          ),
          const Text(
            'Helmet',
            style: TextStyle(
                color: Colors.black, fontSize: 40, fontFamily: 'splashfont'),
          )
        ],
      ),
    );
  }
}
