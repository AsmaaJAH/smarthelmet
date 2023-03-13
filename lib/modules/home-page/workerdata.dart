class WorkerData {
  late String firstName;
  late String lastName;
  late String imgurl;
  late String age;
  late String uid;

  WorkerData({
    required this.firstName,
    required this.lastName,
    required this.imgurl,
    required this.age,
    required this.uid,

  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      "imgurl": imgurl,
      "age": age,
      "uid": uid,
    };
  }
}
