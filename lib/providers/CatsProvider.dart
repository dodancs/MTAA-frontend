import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:CiliCat/models/Cat.dart';
import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';

class CatsProvider with ChangeNotifier {
  AuthProvider _auth;
  List<Cat> _cats;
  int _limit = 5;
  int _page = 1;

  bool filter_adoptive = true;
  bool filter_sex = null;
  int filter_breed = null;
  int filter_health_status = null;
  int filter_age_up = 240;
  int filter_age_down = 0;
  int filter_colour = null;
  bool filter_castrated = null;
  bool filter_vaccinated = null;
  bool filter_dewormed = null;

  Map<String, String> filter({int page}) {
    return {
      'limit': _limit.toString(),
      'page': page == null ? _page.toString() : page.toString(),
      'adoptive': filter_adoptive.toString(),
      'sex': filter_sex.toString(),
      'breed': filter_breed.toString(),
      'health_status': filter_health_status.toString(),
      'age_up': filter_age_up.toString(),
      'age_down': filter_age_down.toString(),
      'colour': filter_colour.toString(),
      'castrated': filter_castrated.toString(),
      'vaccinated': filter_vaccinated.toString(),
      'dewormed': filter_dewormed.toString(),
    };
  }

  Future<void> setFilter({
    String filter,
    dynamic value,
    Map<String, dynamic> map,
  }) async {
    if (filter != null && value != null) {
      map = {filter: value};
    }

    map.forEach((k, v) {
      switch (k) {
        case 'adoptive':
          filter_adoptive = v;
          break;
        case 'sex':
          filter_sex = v;
          break;
        case 'breed':
          filter_breed = v;
          break;
        case 'health_status':
          filter_health_status = v;
          break;
        case 'age_up':
          filter_age_up = v;
          break;
        case 'age_down':
          filter_age_down = v;
          break;
        case 'colour':
          filter_colour = v;
          break;
        case 'castrated':
          filter_castrated = v;
          break;
        case 'vaccinated':
          filter_vaccinated = v;
          break;
        case 'dewormed':
          filter_dewormed = v;
          break;
      }
    });

    await getCats();
  }

  List<Cat> get cats {
    if (_cats == null) {
      return [];
    }
    return [..._cats];
  }

  Future getCats() async {
    _page = 1;
    _cats = List<Cat>();

    http.Response tmp;
    try {
      tmp = await http.get(
        Uri.http(
          API_URL,
          '/cats',
          filter(),
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
            sex: cat['sex'] ? sexes[0] : sexes[1],
            description: cat['description'],
            adoptive: cat['adoptive'],
            pictures: List<String>.from(cat['pictures']),
            commentsNum: cat['comments'],
          ),
        );
      }
    }
    notifyListeners();
  }

  Future<bool> moreCats() async {
    int newPage = _page + 1;

    http.Response tmp;
    try {
      tmp = await http.get(
        Uri.http(
          API_URL,
          '/cats',
          filter(page: newPage),
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
            sex: cat['sex'] ? sexes[0] : sexes[1],
            description: cat['description'],
            adoptive: cat['adoptive'],
            pictures: List<String>.from(cat['pictures']),
            commentsNum: cat['comments'],
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

  Future<void> like(Cat cat, bool liked) async {
    String request = '/cats/' + cat.uuid + '/';
    if (liked) {
      request += 'unlike';
    } else {
      request += 'like';
    }
    try {
      http.Response tmp = await http.post(
        Uri.http(
          API_URL,
          request,
        ),
        headers: {
          'Authorization': _auth.getTokenType + ' ' + _auth.getToken,
        },
      );
    } catch (error) {
      print(error);
    }
    await _auth.refreshUser();
    notifyListeners();
  }

  void update(AuthProvider auth) async {
    if (!auth.isLoggedIn) {
      return;
    }
    _auth = auth;
    await getCats();
  }
}
