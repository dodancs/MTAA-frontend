import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:CiliCat/models/Cat.dart';
import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';

class CatsProvider with ChangeNotifier {
  AuthProvider _auth;
  List<Cat> _cats;
  String _limit = '5';
  String _page = '1';

  List<Cat> get cats {
    return [..._cats];
  }

  Future getCats() async {
    _page = '1';
    _cats = List<Cat>();

    http.Response tmp;
    try {
      tmp = await http.get(
        Uri.http(
          API_URL,
          '/cats',
          {
            'limit': _limit,
            'page': _page,
          },
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
        {'error': 'Nastala serverová chyba'},
      ];
    }

    if (tmp.statusCode == 200 && response['cats'] != null) {
      for (dynamic cat in response['cats']) {
        _cats.add(
          Cat(
            uuid: cat['uuid'],
            name: cat['name'],
            age: cat['age'],
            sex: cat['sex'] ? Sex.female : Sex.male,
            description: cat['description'],
            adoptive: cat['adoptive'],
            pictures: List<String>.from(cat['pictures']),
          ),
        );
      }
    }
    notifyListeners();
  }

  Future<bool> moreCats() async {
    String newPage = (int.parse(_page) + 1).toString();

    http.Response tmp;
    try {
      tmp = await http.get(
        Uri.http(
          API_URL,
          '/cats',
          {
            'limit': _limit,
            'page': newPage,
          },
        ),
        headers: {
          'Authorization': _auth.getTokenType + ' ' + _auth.getToken,
        },
      );
    } catch (error) {
      print(error);
      notifyListeners();
      return false;
    }

    var response;
    try {
      response = json.decode(tmp.body);
    } catch (_) {
      notifyListeners();
      return false;
    }

    if (tmp.statusCode == 200 &&
        response['cats'] != null &&
        (response['cats'] as List).length > 0) {
      for (dynamic cat in response['cats']) {
        _cats.add(
          Cat(
            uuid: cat['uuid'],
            name: cat['name'],
            age: cat['age'],
            sex: cat['sex'] ? Sex.female : Sex.male,
            description: cat['description'],
            adoptive: cat['adoptive'],
            pictures: List<String>.from(cat['pictures']),
          ),
        );
      }
      _page = newPage;
      notifyListeners();
      return true;
    }

    notifyListeners();
    return false;
  }

  Future<Cat> catDetails(Cat cat) async {
    return cat;
  }

  void update(AuthProvider auth) async {
    if (!auth.isLoggedIn) {
      return;
    }
    _auth = auth;
    await getCats();
    notifyListeners();
  }
}
