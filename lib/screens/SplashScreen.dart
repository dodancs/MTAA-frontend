import 'package:CiliCat/components/AppTitle.dart';
import 'package:CiliCat/components/Loading.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTitle(),
      drawer: null,
      body: Loading(),
    );
  }
}
