import 'package:flutter/material.dart';
import 'package:CiliCat/settings.dart';

class AppTitle extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(APP_TITLE,
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
