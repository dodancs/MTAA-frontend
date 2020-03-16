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
            decoration: InputDecoration(labelText: 'E-mail'),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_passwordFocus);
            },
            onSaved: (value) {
              _email = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            focusNode: _passwordFocus,
            onSaved: (value) {
              _password = value;
            },
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            elevation: 1,
            child: Text('Prihlásiť sa',
                style: TextStyle(fontSize: 20, color: Colors.white)),
            color: palette,
            onPressed: () {
              _form.currentState.save();
              widget.callback(_email, _password);
            },
          )
        ],
      ),
    );
  }
}
