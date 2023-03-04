import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../screens/professor/home.dart';
import '../screens/student/home.dart';

import '../models/professor_model.dart';
import '../models/student_model.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _email, _password;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return !_isLoading ? Form(

      key: _formKey,
      child: LayoutBuilder(

        builder: (ctx, constraints){
          return Column(

            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Container(

                width: constraints.maxWidth * 0.85,
                child: TextFormField(

                  validator: (value){
                    if(value.isEmpty){
                      return "Enter Email ID";
                    }
                    return null;
                  },
                  decoration: InputDecoration(

                    labelText: "Email ID"

                  ),
                  onSaved: (value) => _email = value,
                  keyboardType: TextInputType.emailAddress,

                ),

              ),
              Container(

                width: constraints.maxWidth * 0.85,
                child: TextFormField(

                  validator: (value){
                    if(value.isEmpty){
                      return "Enter Password";
                    }
                    return null;
                  },
                  decoration: InputDecoration(

                    labelText: "Password"

                  ),
                  obscureText: true,
                  onSaved: (value) => _password = value,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).unfocus();
                    _logIn().then((userScreen){
                      if(userScreen == null){
                        setState(() {
                         _isLoading = false; 
                        });
                      }
                      else Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => userScreen));
                    });
                  },

                ),

              ),
              Container(

                width: constraints.maxWidth * 0.85,
                child: RaisedButton(

                  onPressed: () => _logIn().then((userScreen){
                    if(userScreen == null){
                      setState(() {
                       _isLoading = false; 
                      });
                    }
                    else Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => userScreen));
                  }),
                  color: Colors.blue,
                  child: Text(

                    "Login",
                    style: TextStyle(

                      fontWeight: FontWeight.bold,
                      color: Colors.white,

                    ),

                  ),

                ),

              )

            ],

          );
        },

      ),

    )
    : Center(

      child: CircularProgressIndicator(),

    );
  }

  Future<Widget> _logIn() async{


    Firestore _db = Firestore.instance;

    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
    }

    setState(() {
     _isLoading = true; 
    });

    try{
      AuthResult _authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
      String _userId = _authResult.user.uid;
      DocumentSnapshot _userDocument = await _db.collection("users").document(_userId).get();
      if(_userDocument.data["role"] == "professor"){
        return ProfessorHomePage(
          professor: Professor(
            userID: _userId,
            name: _userDocument.data["name"],
            inLecture: _userDocument.data["in_lecture"],
            recentLecture: _userDocument.data["recent_lecture"]
          )
        );
      }
      else{
        return StudentHomePage(
          student: Student(
            userId: _userId,
            name: _userDocument.data["name"],
            id: _userDocument.data["id"]
          )
        );
      }
    }
    catch(authentication_error){

      String errorMessage;

      if(authentication_error.runtimeType == PlatformException){
        switch(authentication_error.code){
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Invalid Email ID";
          break;

        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User Not Found";
          break;

        case "ERROR_INVALID_PASSWORD":
          errorMessage = "Invalid Password";
          break;

        default:
          errorMessage = "Someting Went Wrong";
          break;
        }
      }
      else{
        errorMessage = "Someting Went Wrong";
      }

      showDialog(

        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(

            title: Text("Error"),
            content: Text(errorMessage),
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
    finally{
      _email = "";
      _password = "";
    }

  }

}