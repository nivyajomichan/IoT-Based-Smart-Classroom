import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/login_page.dart';

class LogoutConfirmDialog extends StatefulWidget {
  @override
  _LogoutConfirmDialogState createState() => _LogoutConfirmDialogState();
}

class _LogoutConfirmDialogState extends State<LogoutConfirmDialog> {

  bool _isLoading = false;

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

              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.red

            ),

          ),

        ),
        FlatButton(

          onPressed: () async {
            setState(() {
             _isLoading = true; 
            });
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
              builder: (context) => LoginPage()
            ),
            (_) => false);
          },
          child: Text(

            "Confirm",
            style: TextStyle(

              fontWeight: FontWeight.bold,
              fontSize: 16.0

            ),

          ),
          
        )

      ],


    )
    :Center(
      
      child: CircularProgressIndicator(),

    );
  }
}