import 'package:CiliCat/cat_font_icons.dart';
import 'package:CiliCat/components/MenuItem.dart';
import 'package:CiliCat/components/UserMenuCard.dart';
import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:CiliCat/screens/AdminPage.dart';
import 'package:CiliCat/screens/HelpPage.dart';
import 'package:CiliCat/screens/ProfilePage.dart';
import 'package:CiliCat/screens/ShelterNeedsPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final authProvider = Provider.of<AuthProvider>(context);

    List<Widget> items = [];
    items.add(UserMenuCard(authProvider.getCurrentUser));
    items.add(MenuItem(
      icon: CatFont.cat,
      title: 'Naše mačky',
      callback: () {
        Navigator.popUntil(
            context, ModalRoute.withName(Navigator.defaultRouteName));
      },
    ));
    items.add(MenuItem(
      icon: Icons.healing,
      title: 'Čo nám chýba',
      callback: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, ShelterNeedsPage.screenRoute);
      },
    ));
    // items.add(MenuItem(
    //   icon: Icons.monetization_on,
    //   title: 'Prispejte nám',
    //   callback: () {
    //     Navigator.pop(context);
    //   },
    // ));
    items.add(MenuItem(
      icon: Icons.help,
      title: 'Pomoc',
      callback: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, HelpPage.screenRoute);
      },
    ));
    items.add(Spacer());
    if (authProvider.isAdmin) {
      items.add(MenuItem(
        icon: Icons.tune,
        title: 'Administrácia',
        callback: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, AdminPage.screenRoute);
        },
      ));
    }
    items.add(MenuItem(
      icon: Icons.person,
      title: 'Môj profil',
      callback: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, ProfilePage.screenRoute);
      },
    ));
    items.add(MenuItem(
      icon: Icons.exit_to_app,
      title: 'Odhlásiť sa',
      callback: () {
        Provider.of<AuthProvider>(context, listen: false).logout();
      },
    ));
    return items;
  }
}
