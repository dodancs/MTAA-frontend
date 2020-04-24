import 'package:CiliCat/models/Breed.dart';
import 'package:CiliCat/models/Colour.dart';
import 'package:CiliCat/models/HealthStatus.dart';
import 'package:flutter/foundation.dart';

class Cat {
  String uuid;
  String name;
  int age;
  bool sex;
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
  int commentsNum;

  Cat({
    this.uuid,
    @required this.name,
    @required this.age,
    @required this.sex,
    @required this.description,
    @required this.adoptive,
    @required this.pictures,
    this.commentsNum,
    @required this.breed,
    @required this.health_status,
    @required this.castrated,
    @required this.vaccinated,
    @required this.dewormed,
    @required this.colour,
    @required this.health_log,
  });
}
