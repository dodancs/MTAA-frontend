import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';

class ItemDropdown extends StatefulWidget {
  final String hint;
  final List<String> items;
  final Function callback;
  final bool noDefault;
  final bool enabled;
  String selected;

  ItemDropdown(
    this.hint,
    this.items,
    this.selected,
    this.callback, {
    this.noDefault,
    this.enabled,
  });

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
                hint: widget.noDefault != null && widget.noDefault
                    ? Text(widget.hint)
                    : Text('Všetky'),
                value: widget.selected,
                onChanged: widget.enabled == null || widget.enabled
                    ? (String i) {
                        setState(() {
                          widget.selected = i;
                          widget.callback(i);
                        });
                      }
                    : null,
                items: widget.items.map((String i) {
                  return DropdownMenuItem<String>(
                    value: i,
                    child: Text(i),
                  );
                }).toList(),
              ),
            ),
            widget.noDefault != null && widget.noDefault
                ? Container()
                : SizedBox(
                    width: 10,
                  ),
            widget.noDefault != null && widget.noDefault
                ? Container()
                : IconButton(
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
