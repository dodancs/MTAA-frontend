import 'dart:convert';

import 'package:CiliCat/models/User.dart';
import 'package:http/http.dart' as http;
import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  String _tokenType;
  DateTime _expires;
  String _uuid;
  bool _admin;
  User current_user;
  bool _loggedIn = false;

  Future getUser(String uuid) async {
    http.Response tmp;
    try {
      tmp = await http.get(
        Uri.http(API_URL, '/auth/users/' + uuid),
        headers: {'Authorization': _tokenType + ' ' + _token},
      );
    } catch (error) {
      print(error);
      return [
        false,
        {'error': 'Nie je možné pripojiť sa na server'}
      ];
    }

    var response;
    try {
      response = json.decode(tmp.body);
    } catch (_) {
      return [
        false,
        {'error': 'Nastala serverová chyba'}
      ];
    }
    if (tmp.statusCode == 200) {
      current_user = User(
          uuid: response['uuid'],
          email: response['email'],
          firstname: response['firstname'],
          lastname: response['lastname'],
          activated: response['activated'],
          admin: response['admin'],
          donations: response['donations'],
          picture: response['picture'],
          favourites: response['favourites'],
          created_at: DateTime.parse(response['created_at']),
          updated_at: DateTime.parse(response['updated_at']));
      return [true];
    } else {
      return [false, response];
    }
  }

  Future login(String email, String password) async {
    http.Response tmp;
    try {
      tmp = await http.post(Uri.http(API_URL, '/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'email': email, 'password': password}));
    } catch (error) {
      print(error);
      return [
        false,
        {'error': 'Nie je možné pripojiť sa na server'}
      ];
    }
    var response;
    try {
      response = json.decode(tmp.body);
    } catch (_) {
      return [
        false,
        {'error': 'Nastala serverová chyba'}
      ];
    }
    if (tmp.statusCode == 200) {
      _token = response['token'];
      _tokenType = response['token_type'];
      // Expire time without 5 seconds to have time to refresh token
      _expires =
          DateTime.now().add(Duration(seconds: (response['expires'] - 5)));
      _uuid = response['uuid'];
      _admin = response['admin'];

      var status = await getUser(_uuid);
      if (!status[0]) {
        return [false, status[1]];
      }

      _loggedIn = true;

      return [true];
    } else {
      return [false, response];
    }
  }

  Future signup(String firstname, String lastname, String email,
      String password, String picture) async {
    http.Response tmp;
    try {
      tmp = await http.post(Uri.http(API_URL, '/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'firstname': firstname,
            'lastname': lastname,
            'email': email,
            'password': password,
            'picture': picture
          }));
    } catch (error) {
      print(error);
      return [
        false,
        {'error': 'Nie je možné pripojiť sa na server'}
      ];
    }
    var response;
    if (tmp.contentLength > 0) {
      try {
        response = json.decode(tmp.body);
      } catch (_) {
        return [
          false,
          {'error': 'Nastala serverová chyba'}
        ];
      }
    }
    if (tmp.statusCode == 200) {
      return [true];
    } else {
      return [false, response];
    }
  }
}
