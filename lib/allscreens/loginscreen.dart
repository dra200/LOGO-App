import 'package:capcafe_app/allscreens/mainscreen.dart';
import 'package:capcafe_app/allscreens/regscreen.dart';
import 'package:capcafe_app/allwiges/progressDilog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

// ignore: must_be_immutable
class Loginscreen extends StatelessWidget {
  static const String idscreen = "logscreen" ;
  TextEditingController  emailTextEditingController = TextEditingController();
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
                  width: 200.0,
                  height: 200.0,
                  alignment: Alignment.center,
                ),

                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(height: 10.0,),
                      Text("login as Service owner" ,
                        style:TextStyle(fontSize: 66 , fontFamily: "Signatra") ,
                        textAlign: TextAlign.center,

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
                              "log in " ,
                              style: TextStyle(fontSize: 25.0, fontFamily: "Brand Bold"),
                            ),
                          ),
                        ),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                        onPressed: () {
                          if (!emailTextEditingController.text.contains("@"))
                          {
                            displaytoastmessage("emile is not valid ", context);
                          }
                          else if (passwordTextEditingController.text.isEmpty)
                          {
                            displaytoastmessage(" enter you password ", context);
                          }
                          else
                            {
                              LoginAndAuthentUser(context) ;

                            }
                        },
                      ),
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: (){
                   Navigator.pushNamedAndRemoveUntil(context, regscreen.idscreen, (route) => false);
                  },
                    child:Text(
                      "don't have any account ? creat one "


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
  void LoginAndAuthentUser(BuildContext context) async
  {
    showDialog(
      context: context ,
      barrierDismissible: false ,
      builder: (BuildContext context ) {
       return  progressDilog(massage: "you login plz wait.... ",);
      }
    );
    final User firebaseuser = (await _firebaseAuth
        .signInWithEmailAndPassword
      (email: emailTextEditingController.text,
        password: passwordTextEditingController.text).
    catchError((errormsg)
    { Navigator.pop(context);
      displaytoastmessage("error"+errormsg.toString(), context);
    })).user;

    if (User != null)
    {
      userRef.child(firebaseuser.uid).once().then( (DataSnapshot snap) {
        if ( snap.value != null)
        {
          Navigator.pushNamedAndRemoveUntil(context, mainscreen.idscreen , (route) => false);
          displaytoastmessage("welcome back ", context);
        }
        else
          {
            Navigator.pop(context);
            _firebaseAuth.signOut();
            displaytoastmessage("OPS plz creat new account ", context);
          }
      } );
    }
    else
      Navigator.pop(context);
    displaytoastmessage(" error you can not sign in try agine or text us ", context);
  }
}
