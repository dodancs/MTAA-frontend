import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:CiliCat/providers/CatsProvider.dart';
import 'package:CiliCat/screens/AuthPage.dart';
import 'package:CiliCat/screens/HelpPage.dart';
import 'package:CiliCat/screens/HomePage.dart';
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
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Čili Cat',
            theme: ThemeData(primarySwatch: palette),
            home: auth.isLoggedIn ? HomePage() : AuthPage(),
            routes: {
              HelpPage.screenRoute: (context) => HelpPage(),
            },
          );
        },
      ),
    );
  }
}
