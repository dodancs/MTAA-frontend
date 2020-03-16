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
  List<dynamic> favourites;
  DateTime created_at;
  DateTime updated_at;

  User(
      {@required this.uuid,
      @required this.email,
      @required this.firstname,
      @required this.lastname,
      @required this.activated,
      @required this.admin,
      @required this.donations,
      @required this.picture,
      @required this.favourites,
      @required this.created_at,
      @required this.updated_at});
}
