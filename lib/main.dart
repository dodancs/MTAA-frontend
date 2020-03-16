import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:CiliCat/screens/AuthPage.dart';
import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Čili Cat',
        theme: ThemeData(primarySwatch: palette),
        home: AuthPage(),
      ),
    );
  }
}
