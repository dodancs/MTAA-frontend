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
            child: Text('NA ADOPCIU'),
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
