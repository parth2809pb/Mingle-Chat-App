
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mingle/helper/helperfunctions.dart';
import 'package:mingle/services/auth.dart';
import 'package:mingle/services/database.dart';
import 'homeScreen.dart';





class SignIn extends StatefulWidget {



  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  final formkey = GlobalKey<FormState>();

  List<Color> _colors = [Colors.black, Colors.grey[900], Colors.grey[800], Colors.white];
  List<double> _stops = [0.0,0.3,0.6, 1];

  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  signIn(){
    if(formkey.currentState.validate()){

      HelperFunctions.saveuserEmailSharedPreference(emailTextEditingController.text);
      //HelperFunctions.saveuserNameSharedPreference(usernameTextEditingController.text);



      databaseMethods.getUserByUserEmail(emailTextEditingController.text).then((val){
        snapshotUserInfo = val;
        HelperFunctions.saveuserNameSharedPreference(snapshotUserInfo.docs[0].data()["user"]);
      });

      setState(() {
        isLoading=true;
      });



      authMethods.signInWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val)async{
        if (val != null) {


          await HelperFunctions.saveuserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ChatRoom()));
        }
      });


    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.grey[900],

          body:isLoading ? Container(
            child: Center(child: CircularProgressIndicator(
              backgroundColor: Colors.green,
            )),
          ) : GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),


                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 70),
                        Text("Mingle",
                        style: TextStyle(

                          color: Colors.white60,
                          fontFamily: "Circular",
                          fontSize: 50,
                        ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          color: Colors.green,
                          height: 2,
                          width: 400,
                        ),
                        SizedBox(height: 10),
                        Text("Chat with freedom.",
                          style: TextStyle(

                            color: Colors.white60,
                            fontFamily: "Circular",
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(height: 40),
                        // Text("Hello",
                        //   style: TextStyle(
                        //
                        //     color: Colors.grey[400],
                        //     fontSize: 60,
                        //     fontWeight: FontWeight.bold,
                        //     fontFamily: "Circular",
                        //
                        //   ),
                        // ),
                        // Row(
                        //   children: [
                        //     Text("There",
                        //     style: TextStyle(
                        //       color: Colors.grey[400],
                        //       fontSize: 70,
                        //       fontWeight: FontWeight.bold,
                        //       fontFamily: "Circular",
                        //     ),
                        //     ),
                        //     Text(".",
                        //       style: TextStyle(
                        //         color: Colors.green,
                        //         fontSize: 70,
                        //         fontWeight: FontWeight.bold,
                        //         //fontFamily: "Circular",
                        //       ),
                        //     ),
                        //
                        //   ],
                        // ),
                        SizedBox(height: 170),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 100),
                            Text("Login with",
                              style: TextStyle(
                                color: Colors.white60,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Circular"

                              ),),
                            SizedBox(height: 30),
                            Container(
                                width:400,
                                height: 50,

                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: IconButton(
                                  icon: Image.asset("images/google.png"),
                                  onPressed: (){
                                    AuthMethods().signInWithGoogle(context);
                                    setState(() {
                                      isLoading = true;
                                    });
                                  },
                                )

                            ),
                            SizedBox(height: 30),
                            // Container(
                            //     width:400,
                            //     height: 50,
                            //
                            //     decoration: BoxDecoration(
                            //       color: Colors.green,
                            //       borderRadius: BorderRadius.circular(30.0),
                            //     ),
                            //     child: IconButton(
                            //       icon: Image.asset("images/facebook.png"),
                            //       onPressed: (){
                            //         AuthMethods().SignInWithFacebook(context);
                            //       },
                            //     )
                            //
                            // ),
                          ],
                        )






                        // Container(
                        //   height: 450,
                        //   margin: EdgeInsets.symmetric(horizontal: 10),
                        //   padding: EdgeInsets.symmetric(horizontal: 24),
                        //   decoration: BoxDecoration(
                        //     color: Theme.of(context).accentColor,
                        //     borderRadius: BorderRadius.only(
                        //       topLeft: Radius.circular(30.0),
                        //       topRight: Radius.circular(30.0),
                        //       bottomLeft: Radius.circular(30.0),
                        //       bottomRight: Radius.circular(30.0),
                        //     ),
                        //   ),
                        //   child: Column(
                        //     children: [
                        //       SizedBox(height: 50),
                        //       Form(
                        //         key: formkey,
                        //         child: Column(
                        //           children: [
                        //             TextFormField(
                        //               validator: (val){
                        //                 return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        //                     .hasMatch(val) ? null : "Enter a valid E-mail.";
                        //               },
                        //               controller: emailTextEditingController,
                        //               decoration: InputDecoration(
                        //                   hintText: 'E-mail',
                        //                   hintStyle: TextStyle(
                        //                     fontWeight: FontWeight.bold,
                        //                     fontFamily: 'Circular',
                        //                     color: Colors.blueGrey,
                        //                   ),
                        //
                        //                   contentPadding: EdgeInsets.only(top: 14),
                        //                   prefixIcon: Icon(Icons.mail)
                        //
                        //               ),
                        //             ),
                        //             SizedBox(height: 20),
                        //             TextFormField(
                        //               obscureText: true,
                        //               validator: (val){
                        //                 return val.length>6 ? null : "Password should have more than 6 characters.";
                        //               },
                        //               controller: passwordTextEditingController,
                        //               decoration: InputDecoration(
                        //                 hintText: 'Password',
                        //                 hintStyle: TextStyle(
                        //                   fontWeight: FontWeight.bold,
                        //                   fontFamily: 'Circular',
                        //                   color: Colors.blueGrey,
                        //                 ),
                        //
                        //                 contentPadding: EdgeInsets.only(top: 14),
                        //                 prefixIcon: Icon(Icons.lock),
                        //
                        //               ),
                        //             ),
                        //             SizedBox(height: 40),
                        //           ],
                        //         ),
                        //       ),
                        //       Container(
                        //         width:400,
                        //         height: 50,
                        //
                        //         decoration: BoxDecoration(
                        //           color: Theme.of(context).primaryColor,
                        //           borderRadius: BorderRadius.circular(30.0),
                        //         ),
                        //         child: FlatButton(
                        //           onPressed: (){
                        //             signIn();
                        //           },
                        //           padding: EdgeInsets.only(right: 0),
                        //           child: Text(
                        //             'Sign In',
                        //             style: TextStyle(
                        //               fontWeight: FontWeight.bold,
                        //               fontFamily: 'Circular',
                        //               color: Colors.white,
                        //               fontSize: 22,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       SizedBox(height: 30),
                        //       Text(
                        //           'or',
                        //         style: TextStyle(
                        //           color: Colors.blueGrey,
                        //           fontSize: 18,
                        //           fontWeight: FontWeight.bold,
                        //           letterSpacing: 1.2,
                        //         ),
                        //       ),
                        //       SizedBox(height: 30),
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           CircleAvatar(
                        //             radius: 35.0,
                        //             backgroundImage: AssetImage('images/google_logo.jpg'),
                        //             child: IconButton(
                        //               padding: EdgeInsets.zero,
                        //               icon: Icon(Icons.add),
                        //               iconSize: 1,
                        //               onPressed: (){
                        //                 AuthMethods().signInWithGoogle(context);
                        //               },
                        //             ),
                        //           ),
                        //           SizedBox(width: 50),
                        //           CircleAvatar(
                        //             radius: 35.0,
                        //             backgroundImage: AssetImage('images/facebook_logo.jpg'),
                        //             child: IconButton(
                        //               padding: EdgeInsets.zero,
                        //               icon: Icon(Icons.add),
                        //               iconSize: 1,
                        //               onPressed: (){
                        //
                        //               },
                        //             ),
                        //           ),
                        //         ],
                        //       )
                        //     ],
                        //   ),
                        //
                        // ),
                        // SizedBox(height: 30),
                        // Text('New User? Sign Up here.',
                        //   style: TextStyle(
                        //     fontFamily: 'Circular',
                        //       color: Colors.white,
                        //     fontSize: 15.0,
                        //     fontWeight: FontWeight.w600,
                        //   ),),
                        // SizedBox(height: 10),
                        // Container(
                        //   margin: EdgeInsets.symmetric(horizontal: 10,),
                        //   width:400,
                        //   height: 50,
                        //
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.circular(30.0),
                        //   ),
                        //   child: FlatButton(
                        //     onPressed: (){
                        //       widget.toggle();
                        //     },
                        //     padding: EdgeInsets.only(right: 0),
                        //     child: Text(
                        //       'Sign Up',
                        //       style: TextStyle(
                        //         fontWeight: FontWeight.bold,
                        //         fontFamily: 'Circular',
                        //         color: Colors.blueGrey,
                        //         fontSize: 22,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),


            ),
          ),

    );
  }


}
