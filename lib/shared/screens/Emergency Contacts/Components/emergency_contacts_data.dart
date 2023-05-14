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
  String? _selectedCity;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(15),
            child: Wrap(children: [
              Column(children: <Widget>[
                DropdownButton(
                  iconEnabledColor: Colors.cyan,
                  hint: _selectedCity == null
                      ? const Text('Select City')
                      : Text(
                          _selectedCity!,
                        ),
                  items: <String>["Alexandria", "Cairo", "Damanhour"].map((city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                  onChanged: (city) {
                    setState(() {
                      _selectedCity = city.toString();
                    });
                  },
                ),
                Scrollbar(
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        shrinkWrap: true,
                        itemCount: emergencyContactsName.length,
                        itemBuilder: (BuildContext context, index) {
                          EmergencyContacts _contacts =
                              emergencyContacts[index];
                          return SizedBox(
                              height: 100,
                              child: Card(
                                  elevation: 4,
                                  child: InkWell(
                                      onTap: () async {
                                        var phoneNo = _contacts.contactNo;
                                        await FlutterPhoneDirectCaller
                                            .callNumber(phoneNo);
                                      },
                                      child: ListTile(
                                          title: Text(_contacts.name),
                                          subtitle: Text(_contacts.contactNo),
                                          dense: true,
                                          leading: CircleAvatar(
                                              child: Icon(icons[index]))))));
                        }))
              ])
            ])));
  }
}
