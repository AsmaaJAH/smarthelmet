import 'package:flutter/material.dart';
import 'package:smarthelmet/modules/home-page/HomePage.dart';
import '../../../nav-bar/NavBarScreen.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
             Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => HomePageScreen()));
          },
          icon: const Icon(Icons.arrow_back_ios_new , color: Colors.cyan ,),
        ),

        title: const Text("Safety Helmet",
            style: TextStyle(
                color: Colors.cyan, fontSize: 35, fontWeight: FontWeight.w700)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 20,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 22),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color.fromARGB(255, 132, 255, 239),
              ),
              height: 322,
              width: double.infinity,
              child: Column(
                children: const [
                  Text(
                    "About Project",
                    style: TextStyle(color: Colors.white, fontSize: 44),
                  ),
                  Image(
                    fit: BoxFit.cover,
                    height: 250,
                    image: AssetImage(
                      "assets/images/myappLogo.png",
                    ),
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.cyan,
                    ),
                    height: 100,
                    width: 150,
                    child: const Text(
                      "Monitoring",
                      style: TextStyle(color: Colors.white, fontSize: 27),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 23),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.cyan,
                    ),
                    height: 100,
                    width: 150,
                    child: const Text(
                      "Emergency",
                      style: TextStyle(color: Colors.white, fontSize: 27),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 23),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.cyan,
                    ),
                    height: 100,
                    width: 150,
                    child: const Text(
                      "Tracking",
                      style: TextStyle(color: Colors.white, fontSize: 27),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color.fromARGB(255, 128, 248, 238),
              ),
              height: 322,
              width: double.infinity,
              child: Column(
                children: [
                  const Text(
                    "About us",
                    style: TextStyle(color: Colors.white, fontSize: 44),
                  ),
                  Image.asset(
                    "assets/images/aboutus.PNG",
                    fit: BoxFit.cover,
                    height: 150,
                  ),
                  const Text(
                    "We are engineering students who developed a smart safety helmet with sensors to monitor surrounding data from environment and display the worker position in the cases of emergency ,..etc",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.black54,
        child: const Icon(
          Icons.health_and_safety,
        ),
      ),
    );
  }
}
