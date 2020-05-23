import 'dart:ui';

import 'package:flutter/material.dart';

class OkDialog extends StatelessWidget {
  final String message;

  OkDialog(this.message);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 5,
        sigmaY: 5,
      ),
      child: AlertDialog(
        title: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
            textColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
