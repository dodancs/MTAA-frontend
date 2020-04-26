import 'package:CiliCat/components/AppTitleBack.dart';
import 'package:CiliCat/components/ConfirmDialog.dart';
import 'package:CiliCat/components/ErrorDialog.dart';
import 'package:CiliCat/components/Heading1.dart';
import 'package:CiliCat/components/Heading2.dart';
import 'package:CiliCat/components/TextInputDialog.dart';
import 'package:CiliCat/providers/SettingsProvider.dart';
import 'package:CiliCat/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:CiliCat/providers/AuthProvider.dart';

class AdminPage extends StatefulWidget {
  static const screenRoute = '/admin';

  bool _breedsExpanded = false;
  bool _coloursExpanded = false;
  bool _healthStatusesExpanded = false;
  bool _usersExpanded = false;

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
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

  ExpansionPanel _breedsPanel(SettingsProvider settingsProvider) {
    return ExpansionPanel(
      canTapOnHeader: true,
      headerBuilder: (BuildContext context, bool expanded) => Padding(
        padding: EdgeInsets.only(left: 20),
        child: Heading2('Plemená', Colors.black),
      ),
      isExpanded: widget._breedsExpanded,
      body: Container(
        width: double.infinity,
        height: 300,
        padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
        child: ListView(
          children: <Widget>[
            ListTile(
              trailing: IconButton(
                  icon: Icon(Icons.add, color: palette[500]),
                  onPressed: _addBreed),
              title: Text(
                'Nové plemeno',
                style: TextStyle(color: palette[500]),
              ),
            ),
            ...settingsProvider.breeds
                .map((b) => ListTile(
                      trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: palette[700],
                          ),
                          onPressed: () async {
                            bool r = await showDialog(
                              context: context,
                              builder: (BuildContext context) => ConfirmDialog(
                                  'Naozaj si prajete odísť zmazať toto plemeno?'),
                            );
                            if (r) {
                              await settingsProvider.deleteSetting(
                                  'breeds', b.id);
                            }
                          }),
                      title: Text(b.name),
                    ))
                .toList()
          ],
        ),
      ),
    );
  }

  ExpansionPanel _coloursPanel(SettingsProvider settingsProvider) {
    return ExpansionPanel(
      canTapOnHeader: true,
      headerBuilder: (BuildContext context, bool expanded) => Padding(
        padding: EdgeInsets.only(left: 20),
        child: Heading2('Farby srsti', Colors.black),
      ),
      isExpanded: widget._coloursExpanded,
      body: Container(
        width: double.infinity,
        height: 300,
        padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
        child: ListView(
          children: <Widget>[
            ListTile(
              trailing: IconButton(
                  icon: Icon(Icons.add, color: palette[500]),
                  onPressed: _addColour),
              title: Text(
                'Nová farba',
                style: TextStyle(color: palette[500]),
              ),
            ),
            ...settingsProvider.colours
                .map((c) => ListTile(
                      trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: palette[700],
                          ),
                          onPressed: () async {
                            bool r = await showDialog(
                              context: context,
                              builder: (BuildContext context) => ConfirmDialog(
                                  'Naozaj si prajete odísť zmazať túto farbu?'),
                            );
                            if (r) {
                              await settingsProvider.deleteSetting(
                                  'colours', c.id);
                            }
                          }),
                      title: Text(c.name),
                    ))
                .toList()
          ],
        ),
      ),
    );
  }

  ExpansionPanel _healthStatusesPanel(SettingsProvider settingsProvider) {
    return ExpansionPanel(
      canTapOnHeader: true,
      headerBuilder: (BuildContext context, bool expanded) => Padding(
        padding: EdgeInsets.only(left: 20),
        child: Heading2('Zdravotné stavy', Colors.black),
      ),
      isExpanded: widget._healthStatusesExpanded,
      body: Container(
        width: double.infinity,
        height: 300,
        padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
        child: ListView(
          children: <Widget>[
            ListTile(
              trailing: IconButton(
                  icon: Icon(Icons.add, color: palette[500]),
                  onPressed: _addHealthStatus),
              title: Text(
                'Nový stav',
                style: TextStyle(color: palette[500]),
              ),
            ),
            ...settingsProvider.healthStatuses
                .map((h) => ListTile(
                      trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: palette[700],
                          ),
                          onPressed: () async {
                            bool r = await showDialog(
                              context: context,
                              builder: (BuildContext context) => ConfirmDialog(
                                  'Naozaj si prajete odísť zmazať tento zdravotný stav?'),
                            );
                            if (r) {
                              await settingsProvider.deleteSetting(
                                  'health_statuses', h.id);
                            }
                          }),
                      title: Text(h.name),
                    ))
                .toList()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppTitleBack(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Heading1('Administrácia'),
                ExpansionPanelList(
                  expansionCallback: (int index, bool expanded) {
                    setState(() {
                      if (index == 0)
                        widget._breedsExpanded = !widget._breedsExpanded;
                      if (index == 1)
                        widget._coloursExpanded = !widget._coloursExpanded;
                      if (index == 2)
                        widget._healthStatusesExpanded =
                            !widget._healthStatusesExpanded;
                    });
                  },
                  children: [
                    _breedsPanel(settingsProvider),
                    _coloursPanel(settingsProvider),
                    _healthStatusesPanel(settingsProvider),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
