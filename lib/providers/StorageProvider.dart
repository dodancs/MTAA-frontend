import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:CiliCat/settings.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:json_store/json_store.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StorageProvider with ChangeNotifier {
  JsonStore _preferences;
  ConnectivityResult connectivity;
  bool _needSync = false;

  StorageProvider() {
    _init();
  }

  bool get needSync {
    return _needSync;
  }

  Future<void> _init() async {
    _preferences = JsonStore();
    Connectivity().onConnectivityChanged.listen(_connectionChanged);
    connectivity = await Connectivity().checkConnectivity();
    updateNeedSync();
    notifyListeners();
  }

  Future<void> updateNeedSync() async {
    Map<String, dynamic> toSync = await get('sync');
    _needSync = (connectivity == ConnectivityResult.mobile ||
            connectivity == ConnectivityResult.wifi) &&
        toSync != null &&
        toSync['requests'].length > 0;
  }

  Future<void> _connectionChanged(ConnectivityResult result) async {
    connectivity = result;
    updateNeedSync();
    notifyListeners();
  }

  Future<dynamic> doRequest(
      AuthProvider auth, Map<String, dynamic> request) async {
    http.Response tmp;
    try {
      switch (request['method']) {
        case 'get':
          tmp = await http.get(
            Uri.http(
              API_URL,
              request['endpoint'],
            ).toString(),
            headers: {
              'Authorization': auth.getTokenType + ' ' + auth.getToken,
            }..addAll(Map<String, String>.from(request['headers'])),
          );
          break;
        case 'post':
          tmp = await http.post(
            Uri.http(
              API_URL,
              request['endpoint'],
            ).toString(),
            headers: {
              'Authorization': auth.getTokenType + ' ' + auth.getToken,
            }..addAll(Map<String, String>.from(request['headers'])),
            body: json.encode(request['data']),
          );
          break;
        case 'put':
          tmp = await http.put(
            Uri.http(
              API_URL,
              request['endpoint'],
            ).toString(),
            headers: {
              'Authorization': auth.getTokenType + ' ' + auth.getToken,
            }..addAll(Map<String, String>.from(request['headers'])),
            body: json.encode(request['data']),
          );
          break;
        case 'delete':
          tmp = await http.delete(
            Uri.http(
              API_URL,
              request['endpoint'],
            ).toString(),
            headers: {
              'Authorization': auth.getTokenType + ' ' + auth.getToken,
            }..addAll(Map<String, String>.from(request['headers'])),
          );
          break;
      }
      if (tmp.statusCode == 200) {
        return null;
      } else {
        var response;
        try {
          response = json.decode(tmp.body);
          return 'Chyba: ' + response['error'];
        } catch (_) {
          return 'Chyba: Nastala serverová chyba';
        }
      }
    } catch (error) {
      print(error);
      return 'Chyba: Nie je možné pripojiť sa na server';
    }
  }

  Future<void> doSync(AuthProvider auth, Function update) async {
    Map<String, dynamic> toSync = await get('sync');
    bool success = true;
    if (toSync != null && toSync['requests'].length > 0) {
      double progress = 0;
      String action = '';
      for (dynamic r in toSync['requests']) {
        action = 'Sync: ' + r['method'] + ' ' + r['endpoint'];
        update({
          'progress': progress,
          'action': action,
          'error': null,
        });
        dynamic res = await doRequest(auth, r);
        progress += 1 / toSync['requests'].length;
        update({
          'progress': progress,
          'action': action,
          'error': res,
        });
        if (res != null) {
          success = false;
          break;
        }
      }
      if (success) {
        removeSync((_) => true, notify: true);
      }
    }
  }

  Future<void> set(String key, Map<String, dynamic> data) async {
    if (_preferences == null) {
      return;
    }

    // print('[STORAGE] Setting ' + key + ':' + data.toString());

    await _preferences.setItem(key, data);
  }

  Future<Map<String, dynamic>> get(String key) async {
    if (_preferences == null) {
      return null;
    }

    dynamic res = await _preferences.getItem(key);

    // print('[STORAGE] Getting ' + key + ':' + res.toString());

    return res;
  }

  Future<void> delete(String key) async {
    if (_preferences == null) {
      return;
    }

    await _preferences.deleteItem(key);
  }

  Future<void> addSync(List<Map<String, dynamic>> requests) async {
    if (_preferences == null) {
      return;
    }

    Map<String, dynamic> toSync = await get('sync');

    /* {
        method: "post",
        endpoint: "/canaries",
        headers: {},
        data: {dsadas}
      }*/

    if (toSync == null) {
      toSync = {};
    }
    if (toSync['requests'] == null) {
      toSync['requests'] = [];
    }

    toSync['requests'] = [...List.from(toSync['requests']), ...requests];

    print(toSync);

    await set('sync', toSync);

    updateNeedSync();
  }

  Future<bool> hasSync(Function condition) async {
    if (_preferences == null) {
      return false;
    }

    Map<String, dynamic> toSync = await get('sync');
    if (toSync == null) {
      return false;
    }

    return toSync['requests'].indexWhere(condition) > -1 ? true : false;
  }

  Future<void> removeSync(Function condition, {bool notify}) async {
    if (_preferences == null) {
      return;
    }

    Map<String, dynamic> toSync = await get('sync');
    if (toSync == null) {
      return;
    }

    toSync['requests'].removeWhere(condition);

    print(toSync);

    await set('sync', toSync);

    if (notify == true) {
      await updateNeedSync();
      notifyListeners();
    }
  }
}
