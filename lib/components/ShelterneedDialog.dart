import 'dart:ui';

import 'package:CiliCat/components/Heading1.dart';
import 'package:CiliCat/helpers.dart';
import 'package:flutter/material.dart';

class ShelterneedDialog extends StatefulWidget {
  final Function save;

  ShelterneedDialog(this.save);

  @override
  _ShelterneedDialogState createState() => _ShelterneedDialogState();
}

class _ShelterneedDialogState extends State<ShelterneedDialog> {
  final _form = GlobalKey<FormState>();

  String _name;
  String _details;
  String _category;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 5,
        sigmaY: 5,
      ),
      child: Container(
        child: AlertDialog(
          title: Heading1('Prianie potreby útulku'),
          content: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Názov',
                    ),
                    validator: (value) => commonValidation(value),
                    onSaved: (val) => (_name = val),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Kategória',
                    ),
                    validator: (value) => commonValidation(value),
                    onSaved: (val) => (_category = val),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Popis',
                    ),
                    maxLines: 3,
                    validator: (value) => commonValidation(value),
                    onSaved: (val) => (_details = val),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () async {
                if (_form.currentState.validate()) {
                  _form.currentState.save();
                  await widget.save(_name, _category, _details);
                  Navigator.of(context).pop();
                }
              },
              textColor: Theme.of(context).primaryColor,
              child: const Text('Pridať'),
            ),
          ],
        ),
      ),
    );
  }
}
