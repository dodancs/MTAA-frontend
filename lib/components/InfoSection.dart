import 'package:CiliCat/components/Heading2.dart';
import 'package:CiliCat/models/Cat.dart';
import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';

class InfoSection extends StatelessWidget {
  final Cat _cat;

  InfoSection(this._cat);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        width: double.infinity,
        color: palette[500].withAlpha(50),
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Heading2('INFORMÁCIE', Colors.black),
            RichText(
              text: TextSpan(
                text: 'Pohlavie: ',
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                      text: _cat.sex ? sexes[0] : sexes[1],
                      style: TextStyle(fontWeight: FontWeight.normal)),
                ],
              ),
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
            RichText(
              text: TextSpan(
                text: 'Vek: ',
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                      text: _cat.age < 12
                          ? _cat.age.toString() + ' mesiacov'
                          : (_cat.age / 12).toStringAsFixed(1) + ' rokov',
                      style: TextStyle(fontWeight: FontWeight.normal)),
                ],
              ),
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
            RichText(
              text: TextSpan(
                text: 'Plemeno: ',
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                      text: _cat.breed == null ? '' : _cat.breed.name,
                      style: TextStyle(fontWeight: FontWeight.normal)),
                ],
              ),
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
            RichText(
              text: TextSpan(
                text: 'Farba srsti: ',
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                      text: _cat.colour == null ? '' : _cat.colour.name,
                      style: TextStyle(fontWeight: FontWeight.normal)),
                ],
              ),
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
            RichText(
              text: TextSpan(
                text: 'Zdravotný stav: ',
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                      text: _cat.health_status == null
                          ? ''
                          : _cat.health_status.name,
                      style: TextStyle(fontWeight: FontWeight.normal)),
                ],
              ),
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
            RichText(
              text: TextSpan(
                text: 'Kastrovaná: ',
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                      text: _cat.castrated ? bools[1] : bools[0],
                      style: TextStyle(fontWeight: FontWeight.normal)),
                ],
              ),
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
            RichText(
              text: TextSpan(
                text: 'Očkovaná: ',
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                      text: _cat.vaccinated ? bools[1] : bools[0],
                      style: TextStyle(fontWeight: FontWeight.normal)),
                ],
              ),
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
            RichText(
              text: TextSpan(
                text: 'Odčervená: ',
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                      text: _cat.dewormed ? bools[1] : bools[0],
                      style: TextStyle(fontWeight: FontWeight.normal)),
                ],
              ),
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      ),
    );
  }
}
