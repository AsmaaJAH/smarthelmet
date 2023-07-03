class PersonalEmergency {
  late String id;
  late String name, contactNo;
  PersonalEmergency(this.name,this.id, this.contactNo);

  // EmergencyContacts(this.initials, this.name, this.contactNo);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'name': name, 'contactNo': contactNo};
    return map;
  }

  PersonalEmergency.fromMap(Map<dynamic, dynamic> map) {
    id = map['id'];
    name = map['name'];
    contactNo = map['contactNo'];
  }
}
