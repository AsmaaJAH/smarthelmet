import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'emergency_contacts.dart';

class ContactsData extends StatefulWidget {
  const ContactsData({Key? key}) : super(key: key);

  @override
  _ContactsDataState createState() => _ContactsDataState();
}

class _ContactsDataState extends State<ContactsData> {
  static List<String> emergencyContactsName = [
    "Ambulance Service",
    "Natural Gas Emergency",
    "Police Emergency",
    "Fire Rescue Service",
    "Electricity Emergency",
  ];

  static List<String> emergencyContactsInitials = [
    "AS",
    "NGE",
    "PE",
    "FRS",
    "EE"
  ];

  static List<dynamic> icons = [
    Icons.medical_services,
    Icons.support,
    Icons.local_police,
    Icons.fireplace,
    Icons.electric_bolt,
  ];
  static List<String> emergencyContactsNo = [
    "tel: 123",
    "tel: 129",
    "tel: 122",
    "tel: 180",
    "tel: 121"

  ];

  final List<EmergencyContacts> emergencyContacts = List.generate(
      emergencyContactsName.length,
      (index) => EmergencyContacts(emergencyContactsInitials[index],
          emergencyContactsName[index], emergencyContactsNo[index]));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(15),
            child: Wrap(children: [
              Column(children: <Widget>[
                Scrollbar(
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        shrinkWrap: true,
                        itemCount: emergencyContactsName.length,
                        itemBuilder: (BuildContext context, index) {
                          EmergencyContacts contacts =
                              emergencyContacts[index];
                          return SizedBox(
                              height: 100,
                              child: Card(
                                  elevation: 4,
                                  child: InkWell(
                                      onTap: () async {
                                        var phoneNo = contacts.contactNo;
                                        await FlutterPhoneDirectCaller
                                            .callNumber(phoneNo);
                                      },
                                      child: ListTile(
                                          title: Text(contacts.name),
                                          subtitle: Text(contacts.contactNo),
                                          dense: true,
                                          leading: CircleAvatar(
                                              child: Icon(icons[index]))))));
                        }))
              ])
            ])));
  }
}
