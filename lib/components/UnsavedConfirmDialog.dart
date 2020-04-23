import 'package:flutter/material.dart';
import 'package:CiliCat/settings.dart';

class UnsavedConfirmDialog extends StatelessWidget {
  const UnsavedConfirmDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: AlertDialog(
        title: Text('Zmeny neboli uložené!\nNaozaj si prajete odísť?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Áno'),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Nie',
              style: TextStyle(color: Colors.white),
            ),
            color: palette,
          ),
        ],
      ),
    );
  }
}
