import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mingle/helper/helperfunctions.dart';

import 'package:mingle/services/database.dart';
import 'package:mingle/views/homeScreen.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class AuthMethods {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  getCurrentUser() {
    return _auth.currentUser;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      var auth = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return auth.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<User> signUpWithEmailAndPassword(String email, String password) async {
    try {
      var auth = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      return auth.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    }
    catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      //prefs.clear();
      await _auth.signOut();
      HelperFunctions.saveuserLoggedInSharedPreference(false);
    } catch (e) {
      print(e.toString());
    }
  }

  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn
        .signIn();

    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount
        .authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken
    );

    UserCredential result = await _firebaseAuth.signInWithCredential(
        credential);
    User userDetails = result.user;

    if (result != null) {
      HelperFunctions.saveuserLoggedInSharedPreference(true);
      HelperFunctions.saveuserNameSharedPreference(
          userDetails.email.replaceAll("@gmail.com", ""));
      HelperFunctions.saveuserEmailSharedPreference(userDetails.email);
      HelperFunctions.saveuserIdSharedPreference(userDetails.uid);
      HelperFunctions.saveuserDisplaySharedPreference(userDetails.displayName);
      HelperFunctions.saveuserProfileSharedPreference(userDetails.photoURL);


      Map<String, dynamic> userInfoMap = {
        "email": userDetails.email,
        "user": userDetails.email.replaceAll("@gmail.com", ""),
        "displayname": userDetails.displayName,
        "profile": userDetails.photoURL,
      };


      DatabaseMethods().addUserInfotoDB(userDetails.uid, userInfoMap).then((
          value) {
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => ChatRoom()
        ));
      });
    }
  }


  // static final FacebookLogin facebookSignIn = new FacebookLogin();
  //
  // Future<Null> SignInWithFacebook(BuildContext context) async {
  //   facebookSignIn.loginBehavior = FacebookLoginBehavior.webViewOnly;
  //   final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
  //   final token = result.accessToken.token;
  //   // final graphResponse = await http.get(Uri.https('graph.facebook.com','v2.12/me?fields=name,first_name,email&access_token=${token}'));
  //   // final profile = JSON.jsonDecode(graphResponse.body);
  //   // print(profile);
  //   if (result.status == FacebookLoginStatus.loggedIn) {
  //     final AuthCredential credential = FacebookAuthProvider.credential(token);
  //     final UserCredential authResult = await FirebaseAuth.instance
  //         .signInWithCredential(credential);
  //     User userDetails = authResult.user;
  //     // print(userDetails.email);
  //     // print(userDetails.displayName);
  //     // print(userDetails.uid);
  //     // print(userDetails.photoURL);
  //     if (authResult != null) {
  //       HelperFunctions.saveuserLoggedInSharedPreference(true);
  //       HelperFunctions.saveuserNameSharedPreference(
  //           userDetails.email.replaceAll("@gmail.com", ""));
  //       HelperFunctions.saveuserEmailSharedPreference(userDetails.email);
  //       HelperFunctions.saveuserIdSharedPreference(userDetails.uid);
  //       HelperFunctions.saveuserDisplaySharedPreference(
  //           userDetails.displayName);
  //       HelperFunctions.saveuserProfileSharedPreference(userDetails.photoURL);
  //
  //
  //       Map<String, dynamic> userInfoMap = {
  //         "email": userDetails.email,
  //         "user": userDetails.email.replaceAll("@gmail.com", ""),
  //         "displayname": userDetails.displayName,
  //         "profile": userDetails.photoURL,
  //       };
  //
  //       DatabaseMethods().addUserInfotoDB(userDetails.uid, userInfoMap).then((
  //           value) {
  //         Navigator.pushReplacement(context, MaterialPageRoute(
  //             builder: (context) => ChatRoom()
  //         ));
  //       });
  //     };
  //   }
  // }
}