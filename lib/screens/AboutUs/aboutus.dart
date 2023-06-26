import 'package:flutter/material.dart';
import 'package:smarthelmet/screens/AboutUs/teamview.dart';
import 'package:smarthelmet/shared/functions/navigation.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:readmore/readmore.dart';

class AboutScreen extends StatefulWidget {
  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  int activeindex = 0;
  final HelmetImages = [
    'assets/Helmet/1.jpeg',
    'assets/Helmet/2.jpeg',
    'assets/Helmet/3.jpeg',
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
          backgroundColor: Colors.amber,
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
                  "Description",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                textfun(
                    "Safety is one of the most important aspects in any work environment and while a safety helmet is essential on its own, our project aims to take this mandatory safety equipment a step further to allow the supervisor to monitor his team of workers and the working environment through this mobile app. Our smart safety helmet is equipped with various sensors controlled by a microcontroller in order to keep track of the various changes in the work environment and regularly send this feedback to the mobile app, this will enable the supervisors to better monitor their workers and take action if required."),
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
                  color: Colors.amber),
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
        fontSize: 15, fontWeight: FontWeight.bold, color: Colors.amber),
    trimExpandedText: ' Read Less',
    lessStyle: TextStyle(
        fontSize: 15, fontWeight: FontWeight.bold, color: Colors.amber),
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
      activeDotColor: Colors.amber,
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
