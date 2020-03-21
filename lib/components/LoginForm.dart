import 'package:CiliCat/helpers.dart';
import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final Function callback;

  LoginForm(this.callback);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FocusNode _passwordFocus = FocusNode();

  bool _enabled = true;

  final _form = GlobalKey<FormState>();

  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'E-mail',
              enabled: _enabled,
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_passwordFocus);
            },
            onSaved: (value) {
              _email = value;
            },
            validator: (value) {
              var ret = commnValidation(value);
              if (ret != null) return ret;
              if (!isEmail(value)) return 'E-mailová adresa nespĺňa formát!';
              return null;
            },
            readOnly: !_enabled,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
              enabled: _enabled,
            ),
            obscureText: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            focusNode: _passwordFocus,
            onSaved: (value) {
              _password = value;
            },
            validator: (value) {
              var ret = commnValidation(value);
              return ret;
            },
            readOnly: !_enabled,
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            elevation: 1,
            child: Text(
              'Prihlásiť sa',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            color: palette,
            onPressed: () {
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
              widget.callback(_email, _password);
              setState(() {
                _enabled = true;
              });
            },
          )
        ],
      ),
    );
  }
}
