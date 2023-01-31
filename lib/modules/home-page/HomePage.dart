import 'package:flutter/material.dart';

import '../../nav-bar/NavBarScreen.dart';

class HomePageScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(),
      // appBar: AppBar(
      //     leading: IconButton(
      //       onPressed: () {},
      //       icon: const Icon(Icons.menu),
      //     ),
      // ),
    );
  }
}
