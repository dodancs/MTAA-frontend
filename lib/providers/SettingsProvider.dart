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

  int breedIdFromName(String name) {
    if (_breeds == null) return null;
    int id;
    _breeds.forEach((b) {
      if (b.name == name) id = b.id;
    });
    return id;
  }

  int colourIdFromName(String name) {
    if (_colours == null) return null;
    int id;
    _colours.forEach((c) {
      if (c.name == name) id = c.id;
    });
    return id;
  }

  int healthStatusIdFromName(String name) {
    if (_healthStatuses == null) return null;
    int id;
    _healthStatuses.forEach((h) {
      if (h.name == name) id = h.id;
    });
    return id;
  }

  String breedNameFromId(int id) {
    if (_breeds == null) return null;
    String name;
    _breeds.forEach((b) {
      if (b.id == id) name = b.name;
    });
    return name;
  }

  Breed breedFromId(int id) {
    if (_breeds == null) return null;
    Breed breed;
    _breeds.forEach((b) {
      if (b.id == id) breed = b;
    });
    return breed;
  }

  String colourNameFromId(int id) {
    if (_colours == null) return null;
    String name;
    _colours.forEach((c) {
      if (c.id == id) name = c.name;
    });
    return name;
  }

  Colour colourFromId(int id) {
    if (_colours == null) return null;
    Colour colour;
    _colours.forEach((c) {
      if (c.id == id) colour = c;
    });
    return colour;
  }

  String healthStatusNameFromId(int id) {
    if (_healthStatuses == null) return null;
    String status;
    _healthStatuses.forEach((h) {
      if (h.id == id) status = h.name;
    });
    return status;
  }

  HealthStatus healthStatusFromId(int id) {
    if (_healthStatuses == null) return null;
    HealthStatus status;
    _healthStatuses.forEach((h) {
      if (h.id == id) status = h;
    });
    return status;
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
