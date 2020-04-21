import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:CiliCat/providers/SettingsProvider.dart';
import 'package:CiliCat/providers/CatsProvider.dart';
import 'package:CiliCat/screens/AuthPage.dart';
import 'package:CiliCat/screens/HelpPage.dart';
import 'package:CiliCat/screens/HomePage.dart';
import 'package:CiliCat/screens/SplashScreen.dart';
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
        ChangeNotifierProxyProvider<AuthProvider, SettingsProvider>(
          create: (_) => SettingsProvider(),
          update: (_, auth, settings) => settings..update(auth),
        ),
        ChangeNotifierProxyProvider2<AuthProvider, SettingsProvider,
            CatsProvider>(
          create: (_) => CatsProvider(),
          update: (_, auth, settings, cats) => cats..update(auth, settings),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: APP_TITLE,
            theme: ThemeData(
                primarySwatch: palette,
                textTheme: TextTheme(
                  body1: TextStyle(fontSize: 16),
                )),
            home: auth.isLoggedIn
                ? HomePage()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (context, result) =>
                        result.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthPage(),
                  ),
            routes: {
              HelpPage.screenRoute: (context) => HelpPage(),
            },
          );
        },
      ),
    );
  }
}
