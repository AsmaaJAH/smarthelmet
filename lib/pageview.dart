import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'screens/AboutUs/aboutus.dart';
import 'screens/searchScreen/search.dart';
import 'screens/home-page/HomePage.dart';
import 'screens/AddWorker/addWorker.dart';
import 'screens/profile/profile.dart';

class PageViewScreen extends StatefulWidget {
  const PageViewScreen({Key? key}) : super(key: key);

  @override
  State<PageViewScreen> createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {
  int index = 0;
  final screens = [
    HomePageScreen(),
    SearchWorker(),
    AddWorker(),
    ProfilePage(),
    AboutScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.amber),
      home: Scaffold(
        // extendBody: true,
        body: screens[index],
        bottomNavigationBar: Theme(
          data: Theme.of(context)
              .copyWith(iconTheme: IconThemeData(color: Colors.white)),
          child: CurvedNavigationBar(
            height: 50,
            animationDuration: Duration(milliseconds: 300),
            backgroundColor: Colors.transparent,
            color: Colors.amber,
            index: index,
            onTap: (index) {
              setState(() {
                this.index = index;
              });
            },
            items: <Widget>[
              Icon(Icons.home),
              Icon(Icons.search),
              Icon(Icons.add),
              Icon(Icons.person),
              Icon(Icons.info_outline),
            ],
          ),
        ),
      ),
    );
  }
}
