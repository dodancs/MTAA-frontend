import 'package:CiliCat/components/AppTitleBack.dart';
import 'package:CiliCat/components/ConfirmDialog.dart';
import 'package:CiliCat/components/ErrorDialog.dart';
import 'package:CiliCat/components/Heading1.dart';
import 'package:CiliCat/components/ItemDropdown.dart';
import 'package:CiliCat/components/ItemDropdownWithCreate.dart';
import 'package:CiliCat/components/MainMenu.dart';
import 'package:CiliCat/components/TextInputDialog.dart';
import 'package:CiliCat/helpers.dart';
import 'package:CiliCat/models/Breed.dart';
import 'package:CiliCat/models/Cat.dart';
import 'package:CiliCat/models/Colour.dart';
import 'package:CiliCat/models/HealthStatus.dart';
import 'package:CiliCat/providers/CatsProvider.dart';
import 'package:CiliCat/providers/SettingsProvider.dart';
import 'package:CiliCat/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CatEditPage extends StatefulWidget {
  final Cat cat;

  String _name;
  int _age;
  String _description;
  String _health_log;
  bool _sex;
  Breed _breed;
  Colour _colour;
  HealthStatus _health_status;
  bool _castrated;
  bool _vaccinated;
  bool _dewormed;
  String _currentSex;
  String _currentBreed;
  String _currentColour;
  String _currentHealthStatus;

  CatEditPage({this.cat}) {
    if (cat != null) {
      _name = cat.name;
      _age = cat.age;
      _description = cat.description;
      _health_log = cat.health_log;
      _sex = cat.sex;
      _breed = cat.breed;
      _colour = cat.colour;
      _health_status = cat.health_status;
      _castrated = cat.castrated;
      _vaccinated = cat.vaccinated;
      _dewormed = cat.dewormed;
      _currentSex = cat.sex ? sexes[0] : sexes[1];
      _currentBreed = _breed.name;
      _currentColour = _colour.name;
      _currentHealthStatus = _health_status.name;
    }
  }

  @override
  _CatEditPageState createState() => _CatEditPageState();
}

class _CatEditPageState extends State<CatEditPage> {
  void _backPressed(bool _unsaved) async {
    if (!_unsaved)
      Navigator.of(context).pop();
    else {
      bool r = await showDialog(
        context: context,
        builder: (BuildContext context) =>
            ConfirmDialog('Zmeny neboli uložené!\nNaozaj si prajete odísť?'),
      );
      if (r) {
        Navigator.of(context).pop();
      }
    }
  }

  void _addBreed() {
    showDialog(
      context: context,
      builder: (BuildContext context) => TextInputDialog(
        'Zadajte názov plemena',
        validate: (value) => (value != null && value != ''
            ? Provider.of<SettingsProvider>(context, listen: false)
                        .breeds
                        .firstWhere((b) => b.name == value,
                            orElse: () => null) ==
                    null
                ? null
                : 'Plemeno už existuje'
            : 'Zadajte názov plemena'),
        save: (value) async {
          String ret =
              await Provider.of<SettingsProvider>(context, listen: false)
                  .addSetting('breeds', value);

          if (ret != null) {
            print(ret);
            showDialog(
              context: context,
              builder: (BuildContext context) => ErrorDialog(ret),
            );
          }
        },
      ),
    );
  }

  void _addColour() {
    showDialog(
      context: context,
      builder: (BuildContext context) => TextInputDialog(
        'Zadajte farbu srsti',
        validate: (value) => (value != null && value != ''
            ? Provider.of<SettingsProvider>(context, listen: false)
                        .colours
                        .firstWhere((c) => c.name == value,
                            orElse: () => null) ==
                    null
                ? null
                : 'Farba už existuje'
            : 'Zadajte farbu srsti'),
        save: (value) async {
          String ret =
              await Provider.of<SettingsProvider>(context, listen: false)
                  .addSetting('colours', value);

          if (ret != null) {
            print(ret);
            showDialog(
              context: context,
              builder: (BuildContext context) => ErrorDialog(ret),
            );
          }
        },
      ),
    );
  }

  void _addHealthStatus() {
    showDialog(
      context: context,
      builder: (BuildContext context) => TextInputDialog(
        'Zadajte názov zdravotného stavu',
        validate: (value) => (value != null && value != ''
            ? Provider.of<SettingsProvider>(context, listen: false)
                        .healthStatuses
                        .firstWhere((h) => h.name == value,
                            orElse: () => null) ==
                    null
                ? null
                : 'Zdravotný stav už existuje'
            : 'Zadajte názov zdravotného stavu'),
        save: (value) async {
          String ret =
              await Provider.of<SettingsProvider>(context, listen: false)
                  .addSetting('health_statuses', value);

          if (ret != null) {
            print(ret);
            showDialog(
              context: context,
              builder: (BuildContext context) => ErrorDialog(ret),
            );
          }
        },
      ),
    );
  }

  void _deleteCat() async {
    setState(() {
      _enabled = false;
    });

    String ret = await Provider.of<CatsProvider>(context, listen: false)
        .delete(widget.cat.uuid);

    if (ret != null) {
      print(ret);
      showDialog(
        context: context,
        builder: (BuildContext context) => ErrorDialog(ret),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  void _submit() {
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
    // print('name: ' + widget._name);
    // print('age: ' + widget._age.toString());
    // print('description: ' + widget._description);
    // print('health_log: ' + widget._health_log);
    // print('sex: ' + widget._sex.toString());
    // print('breed: ' + widget._breed.name);
    // print('colour: ' + widget._colour.name);
    // print('health_status: ' + widget._health_status.name);
    // print('castrated: ' + widget._castrated.toString());
    // print('vaccinated: ' + widget._vaccinated.toString());
    // print('dewormed: ' + widget._dewormed.toString());
    // print('new_sex: ' + widget._currentSex);
    // print('new_breed: ' + widget._currentBreed);
    // print('new_colour: ' + widget._currentColour);
    // print('new_health_status: ' + widget._currentHealthStatus);
    setState(() {
      _enabled = true;
    });
  }

  final _form = GlobalKey<FormState>();

  final FocusNode _ageFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _healthLogFocus = FocusNode();

  bool _enabled = true;
  bool _unsaved = false;

  Widget _buttons() {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        widget.cat == null
            ? Container()
            : MaterialButton(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                elevation: 1,
                child: Text(
                  'Odstrániť',
                  style: TextStyle(fontSize: 20),
                ),
                color: palette[700],
                onPressed: () async {
                  bool b = await showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        ConfirmDialog('Naozaj chcete zmazať túto mačku?'),
                  );
                  if (b) _deleteCat();
                },
              ),
        MaterialButton(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          elevation: 1,
          child: Text(
            widget.cat == null ? 'Pridať mačku' : 'Uložiť zmeny',
            style: TextStyle(fontSize: 20),
          ),
          color: palette,
          onPressed: _submit,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    List<String> _breeds = [
      ...settingsProvider.breeds.map((Breed b) {
        return b.name;
      }),
    ];

    List<String> _colours = [
      ...settingsProvider.colours.map((Colour c) {
        return c.name;
      }),
    ];

    List<String> _health_statuses = [
      ...settingsProvider.healthStatuses.map((HealthStatus h) {
        return h.name;
      }),
    ];

    return WillPopScope(
      onWillPop: () {
        if (!_unsaved)
          return Future.value(true);
        else
          return showDialog(
            context: context,
            builder: (BuildContext context) => ConfirmDialog(
                'Zmeny neboli uložené!\nNaozaj si prajete odísť?'),
          );
      },
      child: Scaffold(
        appBar: AppTitleBack(callback: () {
          _backPressed(_unsaved);
        }),
        drawer: MainMenu(),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Heading1(widget.cat == null
                      ? 'Pridanie mačky'
                      : 'Upravenie mačky'),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Meno',
                      enabled: _enabled,
                    ),
                    initialValue: widget._name,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).unfocus();
                      FocusScope.of(context).requestFocus(_ageFocus);
                    },
                    onSaved: (value) {
                      widget._name = value;
                    },
                    onChanged: (vaue) {
                      _unsaved = true;
                    },
                    validator: (value) {
                      var ret = commonValidation(value);
                      return ret;
                    },
                    readOnly: !_enabled,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Vek v mesiacoch',
                      enabled: _enabled,
                    ),
                    initialValue:
                        widget._age == null ? null : widget._age.toString(),
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: false, signed: false),
                    inputFormatters: [
                      BlacklistingTextInputFormatter(RegExp("[.,-]"))
                    ],
                    textInputAction: TextInputAction.next,
                    focusNode: _ageFocus,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).unfocus();
                      FocusScope.of(context).requestFocus(_descriptionFocus);
                    },
                    onSaved: (value) {
                      widget._age = int.parse(value);
                    },
                    onChanged: (vaue) {
                      _unsaved = true;
                    },
                    validator: (value) {
                      var ret = commonValidation(value);
                      int val = int.parse(value);
                      if (ret == null && (val > 240 || val < 0)) {
                        return 'Vek musí byť medzi 0 až 240 mesiacmi';
                      }
                      return ret;
                    },
                    readOnly: !_enabled,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Krátky popis',
                      enabled: _enabled,
                    ),
                    maxLines: 4,
                    initialValue: widget._description,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    focusNode: _descriptionFocus,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).unfocus();
                      FocusScope.of(context).requestFocus(_healthLogFocus);
                    },
                    onSaved: (value) {
                      widget._description = value;
                    },
                    onChanged: (vaue) {
                      _unsaved = true;
                    },
                    validator: (value) {
                      var ret = commonValidation(value);
                      return ret;
                    },
                    readOnly: !_enabled,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Zdravotný záznam',
                      enabled: _enabled,
                    ),
                    maxLines: 4,
                    initialValue: widget._health_log,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).unfocus();
                    },
                    focusNode: _healthLogFocus,
                    onSaved: (value) {
                      widget._health_log = value;
                    },
                    onChanged: (vaue) {
                      _unsaved = true;
                    },
                    readOnly: !_enabled,
                  ),
                  SizedBox(height: 20),
                  ItemDropdown(
                    'Pohlavie',
                    sexes,
                    widget._currentSex,
                    (e) {
                      _unsaved = true;
                      widget._currentSex = e;
                    },
                    noDefault: true,
                    enabled: _enabled,
                  ),
                  SizedBox(height: 10),
                  ItemDropdownWithCreate(
                    'Plemeno',
                    _breeds,
                    widget._currentBreed,
                    (e) => (widget._currentBreed = e),
                    _addBreed,
                    enabled: _enabled,
                  ),
                  SizedBox(height: 10),
                  ItemDropdownWithCreate(
                    'Farba srsti',
                    _colours,
                    widget._currentColour,
                    (e) {
                      _unsaved = true;
                      widget._currentColour = e;
                    },
                    _addColour,
                    enabled: _enabled,
                  ),
                  SizedBox(height: 10),
                  ItemDropdownWithCreate(
                    'Zdravotný stav',
                    _health_statuses,
                    widget._currentHealthStatus,
                    (e) {
                      _unsaved = true;
                      widget._currentHealthStatus = e;
                    },
                    _addHealthStatus,
                    enabled: _enabled,
                  ),
                  SizedBox(height: 10),
                  SwitchListTile(
                    title: Text('Kastrovaná'),
                    value:
                        widget._castrated == null ? false : widget._castrated,
                    onChanged: _enabled
                        ? (value) {
                            setState(() {
                              _unsaved = true;
                              widget._castrated = value;
                            });
                          }
                        : null,
                    contentPadding: EdgeInsets.zero,
                  ),
                  SwitchListTile(
                    title: Text('Očkovaná'),
                    value:
                        widget._vaccinated == null ? false : widget._vaccinated,
                    onChanged: _enabled
                        ? (value) {
                            setState(() {
                              _unsaved = true;
                              widget._vaccinated = value;
                            });
                          }
                        : null,
                    contentPadding: EdgeInsets.zero,
                  ),
                  SwitchListTile(
                    title: Text('Odčervená'),
                    value: widget._dewormed == null ? false : widget._dewormed,
                    onChanged: _enabled
                        ? (value) {
                            setState(() {
                              _unsaved = true;
                              widget._dewormed = value;
                            });
                          }
                        : null,
                    contentPadding: EdgeInsets.zero,
                  ),
                  SizedBox(height: 20),
                  _buttons()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
