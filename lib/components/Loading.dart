import 'dart:ui';

import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          width: 100,
          height: 100,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            elevation: 10,
            child: SpinKitThreeBounce(
              color: palette[50],
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}
