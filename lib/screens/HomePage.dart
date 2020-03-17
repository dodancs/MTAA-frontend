import 'package:CiliCat/components/AppTitle.dart';
import 'package:CiliCat/components/MainMenu.dart';
import 'package:flutter/material.dart';
import 'package:CiliCat/components/CatCard.dart';

class HomePage extends StatelessWidget {
  static const screenRoute = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTitle(),
      drawer: MainMenu(),
      body: ListView(
        children: <Widget>[
          CatCard(
            name: 'Micka',
            age: 13,
            description: 'Jebe jej',
            coverImage: Image.asset('assets/images/sample_cat_1.jpg'),
          ),
          CatCard(
            name: 'Jožo',
            age: 53,
            description: 'Jebe mu',
            coverImage: Image.asset('assets/images/sample_cat_2.jpg'),
          ),
          CatCard(
            name: 'Micka',
            age: 13,
            description: 'Jebe jej',
            coverImage: Image.asset('assets/images/sample_cat_1.jpg'),
          ),
          CatCard(
            name: 'Jožo',
            age: 53,
            description: 'Jebe mu',
            coverImage: Image.asset('assets/images/sample_cat_2.jpg'),
          ),
        ],
      ),
    );
  }
}
