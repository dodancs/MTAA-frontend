import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';

class PicturesProvider with ChangeNotifier {
  AuthProvider _auth;

  Future add(File file) async {
    if (file == null) return null;

    if (!file.existsSync()) return null;

    String mimeType = mime(file.path);
    if (mimeType == null) mimeType = 'text/plain';

    try {
      var res = await Dio().post(
        Uri.http(
          API_URL,
          '/pictures',
        ).toString(),
        data: file.openRead(),
        options: Options(
          contentType: mimeType,
          headers: {
            'Content-Length': file.lengthSync(),
            'Authorization': _auth.getTokenType + ' ' + _auth.getToken,
          },
        ),
      );

      if (res.statusCode == 200) {
        return [
          true,
          res.data['uuid'],
        ];
      }
    } catch (error) {
      if (error.response != null) {
        return [
          false,
          error.response['error'],
        ];
      }
    }
  }

  Future remove(String uuid) async {
    http.Response tmp;
    try {
      tmp = await http.delete(
        Uri.http(
          API_URL,
          '/pictures/' + uuid,
        ),
        headers: {
          'Authorization': _auth.getTokenType + ' ' + _auth.getToken,
        },
      );
    } catch (error) {
      print(error);
      return 'Nastala serverová chyba';
    }

    return null;
  }

  void update(AuthProvider auth) async {
    if (!auth.isLoggedIn) {
      return;
    }
    _auth = auth;
    notifyListeners();
  }
}
