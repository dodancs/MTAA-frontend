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
        ChangeNotifierProxyProvider<AuthProvider, CatsProvider>(
          create: (_) => CatsProvider(),
          update: (_, auth, cats) => cats..update(auth),
        ),
        ChangeNotifierProxyProvider<AuthProvider, SettingsProvider>(
          create: (_) => SettingsProvider(),
          update: (_, auth, settings) => settings..update(auth),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: APP_TITLE,
            theme: ThemeData(primarySwatch: palette),
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
