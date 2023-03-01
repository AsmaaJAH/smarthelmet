class WorkerModel {
  late String firstName;
  late String lastName;
  late String imgurl;
  late String age;


  WorkerModel(
      {required this.firstName,
      required this.lastName,
      required this.imgurl,
      required this.age,
      });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      "imgurl": imgurl,
      "age": age,
    };
  }
}
