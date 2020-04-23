import 'dart:ui';

import 'package:CiliCat/components/Heading1.dart';
import 'package:flutter/material.dart';

class TextInputDialog extends StatefulWidget {
  final String title;
  final Function validate;
  final Function save;

  TextInputDialog(
    this.title, {
    this.validate,
    this.save,
  });

  @override
  _TextInputDialogState createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  final _form = GlobalKey<FormState>();

  String _value;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 5,
        sigmaY: 5,
      ),
      child: Container(
        child: AlertDialog(
          title: Heading1(widget.title),
          content: Form(
            key: _form,
            child: TextFormField(
              validator: widget.validate,
              onSaved: (val) => (_value = val),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () async {
                if (_form.currentState.validate()) {
                  _form.currentState.save();
                  await widget.save(_value);
                  Navigator.of(context).pop();
                }
              },
              textColor: Theme.of(context).primaryColor,
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
