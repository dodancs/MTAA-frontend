import 'package:CiliCat/components/Heading1.dart';
import 'package:flutter/material.dart';

class ConfirmEmailDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: Heading1('Registrácia prebehla úspešne!'),
        content: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                'Prosím potvrďte svoju e-mailovú adresu pomocou odkazu, ktorý Vám bol odoslaný.'),
            SizedBox(
              height: 10,
            ),
            Text('Následne sa môžete prihlásiť!'),
          ],
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
