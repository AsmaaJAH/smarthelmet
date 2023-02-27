import 'package:flutter/material.dart';
import 'package:smarthelmet/modules/AboutUs/teamview.dart';
import 'package:smarthelmet/shared/functions/shared_function.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:readmore/readmore.dart';

import '../../pageview.dart';

class AboutScreen extends StatefulWidget {
  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  int activeindex = 0;
  final HelmetImages = [
    'assets/Helmet/1.jpg',
    'assets/Helmet/2.jpg',
    'assets/Helmet/3.jpg',
    'assets/Helmet/4.jpg',
    'assets/Helmet/5.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            "About us",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.black45,
          leading: IconButton(
              onPressed: () {
                navigateAndFinish(context,PageViewScreen());
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider.builder(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * .4,
                    viewportFraction: 1,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 4),
                    onPageChanged: (index, reason) {
                      setState(() {
                        activeindex = index;
                      });
                    },
                  ),
                  itemCount: HelmetImages.length,
                  itemBuilder: ((context, index, realIndex) {
                    final imageview = HelmetImages[index];
                    return buildImage(imageview, index);
                  }),
                ),
                SizedBox(
                  height: 8,
                ),
                Center(child: Dotedfun(HelmetImages, activeindex)),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .08,
                ),
                Text(
                  "Discribe",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                textfun(
                    "Smart helmet is not an ordinary helmet. As it is mentioned in its name it is a helmet with smart functionalities. It provides the user with high level safety and full access to its phone while driving motor bike or bicycle. Purpose of the product is to provide safety by providing the information of surroundings by using the technology and allow the user to access his/her phone functionalities by his/her voice. Smart helmet is a helmet with some hardware installed in it. End product is the helmet which performs different functionalities by connecting to the user android phone"),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              navigateTo(context, TeamViewScreen());
            },
            child: Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.redAccent),
              child: const Center(
                  child: Text(
                'Team Members',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }
}

Widget textfun(String text) {
  return ReadMoreText(
    text,
    trimCollapsedText: 'Read More',
    moreStyle: TextStyle(
        fontSize: 15, fontWeight: FontWeight.bold, color: Colors.redAccent),
    trimExpandedText: ' Read Less',
    lessStyle: TextStyle(
        fontSize: 15, fontWeight: FontWeight.bold, color: Colors.redAccent),
    style: TextStyle(
      fontSize: 20,
    ),
  );
}

Widget Dotedfun(List<String> image, int activeindex) {
  return AnimatedSmoothIndicator(
    activeIndex: activeindex,
    count: image.length,
    effect: ScrollingDotsEffect(
      fixedCenter: true,
      activeDotColor: Colors.redAccent,
      dotColor: Colors.grey,
      dotWidth: 10,
      dotHeight: 10,
    ),
  );
}

Widget buildImage(String imageview, int index) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 3),
    child: Image.asset(
      imageview,
      fit: BoxFit.cover,
    ),
  );
}
