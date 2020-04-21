import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';

class Heading2 extends StatelessWidget {
  final String text;
  final Color color;

  Heading2(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20, top: 20),
      child: Text(
        this.text.toUpperCase(),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
