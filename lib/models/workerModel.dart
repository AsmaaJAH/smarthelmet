class WorkerModel {
  late String firstName;
  late String lastName;
  late String bloodgroup;
  late String address;
  late String workernumber;
  late String imgurl;
  late String age;

  WorkerModel({
    required this.firstName,
    required this.lastName,
    required this.bloodgroup,
    required this.address,
    required this.workernumber,
    required this.imgurl,
    required this.age,

  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'bloodgroup': bloodgroup,
      'address': address,
      'workernumber': workernumber,
      "imgurl": imgurl,
      "age": age,
    };
  }
}
