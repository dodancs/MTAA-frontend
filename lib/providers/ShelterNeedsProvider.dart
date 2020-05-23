import 'dart:convert';

import 'package:CiliCat/providers/StorageProvider.dart';
import 'package:CiliCat/settings.dart';
import 'package:CiliCat/models/ShelterNeed.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ShelterneedsProvider with ChangeNotifier {
  StorageProvider _storage;
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

    Map<String, dynamic> needs = await _storage.get('needs');

    if (_storage.connectivity == ConnectivityResult.none) {
      if (needs != null) {
        for (var n in needs['needs']) {
          _needs.add(ShelterNeed(
            uuid: n['uuid'],
            name: n['name'],
            category: n['category'],
            details: n['details'],
            hide: n['hide'],
          ));
        }
      }
      notifyListeners();
      return;
    }

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
      if (needs == null) needs = {};
      needs['needs'] = response['shelterneeds'];
      await _storage.set('needs', needs);

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
    if (_storage.connectivity == ConnectivityResult.none) {
      if (await _storage.hasSync((item) =>
          item['method'] == 'post' &&
          item['endpoint'] == '/shelterneeds/' + uuid)) {
        await _storage.removeSync((item) =>
            item['method'] == 'post' &&
            item['endpoint'] == '/shelterneeds/' + uuid);
      } else {
        await _storage.addSync([
          {
            'method': 'post',
            'endpoint': '/shelterneeds/' + uuid,
            'headers': {},
            'data': {},
          }
        ]);
      }
      dynamic needs = await _storage.get('needs');
      for (dynamic n in needs['needs']) {
        if (n['uuid'] == uuid) {
          n['hide'] = !n['hide'];
          break;
        }
      }
      await _storage.set('needs', needs);
      await getNeeds();
      return;
    }

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
    if (_storage.connectivity == ConnectivityResult.none) {
      String uuid = Uuid().v4();
      await _storage.addSync([
        {
          'method': 'post',
          'endpoint': '/shelterneeds',
          'headers': {
            'Content-Type': 'application/json',
          },
          'data': {
            'name': name,
            'category': category,
            'details': details,
            'uuid': uuid,
          },
        },
      ]);

      dynamic needs = await _storage.get('needs');
      if (needs['needs'] == null) needs['needs'] = [];
      needs['needs'].add({
        'name': name,
        'category': category,
        'details': details,
        'uuid': uuid,
        'hide': false,
      });
      await _storage.set('needs', needs);
      await getNeeds();
      return null;
    }

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

    return;
  }

  Future delete(String uuid) async {
    if (_storage.connectivity == ConnectivityResult.none) {
      if (await _storage.hasSync((item) =>
          item['method'] == 'post' &&
          item['endpoint'] == '/shelterneeds' &&
          item['data']['uuid'] == uuid)) {
        await _storage.removeSync((item) =>
            item['method'] == 'post' &&
            item['endpoint'] == '/shelterneeds' &&
            item['data']['uuid'] == uuid);
      } else {
        if (!await _storage.hasSync((e) =>
            e['method'] == 'delete' &&
            e['endpoint'] == '/shelterneeds/' + uuid)) {
          await _storage.addSync([
            {
              'method': 'delete',
              'endpoint': '/shelterneeds/' + uuid,
              'headers': {},
              'data': {},
            },
          ]);
        }
      }

      dynamic needs = await _storage.get('needs');
      needs['needs'].removeWhere((e) => e['uuid'] == uuid);
      await _storage.set('needs', needs);
      await getNeeds();
      return;
    }

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

  void update(StorageProvider storage, AuthProvider auth) async {
    _storage = storage;
    if (!auth.isLoggedIn) {
      return;
    }
    _auth = auth;

    await getNeeds();
  }
}
