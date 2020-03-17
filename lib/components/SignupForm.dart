import 'package:CiliCat/helpers.dart';
import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';

class SignupForm extends StatefulWidget {
  final Function callback;

  SignupForm(this.callback);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final FocusNode _lastnameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _passwordAgainFocus = FocusNode();

  final _form = GlobalKey<FormState>();

  String _firstname;
  String _lastname;
  String _email;
  String _password;
  String _passwordAgain;

  String _picture = null;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Meno'),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_lastnameFocus);
            },
            onSaved: (value) {
              _firstname = value;
            },
            validator: (value) {
              var ret = commnValidation(value);
              return ret;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Priezvisko'),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            focusNode: _lastnameFocus,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_emailFocus);
            },
            onSaved: (value) {
              _lastname = value;
            },
            validator: (value) {
              var ret = commnValidation(value);
              return ret;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'E-mail'),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            focusNode: _emailFocus,
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
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Heslo'),
            obscureText: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            focusNode: _passwordFocus,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_passwordAgainFocus);
            },
            onSaved: (value) {
              _password = value;
            },
            onChanged: (value) {
              _password = value;
            },
            validator: (value) {
              var ret = commnValidation(value);
              if (ret != null) return ret;
              if (value.length < 4)
                return 'Heslo musí obsahovať aspoň 4 znaky!';
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Heslo znovu'),
            obscureText: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            focusNode: _passwordAgainFocus,
            onSaved: (value) {
              _passwordAgain = value;
            },
            validator: (value) {
              var ret = commnValidation(value);
              if (ret != null) return ret;
              if (value != _password) return 'Heslá sa nezhodujú!';
              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            elevation: 1,
            child: Text('Registrovať sa',
                style: TextStyle(fontSize: 20, color: Colors.white)),
            color: palette,
            onPressed: () {
              if (!_form.currentState.validate()) {
                return;
              }
              _form.currentState.save();
              widget.callback(
                  _firstname, _lastname, _email, _password, _picture);
            },
          )
        ],
      ),
    );
  }
}
