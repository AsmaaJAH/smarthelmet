import 'package:flutter/material.dart';
import 'package:smarthelmet/modules/home-page/workers.dart';
import '../AboutUs/aboutus.dart';
import 'workercard.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import '../../shared/constants/Constants.dart';
import '../../shared/functions/shared_function.dart';
import '../../shared/network/local/cache_helper.dart';
import '../SignIn/SignIn.dart';
import '../profile/profile.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  String searchValue = '';
  final List<String> _suggestions = [
    'youssef',
    'Salah',
    'Asmaa',
    'kholoud',
    'Donia',
    'Mustafa'
  ];

  Future<List<String>> _fetchSuggestions(String searchValue) async {
    await Future.delayed(const Duration(milliseconds: 750));

    return _suggestions.where((element) {
      return element.toLowerCase().contains(searchValue.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Search workers',
      theme: ThemeData(primarySwatch: Colors.cyan),
      home: Scaffold(
        appBar: EasySearchBar(
            title: const Text('Search workers'),
            onSearch: (value) => setState(() => searchValue = value),
            actions: [],
            asyncSuggestions: (value) async => await _fetchSuggestions(value)),
        drawer: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.cyan,
            ),
            child: Text(
              'Smart Safety Helmet',
              style: TextStyle(
                fontSize: 26.0,
                letterSpacing: 2.0,
                color: Colors.white,
                fontFamily: 'Ubuntu',
              ),
            ),
          ),
          ListTile(
              title: Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(
                    width: 18,
                  ),
                  Text(
                    'Profile Page',
                    style: TextStyle(
                      fontSize: 16.0,
                      letterSpacing: 2.0,
                      color: Colors.black,
                      fontFamily: 'Ubuntu',
                    ),
                  ),
                ],
              ),
              onTap: () {
                navigateTo(context, ProfilePage());
              }),
          Container(
            height: MediaQuery.of(context).size.height * .5,
          ),
          ListTile(
            leading: Icon(
              Icons.info,
              color: navBarColor,
            ),
            title: Text(
              'About Us',
              style: TextStyle(
                fontSize: 16.0,
                //fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Colors.black,
                fontFamily: 'Ubuntu',
              ),
            ),
            onTap: () {
              navigateTo(context, AboutScreen());
            },
          ),
          ListTile(
            title: Text(
              'Logout',
              style: TextStyle(
                fontSize: 16.0,
                letterSpacing: 2.0,
                color: Colors.black,
                fontFamily: 'Ubuntu',
              ),
            ),
            leading: const Icon(Icons.exit_to_app),
            onTap: () async {
              navigateAndFinish(context, SignInScreen());
              await CachHelper.removeAllData();
            },
          ),
        ])),
        body: ListView.builder(
            itemCount: Workers.length,
            itemBuilder: (BuildContext context, int index) {
              return WorkerCard(
                Index: index,
              );
            }),
      ),
    );
  }
}
