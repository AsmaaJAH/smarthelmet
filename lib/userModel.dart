// ignore: file_names
import 'dart:core';

class UserModel {
  late String email;
  late String password;
  late String uID;
  late String fName;
  late String lName;
  late String phone;

  UserModel(
      this.email, this.password, this.uID, this.fName, this.lName, this.phone);
  UserModel.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    password = json["password"];
    uID = json["uID"];
    fName = json["fName"];
    lName = json["lName"];
    phone = json["phone"];
  }
  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "uID": uID,
      "fName": fName,
      "lName": lName,
      "phone": phone
    };
  }
}
