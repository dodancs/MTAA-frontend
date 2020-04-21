import 'dart:ui';
import 'package:CiliCat/components/Heading1.dart';
import 'package:CiliCat/components/ItemDropdown.dart';
import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final List<String> breeds;
  final List<String> colours;
  final List<String> health_statuses;
  final Function onUpdate;

  String currentSex;
  String currentBreed;
  String currentColour;
  String currentHealthStatus;
  String currentCastrated;
  String currentVaccinated;
  String currentDewormed;
  RangeValues currentAge;

  FilterDialog({
    @required this.breeds,
    @required this.colours,
    @required this.health_statuses,
    @required this.onUpdate,
    this.currentSex,
    this.currentBreed,
    this.currentColour,
    this.currentHealthStatus,
    this.currentCastrated,
    this.currentVaccinated,
    this.currentDewormed,
    this.currentAge,
  });

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  RangeLabels labels = RangeLabels('0 rokov', '25 rokov');

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
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ItemDropdown(
                    'Pohlavie',
                    sexes,
                    widget.currentSex,
                    (e) => (widget.currentSex = e),
                  ),
                  SizedBox(height: 10),
                  ItemDropdown(
                    'Plemeno',
                    widget.breeds,
                    widget.currentBreed,
                    (e) => (widget.currentBreed = e),
                  ),
                  SizedBox(height: 10),
                  ItemDropdown(
                    'Farba srsti',
                    widget.colours,
                    widget.currentColour,
                    (e) => (widget.currentColour = e),
                  ),
                  SizedBox(height: 10),
                  ItemDropdown(
                    'Zdravotný stav',
                    widget.health_statuses,
                    widget.currentHealthStatus,
                    (e) => (widget.currentHealthStatus = e),
                  ),
                  SizedBox(height: 10),
                  ItemDropdown(
                    'Kastrovaná',
                    bools,
                    widget.currentCastrated,
                    (e) => (widget.currentCastrated = e),
                  ),
                  SizedBox(height: 10),
                  ItemDropdown(
                    'Očkovaná',
                    bools,
                    widget.currentVaccinated,
                    (e) => (widget.currentVaccinated = e),
                  ),
                  SizedBox(height: 10),
                  ItemDropdown(
                    'Odčervená',
                    bools,
                    widget.currentDewormed,
                    (e) => (widget.currentDewormed = e),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Vek:',
                    style: TextStyle(
                      color: palette,
                      fontSize: 14,
                    ),
                  ),
                  RangeSlider(
                    min: 0,
                    max: 240,
                    divisions: 240,
                    values: widget.currentAge,
                    labels: labels,
                    onChanged: (RangeValues v) {
                      setState(() {
                        widget.currentAge = v;
                        labels = RangeLabels(
                            (v.start.toInt() / 12).toStringAsFixed(1) +
                                ' rokov',
                            (v.end.toInt() / 12).toStringAsFixed(1) + ' rokov');
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  MaterialButton(
                    onPressed: () {
                      widget.onUpdate({
                        'sex': widget.currentSex,
                        'breed': widget.currentBreed,
                        'colour': widget.currentColour,
                        'health_status': widget.currentHealthStatus,
                        'castrated': widget.currentCastrated,
                        'vaccinated': widget.currentVaccinated,
                        'dewormed': widget.currentDewormed,
                        'age_up': widget.currentAge.end.toInt(),
                        'age_down': widget.currentAge.start.toInt(),
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Aplikovať filtre'),
                    elevation: 2,
                    color: palette,
                    padding: EdgeInsets.all(10),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
