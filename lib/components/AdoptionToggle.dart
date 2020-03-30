import 'package:CiliCat/cat_font_icons.dart';
import 'package:flutter/material.dart';
import 'package:CiliCat/settings.dart';

class AdoptionToggle extends StatefulWidget {
  bool state = true;
  Function callback;

  AdoptionToggle({this.state, this.callback});

  @override
  _AdoptionToggleState createState() => _AdoptionToggleState();
}

class _AdoptionToggleState extends State<AdoptionToggle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          MaterialButton(
            child: Row(
              children: <Widget>[
                Icon(CatFont.try_out),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text('NA ADOPCIU'),
                ),
              ],
            ),
            onPressed: () {
              if (!widget.state) {
                widget.callback(true);
              }
              setState(() {
                widget.state = true;
              });
            },
            color: widget.state ? palette : Colors.white,
          ),
          MaterialButton(
            child: Text('VŠETKY'),
            onPressed: () {
              if (widget.state) {
                widget.callback(false);
              }
              setState(() {
                widget.state = false;
              });
            },
            color: !widget.state ? palette : Colors.white,
          ),
        ],
      ),
    );
  }
}
