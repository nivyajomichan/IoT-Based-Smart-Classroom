import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './professor/home.dart';
import './student/home.dart';
import '../widgets/login_form.dart';

import '../models/professor_model.dart';
import '../models/student_model.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Widget userWidget = new Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );

  Future<FirebaseUser> _getUser() async{
    return await _auth.currentUser();
  }

  @override
  void initState(){
    super.initState();

    _getUser().then((user) async{
      if(user != null){
        DocumentSnapshot userDocument = await _db.collection("users").document(user.uid).get();
        if(userDocument.data["role"] == "professor"){
          userWidget = new ProfessorHomePage(
            professor: Professor(
              userID: user.uid,
              name: userDocument.data["name"],
              inLecture: userDocument.data["in_lecture"],
              recentLecture: userDocument.data["recent_lecture"]
            )
          );
        }
        else{
          userWidget = new StudentHomePage(
            student: Student(
              userId: user.uid,
              name: userDocument.data["name"],
              id: userDocument.data["id"]
            )
          );
        }
      }

      else{
        userWidget = new Scaffold(
          
          appBar: AppBar(

            title: Text("Login"),

          ),
          body: Container(
            
            decoration: BoxDecoration(

              gradient: LinearGradient(

                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  Colors.lightBlue[400],
                  Colors.lightBlue[300],
                  Colors.lightBlue[200],
                  Colors.lightBlue[200]
                ]

              )

            ),
            child: Center(

              child: Container(

                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(

                  color: Colors.lightBlue[50]

                ),
                child: LoginForm(),

              ),

            ),

          ),

        );
      }

    }).then((_) => setState(() {}));

  }

  @override
  Widget build(BuildContext context) {
    return userWidget;
  }

}