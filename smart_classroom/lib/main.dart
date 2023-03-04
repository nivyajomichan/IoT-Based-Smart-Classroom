import 'package:flutter/material.dart';

import './screens/login_page.dart';

void main() => runApp(SmartClassroom());

class SmartClassroom extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: LoginPage(),

    );
  }
}