import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/card_button.dart';
import './statistics_page.dart';
import './lecture_hall_select.dart';
import '../../widgets/logout_confirm_dialog.dart';
import '../../widgets/end_class_dialog.dart';

import '../../models/professor_model.dart';

class ProfessorHomePage extends StatefulWidget {

  final Professor professor;

  ProfessorHomePage({ @required this.professor });

  @override
  _ProfessorHomePageState createState() => _ProfessorHomePageState();
}

class _ProfessorHomePageState extends State<ProfessorHomePage> {

  Firestore _db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        title: Text("Prof. ${widget.professor.name}"),

      ),
      body: SingleChildScrollView(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            widget.professor.inLecture ? CardButton(

              icon: Icons.cancel,
              color: Colors.red,
              label: "End Class",
              action: () => showDialog(
                context: context,
                builder: (context) => EndClassDialog(professor: widget.professor)
              ),

            )
            :CardButton(

              icon: Icons.school,
              color: Colors.green,
              label: "Start Class",
              action: _showSubjectModal,

            ),
            CardButton(

              icon: Icons.assessment,
              color: Colors.blue,
              label: "View Attendance Statistics",
              action: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfessorStatisticsPage(professor: widget.professor)
                )),

            ),
            CardButton(

              icon: Icons.input,
              color: Colors.red,
              label: "Logout",
              action: () => showDialog(
                context: context,
                builder: (context) => LogoutConfirmDialog()
              )

            )
          ],

        ),

      ),

    );
  }

  void _showSubjectModal(){

    showModalBottomSheet(

      context: context,
      builder: (_){
        return StreamBuilder(

          stream: _db.collection("subjects").where("professor", isEqualTo: widget.professor.userID).where("lock", isEqualTo: false).snapshots(),
          builder: (ctx, snapshot){
            if(snapshot.hasData){
              return Column(

                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  ...snapshot.data.documents.map(
                    (document){
                      return CardButton(

                        label: "${document.data["name"]} (${document.data["batch"]})",
                        action: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LectureHallSelect(professor: widget.professor, subjectId: document.documentID, subjectName: document.data["name"])
                        )),

                      );
                    }
                  ).toList()

                ],

              );
            }
            else{
              return Center(
                child: Text("Seems you are free roght now!"),
              );
            }
          },

        );
      }

    );

  }

}