import 'dart:ffi';

import 'package:capcafe_app/allscreens/loginscreen.dart';
import 'package:capcafe_app/allscreens/mainscreen.dart';
import 'package:capcafe_app/allwiges/progressDilog.dart';
import 'package:capcafe_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;


class regscreen extends StatelessWidget {
  static const String idscreen = "regscreen" ;
  TextEditingController  nameTextEditingController = TextEditingController();
  TextEditingController  emailTextEditingController = TextEditingController();
  TextEditingController  phoneTextEditingController = TextEditingController();
  TextEditingController  cityTextEditingController = TextEditingController();
  TextEditingController  passwordTextEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding:EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 60.0,),
              Image(
                image: AssetImage("logoour.png"),
                width: 220.0,
                height: 220.0,
                alignment: Alignment.center,
              ),

              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(height: 10.0,),
                    Text("Register as a customer" ,
                      style:TextStyle(fontSize: 66 , fontFamily: "Signatra") ,
                      textAlign: TextAlign.center,

                    ),

                    SizedBox(height: 2.0,),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "full name" ,
                        labelStyle: TextStyle(
                          fontSize: 30 ,

                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey ,
                          fontSize: 20 ,
                        ) ,
                      ),
                      style: TextStyle(fontSize: 24.0),
                    ),


                    SizedBox(height: 2.0,),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Emille" ,
                        labelStyle: TextStyle(
                          fontSize: 30 ,

                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey ,
                          fontSize: 20 ,
                        ) ,
                      ),
                      style: TextStyle(fontSize: 24.0),
                    ),

                    SizedBox(height: 2.0,),
                    TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "phone" ,
                        labelStyle: TextStyle(
                          fontSize: 30 ,

                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey ,
                          fontSize: 20 ,
                        ) ,
                      ),
                      style: TextStyle(fontSize: 24.0),
                    ),

                    SizedBox(height: 2.0,),
                    TextField(
                      controller: cityTextEditingController,
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecoration(
                        labelText: "City" ,
                        labelStyle: TextStyle(
                          fontSize: 30 ,

                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey ,
                          fontSize: 20 ,
                        ) ,
                      ),
                      style: TextStyle(fontSize: 24.0),
                    ),



                    SizedBox(height: 2.0,),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,

                      decoration: InputDecoration(
                        labelText: "password" ,
                        labelStyle: TextStyle(
                          fontSize: 30 ,

                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey ,
                          fontSize: 24 ,
                        ) ,
                      ),
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(height: 10.0,),
                    RaisedButton(
                      color: Colors.amber,
                      textColor: Colors.white,
                      child: Container(
                        height: 30.0,
                        child: Center(
                          child:Text(
                            "creat a new account  " ,
                            style: TextStyle(fontSize: 25.0, fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                      ),
                      onPressed: ()
                      {
                        if (nameTextEditingController.text.length < 4 )
                        {
                          displaytoastmessage("Excuse me . Please enter your name with a triple" , context);
                        }
                        else if (!emailTextEditingController.text.contains("@"))
                        {
                          displaytoastmessage("emile is not valid ", context);
                        }
                        else if (phoneTextEditingController.text.isEmpty)
                        {
                          displaytoastmessage(" add your phone ", context);
                        }
                        else if (cityTextEditingController.text.isEmpty)
                        {
                          displaytoastmessage(" add your city ", context);
                        }
                        else if (passwordTextEditingController.text.length <8)
                        {
                          displaytoastmessage("password must be 7 ", context);
                        }
                        else
                        {
                          regisetrNewUser(context);
                        }

                      },
                    ),
                  ],
                ),
              ),
              FlatButton(
                onPressed: (){
                  Navigator.pushNamedAndRemoveUntil(context, Loginscreen.idscreen, (route) => false);
                },
                child:Text(
                    "you have one ? login  "


                ),

                textColor: Colors.black,

              ),


            ],
          ),
        ),
      ),

    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance ;

 void regisetrNewUser(BuildContext context)async
  {
    showDialog(
        context: context ,
        barrierDismissible: false ,
        builder: (BuildContext context ) {
          return  progressDilog(massage: "we creat your account  plz wait ^^ .... ",);
        }
    );
    final User firebaseuser = (await _firebaseAuth
        .createUserWithEmailAndPassword(email: emailTextEditingController.text,
        password: passwordTextEditingController.text).
    catchError((errormsg)
    {
      Navigator.pop(context);
    displaytoastmessage("error"+errormsg.toString(), context);
    })).user;
    if (User != null) // user created
      {
        // save user info to database
      userRef.child(firebaseuser.uid);
      Map userDateMap =
      {
        "name" : nameTextEditingController.text.trim(),
        "email" : emailTextEditingController.text.trim(),
        "phone" : phoneTextEditingController.text.trim(),
        "city" : cityTextEditingController.text.trim(),
      };
      userRef.child(firebaseuser.uid).set(userDateMap);
      displaytoastmessage("your account created", context);
      
      Navigator.pushNamedAndRemoveUntil(context, mainscreen.idscreen , (route) => false);
    }
    else {
      Navigator.pop(context);
      displaytoastmessage("user account has not been created ", context);
    }
  }

}

displaytoastmessage(String message , BuildContext context ){
  Fluttertoast.showToast(msg:message);
}
