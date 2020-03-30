import 'dart:ui';

import 'package:CiliCat/components/Heading1.dart';
import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';

class FilterDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 5,
        sigmaY: 5,
      ),
      child: Container(
        child: AlertDialog(
          title: Center(child: Heading1('Rozšírené filtrovanie')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  'Prosím potvrďte svoju e-mailovú adresu pomocou odkazu, ktorý Vám bol odoslaný.'),
              SizedBox(
                height: 10,
              ),
              Text('Následne sa môžete prihlásiť!'),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Colors.white,
                    textColor: palette,
                    child: const Text('Zrušiť'),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: palette,
                    textColor: Colors.white,
                    child: const Text('Aplikovať filtre'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
