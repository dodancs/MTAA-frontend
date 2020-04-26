import 'dart:async';
import 'dart:convert';

import 'package:CiliCat/models/User.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  String _tokenType;
  DateTime _expires;
  String _uuid;
  bool _admin = false;
  User _current_user;
  bool _loggedIn = false;
  Timer _tokenTimer;

  bool _isLoggedIn() {
    return _loggedIn &&
        _token != null &&
        _expires != null &&
        _expires.isAfter(DateTime.now());
  }

  bool get isLoggedIn {
    return _isLoggedIn();
  }

  bool get isAdmin {
    if (_isLoggedIn() && _admin) {
      return true;
    }
    return false;
  }

  User get getCurrentUser {
    if (_isLoggedIn()) {
      return _current_user;
    }
    return null;
  }

  String get getToken {
    if (_isLoggedIn()) {
      return _token;
    } else {
      return null;
    }
  }

  String get getTokenType {
    return _tokenType;
  }

  Future getUser(String uuid) async {
    http.Response tmp;
    try {
      tmp = await http.get(
        Uri.http(API_URL, '/auth/users/' + uuid),
        headers: {
          'Authorization': _tokenType + ' ' + _token,
        },
      );
    } catch (error) {
      print(error);
      return [
        false,
        {'error': 'Nie je možné pripojiť sa na server'},
      ];
    }

    var response;
    try {
      response = json.decode(tmp.body);
    } catch (_) {
      return [
        false,
        {'error': 'Nastala serverová chyba'},
      ];
    }
    if (tmp.statusCode == 200) {
      _admin = response['admin'];
      _current_user = User(
        uuid: response['uuid'],
        email: response['email'],
        firstname: response['firstname'],
        lastname: response['lastname'],
        activated: response['activated'],
        admin: response['admin'],
        donations: response['donations'].toDouble(),
        picture: response['picture'],
        favourites: List<String>.from(response['favourites']),
        created_at: DateTime.parse(response['created_at']),
        updated_at: DateTime.parse(response['updated_at']),
      );
      return [true];
    } else {
      return [
        false,
        response,
      ];
    }
  }

  Future loginWith(String tT, String t, int ex, String u) async {
    _token = t;
    _tokenType = tT;
    // Expire time without 5 seconds to have time to refresh token
    _expires = DateTime.now().add(Duration(seconds: (ex - 5)));
    _uuid = u;

    var status = await getUser(_uuid);
    if (!status[0]) {
      return [false, status[1]];
    }

    _admin = _current_user.admin;
    _loggedIn = true;

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      'auth',
      json.encode({
        'token': _token,
        'tokenType': _tokenType,
        'expires': _expires.toIso8601String(),
        ..._current_user.toJson(),
      }),
    );

    return [true];
  }

  Future login(String email, String password) async {
    http.Response tmp;
    try {
      tmp = await http.post(
        Uri.http(API_URL, '/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'email': email,
            'password': password,
          },
        ),
      );
    } catch (error) {
      print(error);
      return [
        false,
        {'error': 'Nie je možné pripojiť sa na server'},
      ];
    }
    var response;
    try {
      response = json.decode(tmp.body);
    } catch (_) {
      return [
        false,
        {'error': 'Nastala serverová chyba'},
      ];
    }
    if (tmp.statusCode == 200) {
      var res = await loginWith(response['token_type'], response['token'],
          response['expires'], response['uuid']);

      if (!res[0]) {
        return res;
      }

      _refreshToken();
      notifyListeners();

      return [true];
    } else {
      return [false, response];
    }
  }

  Future signup(String firstname, String lastname, String email,
      String password, String picture) async {
    http.Response tmp;
    try {
      tmp = await http.post(
        Uri.http(API_URL, '/auth/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'firstname': firstname,
            'lastname': lastname,
            'email': email,
            'password': password,
            'picture': picture,
          },
        ),
      );
    } catch (error) {
      print(error);
      return [
        false,
        {'error': 'Nie je možné pripojiť sa na server'}
      ];
    }
    var response;
    if (tmp.statusCode == 200) {
      return [true];
    } else {
      try {
        response = json.decode(tmp.body);
      } catch (_) {
        return [
          false,
          {'error': 'Nastala serverová chyba'},
        ];
      }
      return [
        false,
        response,
      ];
    }
  }

  Future edit(String key, String value) async {
    http.Response tmp;
    try {
      tmp = await http.put(
        Uri.http(API_URL, '/auth/users/' + _current_user.uuid),
        headers: {
          'Authorization': _tokenType + ' ' + _token,
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            key: value,
          },
        ),
      );
    } catch (error) {
      print(error);
      return 'Nie je možné pripojiť sa na server';
    }
    var response;
    if (tmp.statusCode == 200) {
      await refreshUser();
      return null;
    } else {
      try {
        response = json.decode(tmp.body);
      } catch (_) {
        return 'Nastala serverová chyba';
      }
      return response['error'];
    }
  }

  Future<void> logout() async {
    _token = null;
    _tokenType = null;
    _expires = null;
    _uuid = null;
    _admin = false;
    _current_user = null;
    _loggedIn = false;
    if (_tokenTimer != null) {
      _tokenTimer.cancel();
      _tokenTimer = null;
    }

    try {
      await http.get(
        Uri.http(API_URL, '/auth/logout'),
        headers: {
          'Authorization': _tokenType + ' ' + _token,
        },
      );
    } catch (error) {
      print(error);
    }

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('auth', null);
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey('auth')) {
      return false;
    }
    final data = json.decode(preferences.getString('auth'));
    if (DateTime.parse(data['expires']).isBefore(DateTime.now())) {
      return false;
    }

    // If not connected to internet, use local data, else reload user data from internet
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      _token = data['token'];
      _tokenType = data['tokenType'];
      _expires = DateTime.parse(data['expires']);
      _current_user = User.fromJson(data);
      _admin = _current_user.admin;
      _loggedIn = true;
    } else {
      var res = await loginWith(
        data['tokenType'],
        data['token'],
        5,
        User.fromJson(data).uuid,
      );

      if (!res[0]) {
        await logout();
      }
    }

    _refreshToken();
    notifyListeners();
    return true;
  }

  void _refreshToken() {
    if (_tokenTimer != null) {
      _tokenTimer.cancel();
    }
    final expires = _expires.difference(DateTime.now()).inSeconds;
    _tokenTimer = Timer(
      Duration(seconds: expires),
      () async {
        http.Response tmp;
        try {
          tmp = await http.get(
            Uri.http(API_URL, '/auth/refresh_token'),
            headers: {
              'Authorization': _tokenType + ' ' + _token,
            },
          );
        } catch (error) {
          print(error);
          await logout();
        }
        var response;
        try {
          response = json.decode(tmp.body);
        } catch (_) {
          await logout();
        }
        if (tmp.statusCode == 200) {
          await loginWith(response['token_type'], response['token'],
              response['expires'], response['uuid']);

          _refreshToken();
          notifyListeners();
        } else {
          await logout();
        }
      },
    );
  }

  Future<void> refreshUser() async {
    await getUser(_uuid);
  }
}
