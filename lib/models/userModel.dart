// ignore: file_names
import 'dart:core';

class UserModel {
  late String email;
  late String uID;
  late String userName;
  late String phone;

  UserModel(this.email, this.uID, this.userName, this.phone);
  UserModel.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    uID = json["uID"];
    userName = json["userName"];
    phone = json["phone"];
  }
  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "uID": uID,
      "userName": userName,
      "phone": phone,
    };
  }
}
