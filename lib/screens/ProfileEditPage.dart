import 'package:CiliCat/components/AppTitleBack.dart';
import 'package:CiliCat/components/ErrorDialog.dart';
import 'package:CiliCat/components/Heading1.dart';
import 'package:CiliCat/components/Loading.dart';
import 'package:CiliCat/components/PictureChooser.dart';
import 'package:CiliCat/helpers.dart';
import 'package:CiliCat/models/User.dart';
import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileEditPage extends StatefulWidget {
  String _password;
  String _passwordAgain;
  String _picture;
  User _user;

  ProfileEditPage(final User u) {
    if (u != null) {
      _picture = u.picture;
      _user = u;
    }
  }

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  bool _enabled = true;
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        appBar: AppTitleBack(),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(child: Heading1('Nastavenia účtu')),
                  PictureChooser(widget._picture, (String uuid) async {
                    var ret =
                        await Provider.of<AuthProvider>(context, listen: false)
                            .edit('picture', uuid);
                    if (ret != null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => ErrorDialog(ret),
                      );
                    }
                  }),
                  Form(
                    key: _form,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Heslo',
                            enabled: _enabled,
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          onSaved: (value) {
                            widget._password = value;
                          },
                          onChanged: (value) {
                            widget._password = value;
                          },
                          validator: (value) {
                            var ret = commonValidation(value);
                            if (ret != null) return ret;
                            if (value.length < 4)
                              return 'Heslo musí obsahovať aspoň 4 znaky!';
                            return null;
                          },
                          readOnly: !_enabled,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Heslo znovu',
                            enabled: _enabled,
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          onSaved: (value) {
                            widget._passwordAgain = value;
                          },
                          validator: (value) {
                            var ret = commonValidation(value);
                            if (ret != null) return ret;
                            if (value != widget._password)
                              return 'Heslá sa nezhodujú!';
                            return null;
                          },
                          readOnly: !_enabled,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RaisedButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          elevation: 1,
                          child: Text(
                            'Zmeniť heslo',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          color: palette,
                          onPressed: () async {
                            setState(() {
                              _enabled = false;
                            });
                            if (!_form.currentState.validate()) {
                              setState(() {
                                _enabled = true;
                              });
                              return;
                            }
                            _form.currentState.save();

                            var ret = await Provider.of<AuthProvider>(context,
                                    listen: false)
                                .edit('password', widget._password);
                            if (ret == null) {
                              Navigator.of(context).pop();
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    ErrorDialog(ret),
                              );
                            }

                            setState(() {
                              _enabled = true;
                            });
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            _enabled ? Container() : Loading()
          ],
        ),
      ),
    );
  }
}
