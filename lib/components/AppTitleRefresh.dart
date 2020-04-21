import 'package:flutter/material.dart';
import 'package:CiliCat/settings.dart';

class AppTitleRefresh extends StatelessWidget with PreferredSizeWidget {
  Function _callback;

  AppTitleRefresh(this._callback);

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
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: this._callback,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
