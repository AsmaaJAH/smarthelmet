// ignore: file_names
import 'dart:core';

class UserModel {
  late String email;
  late String password;
  late String uID;
  late String userName;
  late String phone;
  late String role;

  UserModel(this.email, this.password, this.uID, this.userName, this.phone,
      this.role);
  UserModel.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    password = json["password"];
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
      "role": role
    };
  }
}
