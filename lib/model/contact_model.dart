import 'dart:convert';

ContactModel contactModelFromJson(String str) => ContactModel.fromJson(json.decode(str));

String contactModelToJson(ContactModel data) => json.encode(data.toJson());

class ContactModel {
  String status;
  List<ContactDetails> data;

  ContactModel({
    required this.status,
    required this.data,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
    status: json["status"],
    data: List<ContactDetails>.from(
        json["data"].map((x) => ContactDetails.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ContactDetails {
  int id;
  String email;
  String firstName;
  String lastName;
  String avatar;

  ContactDetails({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory ContactDetails.fromJson(Map<String, dynamic> json) => ContactDetails(
    id: json["id"],
    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
    "avatar": avatar,
  };
}
