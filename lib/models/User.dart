import 'package:flutter/foundation.dart';

class User {
  String uuid;
  String email;
  String firstname;
  String lastname;
  bool activated;
  bool admin;
  double donations;
  String picture;
  List<String> favourites;
  DateTime created_at;
  DateTime updated_at;

  User({
    @required this.uuid,
    @required this.email,
    @required this.firstname,
    @required this.lastname,
    @required this.activated,
    @required this.admin,
    @required this.donations,
    @required this.picture,
    @required this.favourites,
    @required this.created_at,
    @required this.updated_at,
  });

  User.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        email = json['email'],
        firstname = json['firstname'],
        lastname = json['lastname'],
        activated = json['activated'],
        admin = json['admin'],
        donations = json['donations'],
        picture = json['picture'],
        favourites = List<String>.from(json['favourites']),
        created_at = json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at']),
        updated_at = json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at']);

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'email': email,
        'firstname': firstname,
        'lastname': lastname,
        'activated': activated,
        'admin': admin,
        'donations': donations,
        'picture': picture,
        'favourites': favourites,
        'created_at': created_at.toIso8601String(),
        'updated_at': updated_at.toIso8601String(),
      };
}
