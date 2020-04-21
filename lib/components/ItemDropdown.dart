import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';

class ItemDropdown extends StatefulWidget {
  final String hint;
  final List<String> items;
  final Function callback;
  String selected;

  ItemDropdown(this.hint, this.items, this.selected, this.callback);

  @override
  _ItemDropdownState createState() => _ItemDropdownState();
}

class _ItemDropdownState extends State<ItemDropdown> {
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
                hint: Text('Všetky'),
                value: widget.selected,
                onChanged: (String i) {
                  setState(() {
                    widget.selected = i;
                    widget.callback(i);
                  });
                },
                items: widget.items.map((String i) {
                  return DropdownMenuItem<String>(
                    value: i,
                    child: Text(i),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  widget.selected = null;
                  widget.callback(null);
                });
              },
            )
          ],
        )
      ],
    );
  }
}
