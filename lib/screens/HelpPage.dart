import 'package:CiliCat/cat_font_icons.dart';
import 'package:CiliCat/components/AppTitleBack.dart';
import 'package:CiliCat/components/Heading1.dart';
import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  static const screenRoute = '/help';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTitleBack(),
      body: ListView(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
          children: <Widget>[
            Heading1('Pomoc'),
            RichText(
              text: TextSpan(
                // Note: Styles for TextSpans must be explicitly defined.
                // Child text spans will inherit styles from parent
                style: TextStyle(
                  fontSize: 14.0,
                  color: palette[50],
                ),
                children: <TextSpan>[
                  TextSpan(
                    text:
                        'V prípade, že ste narazili na nejaké technické problémy s našou aplikáciou, obráťte sa prosím na naše technické oddelenie na adrese: ',
                  ),
                  TextSpan(
                    text: 'pomoc@cilicat.sk',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: '.')
                ],
              ),
            ),
            Heading1('Vysvetlivky'),
            Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    CatFont.try_out,
                    color: palette[50],
                  ),
                  title: Text('Mačka na adopciu'),
                ),
                ListTile(
                  leading: Icon(
                    CatFont.cat,
                    color: palette[50],
                  ),
                  title: Text('Adoptovať mačku'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: palette[50],
                  ),
                  title: Text('Tlačidlo nastavení'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.favorite,
                    color: palette[50],
                  ),
                  title: Text('Pridanie mačky medzi obľúbené'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.comment,
                    color: palette[50],
                  ),
                  title: Text('Zobrazenie komentárov'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.share,
                    color: palette[50],
                  ),
                  title: Text('Zdielanie mačky na sociále siete'),
                ),
              ],
            )
          ]),
    );
  }
}
