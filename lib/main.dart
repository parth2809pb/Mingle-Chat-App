import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:mingle/helper/helperfunctions.dart';
import 'package:mingle/views/homeScreen.dart';
import 'package:mingle/views/signin.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userIsLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState()async{
    await HelperFunctions.getuserLoggedInSharedPreference().then((val){
      setState(() {
        if(val != null){
          userIsLoggedIn = val;
        }

      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mingle Chat',
      theme: ThemeData(
        primaryColor: Color(0xff416d6d),
        accentColor: Color(0xFFFEF9EB),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn ? ChatRoom() : SignIn() ,
    );
  }
}



