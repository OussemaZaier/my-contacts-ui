import 'dart:convert';

import 'package:contacts_flutter/utils/serializable.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User extends Serializable {
  String username;
  String email;
  String password;

  User({
    required this.username,
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json["username"],
        email: json["email"],
        password: json["password"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "password": password,
      };
}
