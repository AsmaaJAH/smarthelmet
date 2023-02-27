import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:smarthelmet/modules/home-page/workers.dart';
import 'package:smarthelmet/shared/network/local/cache_helper.dart';

import '../../nav-bar/FetchData.dart';
import '../home-page/HomePage.dart';
import '../home-page/workercard.dart';

class SearchWorker extends StatefulWidget {
  int? Index;
  SearchWorker({this.Index});

  @override
  State<SearchWorker> createState() => _SearchWorkerState();
}

class _SearchWorkerState extends State<SearchWorker> {
  String searchValue = '';
  int? Index;
  final List<String> _suggestions = [
    'Gamal',
    'Yousef',
    'Salah',
    'Nagy',
    'Mousad',
    'Abd Allah Fawzy',
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
        title: 'Search Workers',
        theme: ThemeData(primarySwatch: Colors.cyan),
        home: Scaffold(
          appBar: EasySearchBar(
              title: const Text('Search Workers'),
              onSearch: (value) => setState(() => searchValue = value),
              actions: [
                IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () async{
                   int i=await CachHelper.getData(key:"index");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => WorkerCard(
                                    Index: searchValue,
                                  )));
                    })
              ],
              asyncSuggestions: (value) async =>
                  await _fetchSuggestions(value)),
          drawer: Drawer(
              child: ListView(padding: EdgeInsets.zero, children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
                title: const Text('Item 1'),
                onTap: () => Navigator.pop(context)),
            ListTile(
                title: const Text('Item 2'),
                onTap: () => Navigator.pop(context))
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
                    onPressed: () async {
                      int i=await CachHelper.getData(key:"index");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => FetchData(
                                    index: searchValue,
                                  )));
                    },
                    child: Text(
                      ' $searchValue',
                      style: TextStyle(color: Colors.blue),
                    ))
              ],
            ),
          ),
        ));
  }
}
