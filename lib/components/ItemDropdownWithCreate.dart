import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';

class ItemDropdownWithCreate extends StatefulWidget {
  final String hint;
  List<String> items;
  final Function submit;
  final Function onCreate;
  final bool enabled;
  String selected;

  ItemDropdownWithCreate(
    this.hint,
    this.items,
    this.selected,
    this.submit,
    this.onCreate, {
    this.enabled,
  });

  @override
  _ItemDropdownWithCreateState createState() => _ItemDropdownWithCreateState();
}

class _ItemDropdownWithCreateState extends State<ItemDropdownWithCreate> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.hint + ':',
          style: TextStyle(
            color: palette,
            fontSize: 14,
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: DropdownButton<String>(
                icon: Icon(null),
                hint: Text(widget.hint),
                value: widget.selected,
                onChanged: widget.enabled == null || widget.enabled
                    ? (String i) {
                        if (i == '+ Pridať') {
                          widget.onCreate();
                          return;
                        }
                        setState(() {
                          widget.selected = i;
                          widget.submit(i);
                        });
                      }
                    : null,
                items: [
                  ...widget.items.map((String i) {
                    return DropdownMenuItem<String>(
                      value: i,
                      child: Text(i),
                    );
                  }).toList(),
                  DropdownMenuItem<String>(
                    value: '+ Pridať',
                    child: Text('+ Pridať'),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
