import 'dart:convert';

import 'package:CiliCat/settings.dart';
import 'package:CiliCat/models/ShelterNeed.dart';
import 'package:http/http.dart' as http;
import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:flutter/material.dart';

class ShelterneedsProvider with ChangeNotifier {
  AuthProvider _auth;

  List<ShelterNeed> _needs;

  List<ShelterNeed> get needs {
    if (_needs == null) {
      return [];
    }
    return [..._needs];
  }

  Future getNeeds() async {
    _needs = List<ShelterNeed>();

    http.Response tmp;
    try {
      tmp = await http.get(
        Uri.http(
          API_URL,
          '/shelterneeds',
        ),
        headers: {
          'Authorization': _auth.getTokenType + ' ' + _auth.getToken,
        },
      );
    } catch (error) {
      print(error);
      return null;
    }

    var response;
    try {
      response = json.decode(tmp.body);
    } catch (_) {
      return [
        false,
        'Nastala serverová chyba',
      ];
    }

    if (tmp.statusCode == 200 && response['shelterneeds'] != null) {
      for (dynamic need in response['shelterneeds']) {
        _needs.add(
          ShelterNeed(
            uuid: need['uuid'],
            name: need['name'],
            category: need['category'],
            details: need['details'],
            hide: need['hide'],
          ),
        );
      }
    }

    notifyListeners();
  }

  Future toggle(String uuid) async {
    try {
      await http.post(
        Uri.http(
          API_URL,
          '/shelterneeds/' + uuid,
        ),
        headers: {
          'Authorization': _auth.getTokenType + ' ' + _auth.getToken,
        },
      );
    } catch (error) {
      print(error);
      return null;
    }

    await getNeeds();
  }

  Future add(String name, String category, String details) async {
    http.Response tmp;
    try {
      tmp = await http.post(
        Uri.http(
          API_URL,
          '/shelterneeds',
        ),
        headers: {
          'Authorization': _auth.getTokenType + ' ' + _auth.getToken,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'category': category,
          'details': details,
        }),
      );
    } catch (error) {
      print(error);
      return 'Nastala serverová chyba';
    }

    if (tmp.statusCode != 200) {
      var response;
      try {
        response = json.decode(tmp.body);
        return response['error'];
      } catch (_) {
        return 'Nastala serverová chyba';
      }
    }

    await getNeeds();

    return null;
  }

  Future delete(String uuid) async {
    http.Response tmp;
    try {
      tmp = await http.delete(
        Uri.http(
          API_URL,
          '/shelterneeds/' + uuid,
        ),
        headers: {
          'Authorization': _auth.getTokenType + ' ' + _auth.getToken,
        },
      );
    } catch (error) {
      print(error);
      return 'Nastala serverová chyba';
    }

    if (tmp.statusCode != 200) {
      var response;
      try {
        response = json.decode(tmp.body);
        return response['error'];
      } catch (_) {
        return 'Nastala serverová chyba';
      }
    }

    await getNeeds();

    return null;
  }

  void update(AuthProvider auth) async {
    if (!auth.isLoggedIn) {
      return;
    }
    _auth = auth;

    await getNeeds();
  }
}
