import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/professor_model.dart';
import '../../widgets/card_button.dart';
import '../../widgets/preview_dialog.dart';

class LectureHallSelect extends StatelessWidget {

  final Professor professor;
  final String subjectId;
  final String subjectName;
  final Firestore _db = Firestore.instance;

  LectureHallSelect({
     @required this.professor,
     @required this.subjectId,
     @required this.subjectName
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        title: Text("Select Lecture Hall"),

      ),
      body: SingleChildScrollView(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            StreamBuilder(

              stream: _db.collection("classrooms").where("lecture_status", isEqualTo: false).snapshots(),
              builder: (ctx, snapshot){
                if(snapshot.hasData){
                  return Column(

                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      ...snapshot.data.documents.map(
                        (document){
                          return CardButton(
                            label: document.documentID,
                            action: () => showDialog(
                              context: context,
                              builder: (context) => PrieviewDialog(
                                professor: professor,
                                subjectId: subjectId,
                                subjectName: subjectName,
                                lectureHall: document.documentID,
                              )
                            ),
                          );
                        }
                      ).toList()

                    ],

                  );
                }
                else{
                  return(
                    Center(

                      child: Text("No Lecture Hall Available"),

                    )
                  );
                }
              },

            )

          ],

        ),

      ),

    );
  }
}