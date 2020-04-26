import 'package:CiliCat/cat_font_icons.dart';
import 'package:CiliCat/components/AppTitleBack.dart';
import 'package:CiliCat/components/ErrorDialog.dart';
import 'package:CiliCat/components/Heading1.dart';
import 'package:CiliCat/components/Heading2.dart';
import 'package:CiliCat/components/ShelterneedDialog.dart';
import 'package:CiliCat/models/ShelterNeed.dart';
import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:CiliCat/providers/ShelterNeedsProvider.dart';
import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShelterNeedsPage extends StatefulWidget {
  static const screenRoute = '/shelterneeds';

  bool loaded = false;

  @override
  _ShelterNeedsPageState createState() => _ShelterNeedsPageState();
}

class _ShelterNeedsPageState extends State<ShelterNeedsPage> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> _refresh() async {
    _refreshKey.currentState?.show(atTop: false);
    await Provider.of<ShelterneedsProvider>(context, listen: false).getNeeds();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ShelterneedsProvider needsProvider =
        Provider.of<ShelterneedsProvider>(context);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);

    List<String> categories = [];

    List<ShelterNeed> needs = needsProvider.needs
        .where((n) => (!n.hide || authProvider.isAdmin))
        .toList();

    needs.forEach((n) =>
        categories.contains(n.category) ? null : categories.add(n.category));

    List<Widget> tiles = [];

    categories.forEach((c) {
      tiles.add(Heading2(c, Colors.black));
      tiles.addAll(needs.where((n) => n.category == c).map((n) => ListTile(
            title: Text(n.name),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text(n.name),
                  content: RichText(
                    text: TextSpan(
                      text: n.details,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    authProvider.isAdmin
                        ? IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: palette[700],
                            ),
                            onPressed: () async {
                              var ret = await Provider.of<ShelterneedsProvider>(
                                      context,
                                      listen: false)
                                  .delete(n.uuid);

                              Navigator.of(context).pop();

                              if (ret != null) {
                                print(ret);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      ErrorDialog(ret),
                                );
                              }
                            })
                        : null,
                  ],
                ),
              );
            },
            trailing: authProvider.isAdmin
                ? IconButton(
                    icon: Icon(
                      n.hide ? CatFont.eye_off : Icons.remove_red_eye,
                      color: n.hide ? Colors.black38 : palette[600],
                    ),
                    onPressed: () async {
                      await Provider.of<ShelterneedsProvider>(context,
                              listen: false)
                          .toggle(n.uuid);
                    })
                : null,
          )));
    });

    return Scaffold(
      appBar: AppTitleBack(),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _refresh,
        child: ListView(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
          children: <Widget>[
            Heading1('Čo nám chýba v útulku'),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.0,
                  color: palette[50],
                ),
                text:
                    'Ak nemôžete prispieť finančne, vždy sa potešíme, a taktiež aj naše mačky, keď nám viete prispieť vecami, ktoré nepotrebujete.\nKliknutím na jendotlivé položky môžete zobraziť detailnejší popis.',
              ),
            ),
            Heading1('Tento týždeň nám chýba'),
            ...(tiles.isEmpty ? [Text('Nič nám nechýba :)')] : tiles),
          ],
        ),
      ),
      floatingActionButton: authProvider.isAdmin
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => ShelterneedDialog(
                      (String name, String category, String details) async {
                    var ret = await Provider.of<ShelterneedsProvider>(context,
                            listen: false)
                        .add(name, category, details);
                    if (ret != null) {
                      print(ret);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => ErrorDialog(ret),
                      );
                    }
                  }),
                );
              },
              child: Icon(Icons.add),
              backgroundColor: palette,
            )
          : null,
    );
  }
}
