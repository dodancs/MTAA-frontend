import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function callback;

  MenuItem({@required this.icon, @required this.title, this.callback});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(40, 5, 40, 5),
      leading: Icon(this.icon),
      title: Text(this.title),
      onTap: this.callback,
    );
  }
}
