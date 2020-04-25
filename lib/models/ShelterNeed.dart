import 'package:flutter/foundation.dart';

class ShelterNeed {
  final String uuid;
  final String name;
  final String category;
  final String details;
  final bool hide;

  ShelterNeed({
    @required this.uuid,
    @required this.name,
    @required this.category,
    @required this.details,
    @required this.hide,
  });
}
