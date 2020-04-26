import 'package:flutter/material.dart';
import 'package:CiliCat/settings.dart';

class AppTitleSettings extends StatelessWidget with PreferredSizeWidget {
  final Function _settings;
  final Function _back;

  AppTitleSettings(this._back, this._settings);

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
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: _back,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: _settings,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
