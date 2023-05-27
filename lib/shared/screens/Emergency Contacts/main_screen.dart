import 'package:flutter/material.dart';

import 'Components/emergency_contacts_data.dart';
import 'Components/personal_emergency_contacts.dart';

class EmergencyScreen extends StatefulWidget {
  late String index;
  EmergencyScreen({required this.index});

  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen>
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
            style: TextStyle(color: Colors.white)),
        elevation: 0.7,
        bottom: TabBar(
          controller: _controller,
          indicatorColor: Colors.white,
          tabs: const <Widget>[
            Tab(text: "Emergency Contacts"),
            Tab(text: "Personal Contacts")
          ],
        ),
      ),
      body: TabBarView(
          controller: _controller,
          // ignore: prefer_const_literals_to_create_immutables
          children: <Widget>[
            ContactsData(),
            PersonalEmergencyContacts(widget.index)
          ]),
    );
  }
}
