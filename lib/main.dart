import 'dart:developer';
import 'dart:math';

import 'package:capcafe_app/DateHandler/appDate.dart';
import 'package:capcafe_app/allscreens/loginscreen.dart';
import 'package:capcafe_app/allscreens/mainscreen.dart';
import 'package:capcafe_app/allscreens/regscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


DatabaseReference userRef = FirebaseDatabase.instance.reference().child("User");


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => appDate(),

      child: MaterialApp(
        title: 'USER 1',
        theme: ThemeData(
          fontFamily: "Brand-Bold",

          primarySwatch: Colors.blue,
        ),
        initialRoute:Loginscreen.idscreen ,
        routes:{
          regscreen.idscreen : (context)=>regscreen(),
          Loginscreen.idscreen : (context)=>Loginscreen(),
          mainscreen.idscreen : (context)=>mainscreen(),
        },
        debugShowCheckedModeBanner:false  ,
      ),
    );
  }
}
