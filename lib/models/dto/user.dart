import 'package:floor/floor.dart';

List<User> usersFromJson(dynamic str) =>
    List<User>.from(str.map((x) => User.fromJson(x)));

@entity
class User {
  User({
    required this.username,
    required this.password,
    this.mobile,
    this.gender,
    required this.firstname,
    required this.lastname,
    this.picture,
    this.location,
    required this.registrationDate,
    required this.registrationBy,
    required this.userType,
  });

  @primaryKey
  String username;
  String password;
  String? mobile;
  String? gender;
  String firstname;
  String lastname;
  String? picture;
  String? location;
  String registrationDate;
  String registrationBy;
  int? userType;

  //Create empty constructure provided default data in required field
  User.empty()
      : username = '',
        password = '',
        firstname = '',
        lastname = '',
        registrationBy = '',
        registrationDate = '';

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json["username"],
        password: json["password"],
        mobile: json["mobile"],
        gender: json["gender"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        picture: json["picture"],
        location: json["location"],
        registrationDate: json["registration_date"],
        registrationBy: json["registration_by"],
        userType: json["user_type"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "mobile": mobile,
        "gender": gender,
        "firstname": firstname,
        "lastname": lastname,
        "picture": picture,
        "location": location,
        "registration_date": registrationDate,
        "registration_by": registrationBy,
        "user_type": userType,
      };
}
