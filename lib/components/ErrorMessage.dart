import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String _text;
  final bool _display;

  ErrorMessage(this._text, this._display);

  @override
  Widget build(BuildContext context) {
    return _display
        ? Column(
            children: <Widget>[
              SizedBox(height: 10),
              Text(
                _text,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 13,
                ),
              ),
            ],
          )
        : Container();
  }
}
