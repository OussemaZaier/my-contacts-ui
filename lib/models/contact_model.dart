import 'dart:convert';

import 'package:azlistview/azlistview.dart';

Contact contactFromJson(String str) => Contact.fromJson(json.decode(str));

String contactToJson(Contact data) => json.encode(data.toJson());

class Contact extends ISuspensionBean {
  String id;
  String userId;
  String name;
  String email;
  String phone;
  String tag;
  Contact({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
  }) : tag = name[0].toUpperCase();

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json["_id"],
        userId: json["user_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user_id": userId,
        "name": name,
        "email": email,
        "phone": phone,
      };

  @override
  String getSuspensionTag() => tag;
}
