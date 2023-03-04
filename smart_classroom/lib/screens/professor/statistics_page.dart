import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/card_button.dart';

import '../../models/professor_model.dart';

class ProfessorStatisticsPage extends StatelessWidget {

  final Professor professor;
  final Firestore _db = Firestore.instance;

  ProfessorStatisticsPage({ @required this.professor });

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        title: Text("Attendance Statisctics"),

      ),
      body: SingleChildScrollView(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            

          ],

        ),

      ),

    );
  }
}