import 'package:flutter/material.dart';

import '../../models/student_model.dart';

class StudentHomePage extends StatefulWidget {

  final Student student;

  StudentHomePage({ @required this.student });

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}