import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/professor/home.dart';

import '../models/professor_model.dart';

class PrieviewDialog extends StatefulWidget {

  final Professor professor;
  final String subjectId;
  final String subjectName;
  final String lectureHall;

  PrieviewDialog({
    @required this.professor,
    @required this.subjectId,
    @required this.subjectName,
    @required this.lectureHall
  });

  @override
  _PrieviewDialogState createState() => _PrieviewDialogState();
}

class _PrieviewDialogState extends State<PrieviewDialog> {

  Firestore _db = Firestore.instance;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return !_isLoading ? AlertDialog(

      title: Text("Preview"),
      content: Text("Start Class for ${widget.subjectName} in ${widget.lectureHall}"),
      actions: <Widget>[

        FlatButton(

          onPressed: () => Navigator.of(context).pop(),
          child: Text(

            "Cancel",
            style: TextStyle(

              fontSize: 16.0,
              color: Colors.red

            ),

          ),

        ),
        FlatButton(

          onPressed: () => _startClass().then((_){
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => ProfessorHomePage(professor: widget.professor)
              ),
              (_) => false);
          }),
          child: Text(
            
            "Confirm",
            style: TextStyle(

              fontSize: 16.0

            ),

            ),

        )

      ],

    )
    : Center(

      child: CircularProgressIndicator()

    );
  }

  Future<void> _startClass() async{

    setState(() {
     _isLoading = true; 
    });

    try{
      await _db.collection("classrooms").document(widget.lectureHall).updateData({
        "lecture_status": true
      });

      await _db.collection("subjects").document(widget.subjectId).updateData({
        "lectures_conducted": FieldValue.increment(1)
      });

      String lectureId = DateTime.now().millisecondsSinceEpoch.toString();

      await _db.collection("users").document(widget.professor.userID).updateData({
        "in_lecture": true,
        "recent_lecture": lectureId
      });
      widget.professor.inLecture = true;
      widget.professor.recentLecture = lectureId;

      DocumentSnapshot subjectDocument = await _db.collection("subjects").document(widget.subjectId).get();
      String branch = subjectDocument.data["department"];
      String batch = subjectDocument.data["batch"];

      await _db.collection("departments").document(branch).updateData({
        batch:{
          "lecture_status": true,
          "subject": widget.subjectId,
          "lecture_id": lectureId
        }
      });

      await _db.collection("lectures").document(lectureId).setData({
        "batch": batch,
        "department": branch,
        "lecture_hall": widget.lectureHall,
        "professor": widget.professor.userID,
        "subject": widget.subjectId
      });

      QuerySnapshot subjectQuery = await _db.collection("subjects").where("batch", isEqualTo: batch).where("department", isEqualTo: branch).getDocuments();
      subjectQuery.documents.forEach((document) async{
        await _db.collection("subjects").document(document.documentID).updateData({
          "lock": true
        });
      });
    }
    catch(e){
      setState((){
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Something Went Wrong, Please Try Again!"),
            actions: <Widget>[

              FlatButton(

                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),

              )

            ],
          );
        }
        );
    }
  }

}