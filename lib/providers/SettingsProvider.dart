import 'dart:convert';

import 'package:CiliCat/models/Breed.dart';
import 'package:CiliCat/models/Colour.dart';
import 'package:CiliCat/models/HealthStatus.dart';
import 'package:CiliCat/providers/StorageProvider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  StorageProvider _storage;
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
    List list = [];

    Map<String, dynamic> settings = await _storage.get('settings');

    if (_storage.connectivity == ConnectivityResult.none) {
      if (settings != null) {
        for (var s in settings[type]) {
          list.add(object(s['id'], s['name']));
        }
      }
      return list;
    }

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
      return list;
    }

    var response;
    try {
      response = json.decode(tmp.body);
    } catch (_) {
      return list;
    }

    if (tmp.statusCode == 200 && response[type] != null) {
      // fetch and store new settings
      if (settings == null) settings = {};
      settings[type] = response[type];
      await _storage.set('settings', settings);

      for (dynamic item in response[type]) {
        list.add(object(item['id'], item['name']));
      }
    }

    return list;
  }

  Future<void> refresh(String type) async {
    if (type == 'breeds')
      _breeds = List<Breed>.from(
          await getSettings('breeds', (id, name) => Breed(id: id, name: name)));
    if (type == 'colours')
      _colours = List<Colour>.from(await getSettings(
          'colours', (id, name) => Colour(id: id, name: name)));
    if (type == 'health_statuses')
      _healthStatuses = List<HealthStatus>.from(await getSettings(
          'health_statuses', (id, name) => HealthStatus(id: id, name: name)));
  }

  Future<dynamic> addSetting(String type, String name) async {
    if (_storage.connectivity == ConnectivityResult.none) {
      List l;
      if (type == 'breeds') l = _breeds;
      if (type == 'colours') l = _colours;
      if (type == 'health_statuses') l = _healthStatuses;

      int maxID = 0;
      for (dynamic i in l) {
        if (i.id > maxID) maxID = i.id;
        if (i.name == name) {
          if (type == 'breeds') return 'Dané plemeno už existuje!';
          if (type == 'colours') return 'Daná farba už existuje!';
          if (type == 'health_statuses')
            return 'Daný zdravotný stav už existuje!';
        }
      }

      await _storage.addSync([
        {
          'method': 'post',
          'endpoint': '/settings/' + type,
          'headers': {
            'Content-Type': 'application/json',
          },
          'data': {'name': name},
        },
      ]);

      dynamic settings = await _storage.get('settings');
      settings[type] = [
        ...List.from(settings[type]),
        {'id': maxID + 1, 'name': name}
      ];
      await _storage.set('settings', settings);

      await refresh(type);
      notifyListeners();
      return null;
    }

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
      dynamic settings = await _storage.get('settings');
      settings[type] = [
        ...List.from(settings[type]),
        {'id': response['id'], 'name': name}
      ];
      await _storage.set('settings', settings);
      await refresh(type);
      notifyListeners();
      return null;
    }

    return response['error'];
  }

  Future<void> deleteSetting(String type, int id) async {
    if (_storage.connectivity == ConnectivityResult.none) {
      String converted = type == 'breeds'
          ? breedFrom(id: id).name
          : type == 'colours'
              ? colourFrom(id: id).name
              : healthStatusFrom(id: id).name;

      if (await _storage.hasSync((item) {
        return item['method'] == 'post' &&
            item['endpoint'] == ('/settings/' + type) &&
            item['data']['name'] == converted;
      })) {
        await _storage.removeSync((item) {
          return item['method'] == 'post' &&
              item['endpoint'] == ('/settings/' + type) &&
              item['data']['name'] == converted;
        });
      } else {
        if (!await _storage.hasSync((e) =>
            e['method'] == 'delete' &&
            e['endpoint'] == '/settings/' + type + '/' + id.toString())) {
          await _storage.addSync([
            {
              'method': 'delete',
              'endpoint': '/settings/' + type + '/' + id.toString(),
              'headers': {},
              'data': {},
            },
          ]);
        }
      }

      dynamic settings = await _storage.get('settings');
      settings[type].removeWhere((e) => e['id'] == id);
      await _storage.set('settings', settings);

      await refresh(type);
      notifyListeners();
      return;
    }

    try {
      await http.delete(
          Uri.http(
            API_URL,
            '/settings/' + type + '/' + id.toString(),
          ),
          headers: {
            'Authorization': _auth.getTokenType + ' ' + _auth.getToken,
          });
    } catch (error) {
      print(error);
      return;
    }

    await refresh(type);

    notifyListeners();
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

  void update(StorageProvider storage, AuthProvider auth) async {
    _storage = storage;
    if (!auth.isLoggedIn) {
      return;
    }
    _auth = auth;

    await refresh('breeds');
    await refresh('colours');
    await refresh('health_statuses');

    notifyListeners();
  }
}
