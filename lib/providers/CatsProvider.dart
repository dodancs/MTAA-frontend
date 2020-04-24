import 'dart:convert';

import 'package:CiliCat/providers/SettingsProvider.dart';
import 'package:http/http.dart' as http;
import 'package:CiliCat/models/Cat.dart';
import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';

class CatsProvider with ChangeNotifier {
  AuthProvider _auth;
  SettingsProvider _settings;
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
            sex: cat['sex'],
            description: cat['description'],
            adoptive: cat['adoptive'],
            pictures: List<String>.from(cat['pictures']),
            commentsNum: cat['comments'],
            breed: _settings.breedFrom(id: cat['breed']),
            colour: _settings.colourFrom(id: cat['colour']),
            health_status: _settings.healthStatusFrom(id: cat['health_status']),
            castrated: cat['castrated'],
            vaccinated: cat['vaccinated'],
            dewormed: cat['dewormed'],
            health_log: cat['health_log'],
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
            sex: cat['sex'],
            description: cat['description'],
            adoptive: cat['adoptive'],
            pictures: List<String>.from(cat['pictures']),
            commentsNum: cat['comments'],
            breed: _settings.breedFrom(id: cat['breed']),
            colour: _settings.colourFrom(id: cat['colour']),
            health_status: _settings.healthStatusFrom(id: cat['health_status']),
            castrated: cat['castrated'],
            vaccinated: cat['vaccinated'],
            dewormed: cat['dewormed'],
            health_log: cat['health_log'],
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

  Cat catDetails(String uuid) {
    if (_cats == null) return null;

    return _cats.firstWhere((cat) {
      return cat.uuid == uuid;
    }, orElse: () => null);
  }

  Future delete(String uuid) async {
    http.Response tmp;
    try {
      tmp = await http.delete(
        Uri.http(
          API_URL,
          '/cats/' + uuid + '/',
        ),
        headers: {
          'Authorization': _auth.getTokenType + ' ' + _auth.getToken,
        },
      );
    } catch (error) {
      print(error);
      return 'Nastala serverová chyba';
    }

    var response;
    try {
      response = json.decode(tmp.body);
    } catch (_) {
      return 'Nastala serverová chyba';
    }

    if (tmp.statusCode == 401 && response['error'] != null)
      return response['error'];

    _cats.removeWhere((c) => c.uuid == uuid);

    notifyListeners();
    return null;
  }

  Future add(Cat cat) async {
    http.Response tmp;
    try {
      tmp = await http.post(
        Uri.http(
          API_URL,
          '/cats',
        ),
        headers: {
          'Authorization': _auth.getTokenType + ' ' + _auth.getToken,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': cat.name,
          'age': cat.age,
          'sex': cat.sex,
          'description': cat.description,
          'adoptive': cat.adoptive,
          'pictures': cat.pictures,
          'breed': cat.breed.id,
          'colour': cat.colour.id,
          'health_status': cat.health_status.id,
          'castrated': cat.castrated,
          'vaccinated': cat.vaccinated,
          'dewormed': cat.dewormed,
          'health_log': cat.health_log,
        }),
      );
    } catch (error) {
      print(error);
      return [
        false,
        {'error': 'Nastala serverová chyba'},
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

    if (tmp.statusCode == 200 && response['uuid'] != null) {
      cat.uuid = response['uuid'];
      _cats.add(cat);
      notifyListeners();
      return [
        true,
        cat.uuid,
      ];
    } else if (tmp.statusCode == 401 && response['error'] != null)
      return [
        false,
        {'error': response['error']},
      ];
    else
      return [
        false,
        {'error': 'Nastala serverová chyba'},
      ];
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

  Future change(Map<String, dynamic> changes, String uuid) async {
    try {
      http.Response tmp = await http.put(
        Uri.http(
          API_URL,
          '/cats/' + uuid,
        ),
        headers: {
          'Authorization': _auth.getTokenType + ' ' + _auth.getToken,
          'Content-Type': 'application/json',
        },
        body: json.encode(changes),
      );

      if (tmp.statusCode != 200) {
        try {
          var response = json.decode(tmp.body);
          return response['error'];
        } catch (_) {
          return 'Nastala serverová chyba';
        }
      }
    } catch (error) {
      print(error);
      return 'Nastala serverová chyba';
    }

    await getCats();

    return null;
  }

  void update(AuthProvider auth, SettingsProvider settings) async {
    if (!auth.isLoggedIn) {
      return;
    }
    _auth = auth;
    _settings = settings;
    await getCats();
  }
}
