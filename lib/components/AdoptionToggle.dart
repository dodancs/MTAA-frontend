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
              setState(() {
                widget.state = true;
              });
              widget.callback(widget.state);
            },
            color: widget.state ? palette : Colors.white,
          ),
          MaterialButton(
            child: Text('VŠETKY'),
            onPressed: () {
              setState(() {
                widget.state = false;
              });
              widget.callback(widget.state);
            },
            color: !widget.state ? palette : Colors.white,
          ),
        ],
      ),
    );
  }
}
