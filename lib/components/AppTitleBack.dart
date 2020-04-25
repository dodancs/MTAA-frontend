import 'package:flutter/material.dart';
import 'package:CiliCat/settings.dart';

class AppTitleBack extends StatelessWidget with PreferredSizeWidget {
  final Function callback;

  AppTitleBack({this.callback});

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
        onPressed: () async {
          if (this.callback == null) {
            Navigator.of(context).pop();
          } else {
            await this.callback();
          }
        },
      ),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
