import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('ČiliCat',
          style: TextStyle(
            fontFamily: 'Amatic SC',
            fontWeight: FontWeight.bold,
            fontSize: 40.0,
          )),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
