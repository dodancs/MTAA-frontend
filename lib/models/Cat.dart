import 'package:CiliCat/models/Breed.dart';
import 'package:CiliCat/models/Colour.dart';
import 'package:CiliCat/models/HealthStatus.dart';
import 'package:flutter/foundation.dart';

enum Sex {
  male,
  female,
}

class Cat {
  String uuid;
  String name;
  int age;
  Sex sex;
  Breed breed;
  HealthStatus health_status;
  bool castrated;
  bool vaccinated;
  bool dewormed;
  Colour colour;
  String description;
  String health_log;
  bool adoptive;
  List<String> pictures;

  Cat({
    @required this.uuid,
    @required this.name,
    @required this.age,
    @required this.sex,
    @required this.description,
    @required this.adoptive,
    @required this.pictures,
    this.breed,
    this.health_status,
    this.castrated,
    this.vaccinated,
    this.dewormed,
    this.colour,
    this.health_log,
  });
}
