import 'dart:ffi';

import 'package:flutter/material.dart';


class progressDilog extends StatelessWidget
{
  String massage;
  progressDilog ({this.massage});
  @override
  Widget build(BuildContext context) {
    return Dialog (
      backgroundColor: Colors.lightBlue,
      child: Container(
        margin: EdgeInsets.all(10.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white ,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              SizedBox (width: 6.0 ) ,
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
              SizedBox(width: 26.0,) ,
              Text (
                massage ,
                style: TextStyle (color: Colors.black , fontSize: 19.0 ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
