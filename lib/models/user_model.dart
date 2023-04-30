import 'package:get/get.dart';

class UserModel {
  String uid;
  String firstName;
  String lastName;
  String userName;
  String phoneNumber;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        uid: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        userName: json["user_name"],
        phoneNumber: json["phone_number"]);
  }

  Map<String ,dynamic> toJson(){
    return {
      "id":uid,
      "first_name":firstName,
      "last_name":lastName,
      "user_name":userName,
      "phone_number":phoneNumber,
    };
}
}
