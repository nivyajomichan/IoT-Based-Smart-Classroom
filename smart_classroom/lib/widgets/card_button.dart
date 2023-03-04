import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {

  final IconData icon;
  final Color color;
  final String label;
  final Function action;

  CardButton({
    this.icon,
    this.color,
    @required this.label,
    @required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.2,
      child: Card(

        elevation: 5,
        child: FlatButton(

          onPressed: this.action,
          child: this.icon == null ? Text(

            this.label,
            style: TextStyle(

              fontWeight: FontWeight.bold,
              fontSize: 16.0

            ),

          )
          : Row(

            children: <Widget>[

              Container(

                margin: EdgeInsets.all(20.0),
                child: Icon(

                  this.icon,
                  color: this.color,
                  size: MediaQuery.of(context).size.height * 0.05,

                ),

              ),
              Container(

                margin: EdgeInsets.all(10.0),
                child: Text(

                  this.label,
                  style: TextStyle(

                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: this.color

                  ),

                ),

              )  

            ],

          )

        ),

      ),

    );
  }
}