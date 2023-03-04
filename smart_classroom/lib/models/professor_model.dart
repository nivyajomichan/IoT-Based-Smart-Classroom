import 'package:flutter/material.dart';

class Professor{

  final String userID;
  final String name;
  bool inLecture;
  String recentLecture;

  Professor({
    @required this.userID,
    @required this.name,
    @required this.inLecture,
    @required this.recentLecture
  });

}