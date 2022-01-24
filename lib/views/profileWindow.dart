import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mingle/helper/helperfunctions.dart';
import 'package:mingle/services/database.dart';
import 'package:mingle/services/navigation_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'editProfile.dart';
import 'package:image_cropper/image_cropper.dart';


class ProfileWindow extends StatefulWidget with NavigationState{
  @override
  _ProfileWindowState createState() => _ProfileWindowState();
}

class _ProfileWindowState extends State<ProfileWindow> {

  File imagefile;
  final ImagePicker _picker = ImagePicker();

  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;
  String myName = "";
  String myUserName = "";
  String myImage = "";
  String myEmail = "";
  String myUid = "";

  TextEditingController usernameTextEditingController = new TextEditingController();
  //TextEditingController emailTextEditingController = new TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }



  getUserInfo()async{

    myName = await HelperFunctions.getuserDisplaySharedPreference();
    myImage = await HelperFunctions.getuserProfileSharedPreference();
    myEmail = await HelperFunctions.getuserEmailSharedPreference();
    myUserName = await HelperFunctions.getuserNameSharedPreference();
    if (FirebaseAuth.instance.currentUser != null){
      myUid = FirebaseAuth.instance.currentUser.uid;
    }


    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        isDrawerOpen
            ? setState(() {
          xOffset = 0;
          yOffset = 0;
          scaleFactor = 1;
          isDrawerOpen = false;
        })
            : null;
      },
      child: AnimatedContainer(
        transform: Matrix4.translationValues(xOffset, yOffset, 0)
          ..scale(scaleFactor),
        duration: Duration(milliseconds: 250),
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0)),
        child: Column(children: [
          SizedBox(height: 50),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                isDrawerOpen
                    ? IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.black,
                    onPressed: () {
                      setState(() {
                        xOffset = 0;
                        yOffset = 0;
                        scaleFactor = 1;
                        isDrawerOpen = false;
                      });
                    })
                    : IconButton(
                  icon: Icon(Icons.menu),
                  iconSize: 30.0,
                  color: Colors.black,
                  onPressed: () {
                    setState(() {
                      xOffset = 230;
                      yOffset = 150;
                      scaleFactor = 0.6;
                      isDrawerOpen = true;
                    });
                  },
                ),
                SizedBox(
                  width: 80,
                ),
                Column(
                  children: [
                    Text(
                      'My Profile',
                      style: TextStyle(
                        fontFamily: 'Circular',
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 30,),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft : isDrawerOpen ? Radius.circular(40) : Radius.circular(0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30,),
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: (imagefile!=null)? FileImage(imagefile) :NetworkImage(myImage),
                          radius: 100,
                        ),
                        Positioned(
                          bottom: 10,
                            right: 10,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey[300],
                              child: IconButton(
                                onPressed: (){
                                  showModalBottomSheet(context: context,
                                      builder: ((builder) => bottomSheet()) );
                                },
                                icon: Icon(Icons.edit,size: 30,color: Colors.black),
                              ),
                            )),
                      ],
                    ),
                    SizedBox(height: 50,),
                    Container(
                      width: 350,
                      height: 2,
                      color: Colors.green,
                    ),
                    SizedBox(height: 20,),

                    Form(
                      key: formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (val){
                              return val.isEmpty || val.length<4 ? "Name can't be empty" : null;
                            },
                            controller: usernameTextEditingController,
                            //textAlign: TextAlign.center,

                            decoration: InputDecoration(
                              border: InputBorder.none,
                                hintText: myName,
                                hintStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Circular',
                                  color: Colors.blueGrey,
                                ),

                                contentPadding: EdgeInsets.only(top: 14),
                              prefixIcon: Icon(Icons.person),

                            ),
                          ),
                          SizedBox(height: 50),
                          // TextFormField(
                          //   validator: (val){
                          //     return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          //         .hasMatch(val) ? null : "Enter a valid E-mail.";
                          //   },
                          //   controller: emailTextEditingController,
                          //   //textAlign: TextAlign.center,
                          //   decoration: InputDecoration(
                          //     border: InputBorder.none,
                          //
                          //       hintText: myEmail,
                          //       hintStyle: TextStyle(
                          //         fontSize: 20,
                          //         fontWeight: FontWeight.bold,
                          //         fontFamily: 'Circular',
                          //         color: Colors.blueGrey,
                          //       ),
                          //
                          //       contentPadding: EdgeInsets.only(top: 14),
                          //     prefixIcon: Icon(Icons.mail),
                          //
                          //
                          //   ),
                          // ),


                        ],
                      ),
                    ),
                    SizedBox(height: 30,),
                    GestureDetector(
                      onTap: (){
                        uploadImage();
                      },
                      child: Container(
                        width: 350,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Center(
                          child: isLoading ?CircularProgressIndicator() : Text(
                            "Save",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              fontFamily: "Circular",
                              letterSpacing: 1.5
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

          ),

        ]),
      ),
    );
  }

bool isLoading = false;


  Future uploadImage()async{
    if(imagefile==null) return;
    final fileName = imagefile.path.split('/').last;
    final destination = 'files/$fileName';



    setState(() {
      isLoading = true;
    });

    final snapshot = await DatabaseMethods().UploadUserImage(destination, imagefile);
    final urlDownload = await snapshot.ref.getDownloadURL();
    await HelperFunctions.saveuserProfileSharedPreference(urlDownload);

    if(usernameTextEditingController.text == null){
      setState(() {
        usernameTextEditingController.text = myName;
      });
    }


    if(formkey.currentState.validate()){


      Map<String, dynamic> userInfoMap = {
        //"email": emailTextEditingController.text,
        //"user": emailTextEditingController.text.replaceAll("@gmail.com", ""),
        "displayname": usernameTextEditingController.text,
        "profile": urlDownload,
      };
      await DatabaseMethods().updateUserInfo(myUid,userInfoMap);
      //HelperFunctions.saveuserNameSharedPreference(emailTextEditingController.text.replaceAll("@gmail.com", ""));
      HelperFunctions.saveuserDisplaySharedPreference(usernameTextEditingController.text);
      //HelperFunctions.saveuserEmailSharedPreference(emailTextEditingController.text);
    }




    setState(() {
      isLoading = false;
    });


  }


  Future<void> takePhoto(ImageSource source)async{
    final pickedFile = await _picker.getImage(source: source);
    setState((){
      if(pickedFile != null){
        imagefile = File(pickedFile.path);
        print("Image Address :  $imagefile");
        //HelperFunctions.saveuserProfileSharedPreference();
      }


    });
  }


  Widget bottomSheet(){
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      child: Column(
        children: [
          Text("Choose Profile Picture",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: "Circular"
            ),
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                  onPressed: (){
                    takePhoto(ImageSource.camera);
                  },
                  icon: Icon(FontAwesomeIcons.camera,color: Colors.green,),
                label: Text("Camera",style: TextStyle(color: Colors.black,),),
              ),
              TextButton.icon(
                onPressed: (){
                  takePhoto(ImageSource.gallery);
                },
                icon: Icon(FontAwesomeIcons.image,color: Colors.green,),
                label: Text("Gallery",style: TextStyle(color: Colors.black,),),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
