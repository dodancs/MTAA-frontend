import 'dart:convert';

import 'package:CiliCat/models/Breed.dart';
import 'package:CiliCat/models/Colour.dart';
import 'package:CiliCat/models/HealthStatus.dart';
import 'package:http/http.dart' as http;
import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  AuthProvider _auth;
  List<Breed> _breeds;
  List<Colour> _colours;
  List<HealthStatus> _healthStatuses;

  List<Breed> get breeds {
    if (_breeds == null) {
      return [];
    }
    return [..._breeds];
  }

  List<Colour> get colours {
    if (_colours == null) {
      return [];
    }
    return [..._colours];
  }

  List<HealthStatus> get healthStatuses {
    if (_healthStatuses == null) {
      return [];
    }
    return [..._healthStatuses];
  }

  Future<List> getSettings(
      String type, Function(int id, String name) object) async {
    List list = List();

    http.Response tmp;
    try {
      tmp = await http.get(
        Uri.http(
          API_URL,
          '/settings/' + type,
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
      return list;
    }

    if (tmp.statusCode == 200 && response[type] != null) {
      for (dynamic item in response[type]) {
        list.add(object(item['id'], item['name']));
      }
    }

    return list;
  }

  Future addSetting(String type, String name) async {
    http.Response tmp;
    try {
      tmp = await http.post(
        Uri.http(
          API_URL,
          '/settings/' + type,
        ),
        headers: {
          'Authorization': _auth.getTokenType + ' ' + _auth.getToken,
          'Content-Type': 'application/json',
        },
        body: json.encode({'name': name}),
      );
    } catch (error) {
      print(error);
      return 'Nastala serverová chyba';
    }

    var response;
    try {
      response = json.decode(tmp.body);
    } catch (error) {
      print(error);
      return 'Nastala serverová chyba';
    }

    if (tmp.statusCode == 200 && response['id'] != null) {
      if (type == 'breeds') _breeds.add(Breed(id: response['id'], name: name));
      if (type == 'colours')
        _colours.add(Colour(id: response['id'], name: name));
      if (type == 'health_statuses')
        _healthStatuses.add(HealthStatus(id: response['id'], name: name));

      notifyListeners();
      return null;
    }

    return response['error'];
  }

  Breed breedFrom({final int id, final String name}) {
    if (_breeds == null) return null;

    if (id != null)
      return _breeds.firstWhere((b) {
        return b.id == id;
      }, orElse: () => null);

    if (name != null)
      return _breeds.firstWhere((b) {
        return b.name == name;
      }, orElse: () => null);

    return null;
  }

  Colour colourFrom({final int id, final String name}) {
    if (_colours == null) return null;

    if (id != null)
      return _colours.firstWhere((c) {
        return c.id == id;
      }, orElse: () => null);

    if (name != null)
      return _colours.firstWhere((c) {
        return c.name == name;
      }, orElse: () => null);

    return null;
  }

  HealthStatus healthStatusFrom({final int id, final String name}) {
    if (_healthStatuses == null) return null;

    if (id != null)
      return _healthStatuses.firstWhere((h) {
        return h.id == id;
      }, orElse: () => null);

    if (name != null)
      return _healthStatuses.firstWhere((h) {
        return h.name == name;
      }, orElse: () => null);

    return null;
  }

  void update(AuthProvider auth) async {
    if (!auth.isLoggedIn) {
      return;
    }
    _auth = auth;
    _breeds = List<Breed>.from(
        await getSettings('breeds', (id, name) => Breed(id: id, name: name)));
    _colours = List<Colour>.from(
        await getSettings('colours', (id, name) => Colour(id: id, name: name)));
    _healthStatuses = List<HealthStatus>.from(await getSettings(
        'health_statuses', (id, name) => HealthStatus(id: id, name: name)));
    notifyListeners();
  }
}
