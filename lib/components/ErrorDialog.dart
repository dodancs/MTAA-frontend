import 'package:CiliCat/components/Heading1.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String text;

  ErrorDialog(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: Heading1('Nastala chyba!'),
        content: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[Text(text)],
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
