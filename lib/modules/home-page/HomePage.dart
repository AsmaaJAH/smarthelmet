import 'package:flutter/material.dart';
import '../../nav-bar/NavBarScreen.dart';

import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';

import '../../nav-bar/FetchData.dart';
import '../../shared/constants/Constants.dart';
import '../../shared/functions/shared_function.dart';
import '../../shared/network/local/cache_helper.dart';
import '../SignIn/SignIn.dart';
import '../forgotPasswod/aboutUs/aboutus.dart';

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
      title: 'Search workers',
      theme: ThemeData(primarySwatch: Colors.cyan),
      home: Scaffold(
        appBar: EasySearchBar(
            title: const Text('Search workers'),
            onSearch: (value) => setState(() => searchValue = value),
            actions: [
            ],
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
            title: const Text('Worker1: Asmaa', style: TextStyle(
                fontSize: 16.0,
                letterSpacing: 2.0,
                color: Colors.black,
                fontFamily: 'Ubuntu',
              ),),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FetchData()),
            ),
          ),
          ListTile(
            title: const Text('Worker2: Yousseif', style: TextStyle(
                fontSize: 16.0,
                letterSpacing: 2.0,
                color: Colors.black,
                fontFamily: 'Ubuntu',
              ),),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FetchData()),
            ),
          ),
          ListTile(
            title: const Text('Worker3: Salah',style: TextStyle(
                fontSize: 16.0,
                letterSpacing: 2.0,
                color: Colors.black,
                fontFamily: 'Ubuntu',
              ),),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FetchData()),
            ),
          ),
          Divider(),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutScreen()),
              );
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
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.person),
              Text(
                'recent search result:',
                style: TextStyle(
                fontSize: 18.0,
                letterSpacing: 2.0,
                color: Colors.black,
                fontFamily: 'Ubuntu',
              ),
              ),

              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => FetchData()));
                  },
                  child: Text(
                    ' $searchValue',
                    style: TextStyle(color: Colors.blue),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
