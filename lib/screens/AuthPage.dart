import 'dart:ui';

import 'package:CiliCat/components/AppTitle.dart';
import 'package:CiliCat/components/ConfirmEmailDialog.dart';
import 'package:CiliCat/components/ErrorDialog.dart';
import 'package:CiliCat/components/Heading1.dart';
import 'package:CiliCat/components/Loading.dart';
import 'package:CiliCat/components/LoginForm.dart';
import 'package:CiliCat/components/SignupForm.dart';
import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:CiliCat/screens/HomePage.dart';
import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthMode { login, signup }

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  AuthMode _mode = AuthMode.login;
  bool _loading = false;

  void _setAuthMode(AuthMode mode) {
    setState(() {
      _mode = mode;
    });
  }

  void _switchAuthMode() {
    if (_mode == AuthMode.login) {
      _setAuthMode(AuthMode.signup);
    } else {
      _setAuthMode(AuthMode.login);
    }
  }

  Future<void> _login(String email, String password) async {
    setState(() {
      _loading = true;
    });
    var response = await Provider.of<AuthProvider>(context, listen: false)
        .login(email, password);
    setState(() {
      _loading = false;
    });
    if (response[0]) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
        return HomePage();
      }));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => ErrorDialog(response[1]['error']));
    }
  }

  Future<void> _signup(String firstname, String lastname, String email,
      String password, String picture) async {
    setState(() {
      _loading = true;
    });
    var response = await Provider.of<AuthProvider>(context, listen: false)
        .signup(firstname, lastname, email, password, picture);
    setState(() {
      _loading = false;
      _mode = AuthMode.login;
    });
    if (response[0]) {
      showDialog(
          context: context,
          builder: (BuildContext context) => ConfirmEmailDialog());
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => ErrorDialog(response[1]['error']));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTitle(),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background.jpg'),
                      fit: BoxFit.cover)),
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          palette[300].withOpacity(0.25),
                          palette[500].withOpacity(0.5)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0, 1])),
              )),
          Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Card(
                      margin: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: <Widget>[
                            _mode == AuthMode.login
                                ? Heading1('Prihlásenie')
                                : Heading1('Registrácia'),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Column(
                                  children: <Widget>[
                                    _mode == AuthMode.login
                                        ? LoginForm((email, password) {
                                            _login(email, password);
                                          })
                                        : SignupForm((firstname, lastname,
                                            email, password, picture) {
                                            _signup(firstname, lastname, email,
                                                password, picture);
                                          }),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        _mode == AuthMode.login
                                            ? Text('Ešte nemáte účet? ')
                                            : Text('Chcete sa prihlásiť? '),
                                        InkWell(
                                          child: Text(
                                            _mode == AuthMode.login
                                                ? 'Registrovať sa'
                                                : 'Prihlásiť sa',
                                            style:
                                                TextStyle(color: palette[600]),
                                          ),
                                          onTap: () {
                                            _switchAuthMode();
                                          },
                                        )
                                      ],
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
          _loading ? Loading() : Container(),
        ],
      ),
    );
  }
}
