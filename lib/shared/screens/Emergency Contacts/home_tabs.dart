import 'package:flutter/material.dart';
import 'Components/emergency_contacts_data.dart';
import 'Components/personal_emergency_contacts.dart';

class HomeScreenTabs extends StatefulWidget {
  late String index;
  HomeScreenTabs(this.index, {super.key});

  @override
  _HomeScreenTabsState createState() => _HomeScreenTabsState();
}

class _HomeScreenTabsState extends State<HomeScreenTabs>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(
      vsync: this,
      initialIndex: 0,
      length: 2,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("1 click to call Emergency",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 0.7,
        bottom: TabBar(
          labelStyle: const TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),  //For Selected tab
          unselectedLabelStyle: const TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold), //For Un-selected Tabs
          controller: _controller,
          indicatorColor: Colors.white,
          tabs: const <Widget>[
            Tab(text: "Emergency Contacts" , ),
            Tab(text: "Personal Contacts")
          ],
        ),
      ),
      body: TabBarView(

          controller: _controller,
          children: <Widget>[const ContactsData(), PersonalEmergencyContacts(widget.index)]),
    );
  }
}
