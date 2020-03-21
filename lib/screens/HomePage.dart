import 'package:CiliCat/components/AppTitle.dart';
import 'package:CiliCat/components/MainMenu.dart';
import 'package:CiliCat/components/ShimmerImage.dart';
import 'package:CiliCat/models/Cat.dart';
import 'package:CiliCat/settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:CiliCat/components/CatCard.dart';
import 'package:provider/provider.dart';
import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:CiliCat/providers/CatsProvider.dart';

class HomePage extends StatelessWidget {
  static const screenRoute = '/';

  @override
  Widget build(BuildContext context) {
    final catsProvider = Provider.of<CatsProvider>(context);
    final cats = catsProvider.cats;
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppTitle(),
      drawer: MainMenu(),
      body: ListView(
        children: <Widget>[
          ...cats.map<Widget>(
            (Cat c) {
              return CatCard(
                name: c.name,
                age: c.age,
                description: c.description,
                coverImage: ShimmerImage(
                  picture: c.pictures[0],
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width * 0.9,
                ),
              );
            },
          )
        ],
      ),
      floatingActionButton: authProvider.isAdmin
          ? FloatingActionButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              child: Icon(Icons.add),
              backgroundColor: palette,
            )
          : null,
    );
  }
}
