import 'package:CiliCat/components/AppTitleBack.dart';
import 'package:CiliCat/components/ConfirmDialog.dart';
import 'package:CiliCat/components/ErrorDialog.dart';
import 'package:CiliCat/components/ErrorMessage.dart';
import 'package:CiliCat/components/Heading1.dart';
import 'package:CiliCat/components/ItemDropdown.dart';
import 'package:CiliCat/components/ItemDropdownWithCreate.dart';
import 'package:CiliCat/components/Loading.dart';
import 'package:CiliCat/components/PictureListInput.dart';
import 'package:CiliCat/components/TextInputDialog.dart';
import 'package:CiliCat/helpers.dart';
import 'package:CiliCat/models/Breed.dart';
import 'package:CiliCat/models/Cat.dart';
import 'package:CiliCat/models/Colour.dart';
import 'package:CiliCat/models/HealthStatus.dart';
import 'package:CiliCat/providers/CatsProvider.dart';
import 'package:CiliCat/providers/PicturesProvider.dart';
import 'package:CiliCat/providers/SettingsProvider.dart';
import 'package:CiliCat/providers/StorageProvider.dart';
import 'package:CiliCat/screens/CatDetailPage.dart';
import 'package:CiliCat/settings.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CatEditPage extends StatefulWidget {
  final Cat cat;

  String _name;
  bool _nameChanged = false;
  int _age;
  bool _ageChanged = false;
  String _description;
  bool _descriptionChanged = false;
  String _health_log;
  bool _healthLogChanged = false;
  bool _sex;
  bool _sexChanged = false;
  Breed _breed;
  bool _breedChanged = false;
  Colour _colour;
  bool _colourChanged = false;
  HealthStatus _health_status;
  bool _healthStatusChanged = false;
  bool _castrated = false;
  bool _castratedChanged = false;
  bool _vaccinated = false;
  bool _vaccinatedChanged = false;
  bool _dewormed = false;
  bool _dewormedChanged = false;
  bool _adoptive = false;
  bool _adoptiveChanged = false;
  List<String> _pictures;
  bool _picturesChanged = false;

  bool isValidated = false;

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
      _adoptive = cat.adoptive;
      _pictures = cat.pictures;
    }
  }

  @override
  _CatEditPageState createState() => _CatEditPageState();
}

class _CatEditPageState extends State<CatEditPage> {
  Future<bool> _backPressed() async {
    if (!_unsaved)
      Navigator.of(context).pop();
    else {
      bool r = await showDialog(
        context: context,
        builder: (BuildContext context) =>
            ConfirmDialog('Zmeny neboli uložené!\nNaozaj si prajete odísť?'),
      );
      if (r) {
        // if not editing a cat
        if (widget.cat == null) {
          // if pictures were created - delete them
          if (widget._pictures != null)
            for (var p in widget._pictures) {
              await Provider.of<PicturesProvider>(context, listen: false)
                  .remove(p);
            }
        }
        Navigator.of(context).pop();
      }
    }
    return Future.value(false);
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
      _loading = true;
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
      Navigator.of(context).pop();
    }
  }

  void _submit() async {
    setState(() {
      _enabled = false;
      _loading = true;
      widget.isValidated = true;
    });
    if (!_form.currentState.validate() ||
        widget._pictures == null ||
        widget._pictures.isEmpty ||
        widget._sex == null ||
        widget._breed == null ||
        widget._colour == null ||
        widget._health_status == null) {
      setState(() {
        _enabled = true;
        _loading = false;
      });
      return;
    }
    _form.currentState.save();

    // creating new cat
    if (widget.cat == null) {
      var ret = await Provider.of<CatsProvider>(context, listen: false).add(Cat(
        name: widget._name,
        age: widget._age,
        description: widget._description,
        health_log: widget._health_log,
        sex: widget._sex,
        breed: widget._breed,
        colour: widget._colour,
        health_status: widget._health_status,
        castrated: widget._castrated,
        vaccinated: widget._vaccinated,
        dewormed: widget._dewormed,
        adoptive: widget._adoptive,
        pictures: widget._pictures,
        commentsNum: 0,
        offline: false,
      ));

      if (ret[0]) {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CatDetailPage(
              ret[1],
              refreshOnExit: true,
            ),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => ErrorDialog(ret[1]),
        );
      }
    } else {
      Map<String, dynamic> changes = {};
      if (widget._nameChanged) changes.addAll({'name': widget._name});
      if (widget._ageChanged) changes.addAll({'age': widget._age});
      if (widget._descriptionChanged)
        changes.addAll({'description': widget._description});
      if (widget._healthLogChanged)
        changes.addAll({'health_log': widget._health_log});
      if (widget._sexChanged) changes.addAll({'sex': widget._sex});
      if (widget._breedChanged) changes.addAll({'breed': widget._breed.id});
      if (widget._colourChanged) changes.addAll({'colour': widget._colour.id});
      if (widget._healthStatusChanged)
        changes.addAll({'health_status': widget._health_status.id});
      if (widget._castratedChanged)
        changes.addAll({'castrated': widget._castrated});
      if (widget._vaccinatedChanged)
        changes.addAll({'vaccinated': widget._vaccinated});
      if (widget._dewormedChanged)
        changes.addAll({'dewormed': widget._dewormed});
      if (widget._adoptiveChanged)
        changes.addAll({'adoptive': widget._adoptive});
      if (widget._picturesChanged)
        changes.addAll({'pictures': widget._pictures});

      if (changes.isNotEmpty) {
        var ret = await Provider.of<CatsProvider>(context, listen: false)
            .change(changes, widget.cat.uuid);

        if (ret == null) {
          Navigator.of(context).pop();
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) => ErrorDialog(ret),
          );
        }
      } else {
        Navigator.of(context).pop();
      }
    }

    setState(() {
      _enabled = true;
      _loading = false;
    });
  }

  void _picturesChanged(List<String> pictures) async {
    setState(() {
      widget._pictures = pictures;
    });

    if (widget.cat != null)
      await Provider.of<CatsProvider>(context, listen: false)
          .change({'pictures': widget._pictures}, widget.cat.uuid);
  }

  final _form = GlobalKey<FormState>();

  final FocusNode _ageFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _healthLogFocus = FocusNode();

  bool _loading = false;
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
          onPressed: () => _loading || !_enabled ? null : _submit(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final StorageProvider storageProvider =
        Provider.of<StorageProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    if (storageProvider.connectivity == ConnectivityResult.none &&
        widget.cat != null &&
        widget.cat.offline == false) {
      _enabled = false;
      _loading = false;
    }

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
      onWillPop: _backPressed,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Scaffold(
          appBar: AppTitleBack(callback: _backPressed),
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
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
                        PictureListInput(
                          widget._pictures,
                          _picturesChanged,
                          enabled: _enabled,
                        ),
                        ErrorMessage(
                            'Mačka musí mať obrázok!',
                            widget.isValidated &&
                                (widget._pictures == null ||
                                    widget._pictures.isEmpty)),
                        SizedBox(height: 10),
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
                            widget._nameChanged = true;
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
                          initialValue: widget._age == null
                              ? null
                              : widget._age.toString(),
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: false, signed: false),
                          inputFormatters: [
                            BlacklistingTextInputFormatter(RegExp("[.,-]"))
                          ],
                          textInputAction: TextInputAction.next,
                          focusNode: _ageFocus,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocus);
                          },
                          onSaved: (value) {
                            widget._age = int.parse(value);
                          },
                          onChanged: (vaue) {
                            _unsaved = true;
                            widget._ageChanged = true;
                          },
                          validator: (value) {
                            var ret = commonValidation(value);
                            if (ret == null &&
                                (int.parse(value) > 240 ||
                                    int.parse(value) < 0)) {
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
                          maxLines: 10,
                          initialValue: widget._description,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          focusNode: _descriptionFocus,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                            FocusScope.of(context)
                                .requestFocus(_healthLogFocus);
                          },
                          onSaved: (value) {
                            widget._description = value;
                          },
                          onChanged: (vaue) {
                            _unsaved = true;
                            widget._descriptionChanged = true;
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
                          maxLines: 10,
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
                            widget._healthLogChanged = true;
                          },
                          readOnly: !_enabled,
                        ),
                        SizedBox(height: 20),
                        ItemDropdown(
                          'Pohlavie',
                          sexes,
                          widget._sex == null
                              ? null
                              : widget._sex ? sexes[0] : sexes[1],
                          (e) {
                            _unsaved = true;
                            widget._sex = (e == sexes[0] ? true : false);
                            widget._sexChanged = true;
                          },
                          noDefault: true,
                          enabled: _enabled,
                        ),
                        ErrorMessage('Pohlavie nebolo nastavené!',
                            widget.isValidated && (widget._sex == null)),
                        SizedBox(height: 10),
                        ItemDropdownWithCreate(
                          'Plemeno',
                          _breeds,
                          widget._breed != null ? widget._breed.name : null,
                          (e) {
                            _unsaved = true;
                            widget._breed = settingsProvider.breedFrom(name: e);
                            widget._breedChanged = true;
                          },
                          _addBreed,
                          enabled: _enabled,
                        ),
                        ErrorMessage('Plemeno nebolo nastavené!',
                            widget.isValidated && (widget._breed == null)),
                        SizedBox(height: 10),
                        ItemDropdownWithCreate(
                          'Farba srsti',
                          _colours,
                          widget._colour != null ? widget._colour.name : null,
                          (e) {
                            _unsaved = true;
                            widget._colour =
                                settingsProvider.colourFrom(name: e);
                            widget._colourChanged = true;
                          },
                          _addColour,
                          enabled: _enabled,
                        ),
                        ErrorMessage('Farba srsti nebola nastavená!',
                            widget.isValidated && (widget._colour == null)),
                        SizedBox(height: 10),
                        ItemDropdownWithCreate(
                          'Zdravotný stav',
                          _health_statuses,
                          widget._health_status != null
                              ? widget._health_status.name
                              : null,
                          (e) {
                            _unsaved = true;
                            widget._health_status =
                                settingsProvider.healthStatusFrom(name: e);
                            widget._healthStatusChanged = true;
                          },
                          _addHealthStatus,
                          enabled: _enabled,
                        ),
                        ErrorMessage(
                            'Zdravotný stav nebol nastavený!',
                            widget.isValidated &&
                                (widget._health_status == null)),
                        SizedBox(height: 10),
                        SwitchListTile(
                          title: Text('Kastrovaná'),
                          value: widget._castrated == null
                              ? false
                              : widget._castrated,
                          onChanged: _enabled
                              ? (value) {
                                  setState(() {
                                    _unsaved = true;
                                    widget._castrated = value;
                                    widget._castratedChanged = true;
                                  });
                                }
                              : null,
                          contentPadding: EdgeInsets.zero,
                        ),
                        SwitchListTile(
                          title: Text('Očkovaná'),
                          value: widget._vaccinated == null
                              ? false
                              : widget._vaccinated,
                          onChanged: _enabled
                              ? (value) {
                                  setState(() {
                                    _unsaved = true;
                                    widget._vaccinated = value;
                                    widget._vaccinatedChanged = true;
                                  });
                                }
                              : null,
                          contentPadding: EdgeInsets.zero,
                        ),
                        SwitchListTile(
                          title: Text('Odčervená'),
                          value: widget._dewormed == null
                              ? false
                              : widget._dewormed,
                          onChanged: _enabled
                              ? (value) {
                                  setState(() {
                                    _unsaved = true;
                                    widget._dewormed = value;
                                    widget._dewormedChanged = true;
                                  });
                                }
                              : null,
                          contentPadding: EdgeInsets.zero,
                        ),
                        SwitchListTile(
                          title: Text('Na adopciu'),
                          value: widget._adoptive == null
                              ? false
                              : widget._adoptive,
                          onChanged: _enabled
                              ? (value) {
                                  setState(() {
                                    _unsaved = true;
                                    widget._adoptive = value;
                                    widget._adoptiveChanged = true;
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
              _loading ? Loading() : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
