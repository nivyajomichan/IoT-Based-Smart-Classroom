import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/professor/home.dart';

import '../models/professor_model.dart';

class EndClassDialog extends StatefulWidget {

  final Professor professor;

  EndClassDialog({ @required this.professor });

  @override
  _EndClassDialogState createState() => _EndClassDialogState();
}

class _EndClassDialogState extends State<EndClassDialog> {

  bool _isLoading = false;
  Firestore _db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return !_isLoading ? AlertDialog(

      title: Text(

        "Are You Sure?",
        style: TextStyle(

          color: Colors.red

        ),
       
      ),
      actions: <Widget>[

        FlatButton(

          onPressed: () => Navigator.of(context).pop(),
          child: Text(

            "Cancel",
            style: TextStyle(

              color: Colors.red,
              fontSize: 16.0

            ),

          ),

        ),
        FlatButton(

          onPressed: () => _endClass().then((_){
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => ProfessorHomePage(professor: widget.professor)
              ),
              (_) => false
              );
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

      child: CircularProgressIndicator(),

    );
  }

  Future<void> _endClass() async{

    setState(() {
     _isLoading = true; 
    });

    DocumentSnapshot lectureDocument = await _db.collection("lectures").document(widget.professor.recentLecture).get();

    try{
      await _db.collection("classrooms").document(lectureDocument.data["lecture_hall"]).updateData({
        "lecture_status": false
      });

      await _db.collection("departments").document(lectureDocument.data["department"]).updateData({
        lectureDocument.data["batch"]: {
          "lecture_id": widget.professor.recentLecture,
          "lecture_status": false,
          "subject": ""
        }
      });

      await _db.collection("users").document(widget.professor.userID).updateData({
        "in_lecture": false
      });
      widget.professor.inLecture = false;

      QuerySnapshot subjectQuery = await _db.collection("subjects").where("batch", isEqualTo: lectureDocument.data["batch"]).where("department", isEqualTo: lectureDocument.data["department"]).getDocuments();
      subjectQuery.documents.forEach((document) async{
        await _db.collection("subjects").document(document.documentID).updateData({
          "lock":false
        });
      });
    }
    catch(e){
      setState(() {
       _isLoading = false; 
      });
      showDialog(

        context: context,
        builder: (context){
          
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