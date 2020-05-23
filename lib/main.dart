import 'package:CiliCat/providers/StorageProvider.dart';
import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:CiliCat/providers/PicturesProvider.dart';
import 'package:CiliCat/providers/SettingsProvider.dart';
import 'package:CiliCat/providers/CatsProvider.dart';
import 'package:CiliCat/providers/ShelterNeedsProvider.dart';
import 'package:CiliCat/screens/AdminPage.dart';
import 'package:CiliCat/screens/AuthPage.dart';
import 'package:CiliCat/screens/HelpPage.dart';
import 'package:CiliCat/screens/HomePage.dart';
import 'package:CiliCat/screens/ProfilePage.dart';
import 'package:CiliCat/screens/ShelterNeedsPage.dart';
import 'package:CiliCat/screens/SplashScreen.dart';
import 'package:CiliCat/screens/SyncPage.dart';
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
        ChangeNotifierProvider<StorageProvider>(
          create: (_) => StorageProvider(),
        ),
        ChangeNotifierProxyProvider<StorageProvider, AuthProvider>(
          create: (_) => AuthProvider(),
          update: (_, storage, auth) => auth..update(storage),
        ),
        ChangeNotifierProxyProvider2<StorageProvider, AuthProvider,
            SettingsProvider>(
          create: (_) => SettingsProvider(),
          update: (_, storage, auth, settings) =>
              settings..update(storage, auth),
        ),
        ChangeNotifierProxyProvider<AuthProvider, PicturesProvider>(
          create: (_) => PicturesProvider(),
          update: (_, auth, pictures) => pictures..update(auth),
        ),
        ChangeNotifierProxyProvider2<StorageProvider, AuthProvider,
            ShelterneedsProvider>(
          create: (_) => ShelterneedsProvider(),
          update: (_, storage, auth, needs) => needs..update(storage, auth),
        ),
        ChangeNotifierProxyProvider3<StorageProvider, AuthProvider,
            SettingsProvider, CatsProvider>(
          create: (_) => CatsProvider(),
          update: (_, storage, auth, settings, cats) =>
              cats..update(storage, auth, settings),
        ),
      ],
      child: Consumer2<StorageProvider, AuthProvider>(
        builder: (context, storage, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: APP_TITLE,
            theme: ThemeData(
                primarySwatch: palette,
                textTheme: TextTheme(
                  bodyText1: TextStyle(fontSize: 16),
                )),
            home: auth.isLoggedIn
                ? storage.needSync ? SyncPage() : HomePage()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (context, result) =>
                        result.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthPage(),
                  ),
            routes: {
              HelpPage.screenRoute: (context) => HelpPage(),
              ProfilePage.screenRoute: (context) => ProfilePage(),
              ShelterNeedsPage.screenRoute: (context) => ShelterNeedsPage(),
              AdminPage.screenRoute: (context) => AdminPage(),
            },
          );
        },
      ),
    );
  }
}
