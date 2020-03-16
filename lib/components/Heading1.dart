import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';

class Heading1 extends StatelessWidget {
  final String text;

  Heading1(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20, top: 20),
      child: Text(
        this.text.toUpperCase(),
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: palette[500]),
      ),
    );
  }
}
