import 'package:flutter/material.dart';
import 'package:CiliCat/settings.dart';

class ConfirmDialog extends StatelessWidget {
  final String message;

  ConfirmDialog(this.message);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: AlertDialog(
        title: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(bools[1]),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              bools[0],
              style: TextStyle(color: Colors.white),
            ),
            color: palette,
          ),
        ],
      ),
    );
  }
}
