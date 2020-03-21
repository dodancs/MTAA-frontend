import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:CiliCat/models/Cat.dart';
import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';

class CatsProvider with ChangeNotifier {
  List<Cat> _cats;

  List<Cat> get cats {
    return [..._cats];
  }

  Future getCats(AuthProvider auth) async {
    _cats = List<Cat>();

    http.Response tmp;
    try {
      tmp = await http.get(
        Uri.http(API_URL, '/cats'),
        headers: {'Authorization': auth.getTokenType + ' ' + auth.getToken},
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

    if (tmp.statusCode == 200) {
      for (dynamic cat in response['cats']) {
        if (cat != null) {
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
    }
  }

  Future<Cat> catDetails(Cat cat) async {
    return cat;
  }

  void update(AuthProvider auth) async {
    if (!auth.isLoggedIn) {
      return;
    }
    await getCats(auth);
    notifyListeners();
  }
}
