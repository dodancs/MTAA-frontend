import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';

class UserMenuCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: palette,
      padding: EdgeInsets.fromLTRB(0, 30.5, 0, 0),
      child: Container(
        padding: EdgeInsets.all(40),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/blank_avatar.png'),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Meno Priezvisko',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text('Administrator')
              ],
            )
          ],
        ),
      ),
    );
  }
}
