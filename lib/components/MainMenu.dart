import 'package:CiliCat/cat_font_icons.dart';
import 'package:CiliCat/components/MenuItem.dart';
import 'package:CiliCat/components/UserMenuCard.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: _buildMenu(context),
      ),
    );
  }

  List<Widget> _buildMenu(BuildContext context) {
    List<Widget> items = [];
    items.add(UserMenuCard());
    items.add(MenuItem(
      icon: CatFont.cat,
      title: 'Naše mačky',
      callback: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/home');
        // Navigator.pushReplacementNamed(context, '/');
      },
    ));
    items.add(MenuItem(icon: Icons.healing, title: 'Čo nám chýba'));
    items.add(MenuItem(icon: Icons.monetization_on, title: 'Prispejte nám'));
    items.add(MenuItem(
      icon: Icons.help,
      title: 'Pomoc',
      callback: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/help');
        // Navigator.pushReplacementNamed(context, '/help');
      },
    ));
    items.add(Spacer());
    if (true) {
      items.add(MenuItem(icon: Icons.tune, title: 'Administrácia'));
    }
    if (true) {
      items.add(MenuItem(icon: Icons.person, title: 'Môj profil'));
      items.add(MenuItem(
        icon: Icons.exit_to_app,
        title: 'Odhlásiť sa',
        callback: () {
          Navigator.popUntil(context, ModalRoute.withName('/'));
        },
      ));
    }
    return items;
  }
}
