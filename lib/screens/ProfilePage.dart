import 'package:CiliCat/components/AppTitleBack.dart';
import 'package:CiliCat/components/CatCard.dart';
import 'package:CiliCat/components/Heading1.dart';
import 'package:CiliCat/components/UserCard.dart';
import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:CiliCat/providers/CatsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  static const screenRoute = '/profile';

  bool updated = false;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _updateCats(
      final List<String> favourites, final CatsProvider catsProvider) async {
    if (!widget.updated) {
      for (String f in favourites) {
        await catsProvider.updateCat(f);
      }
      widget.updated = true;
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final catsProvider = Provider.of<CatsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    _updateCats(authProvider.getCurrentUser.favourites, catsProvider);

    return WillPopScope(
      onWillPop: () async {
        await catsProvider.getCats();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppTitleBack(
          callback: () async {
            await catsProvider.getCats();
            Navigator.of(context).pop();
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              UserCard(authProvider.getCurrentUser),
              Heading1('Obľúbené mačky'),
              ...authProvider.getCurrentUser.favourites
                  .map((f) => CatCard(catsProvider.catDetails(f), true))
                  .toList()
            ],
          ),
        ),
      ),
    );
  }
}
