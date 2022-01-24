import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text("Edit Profile",style: TextStyle(
          fontFamily: "Circular",
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 25
        ),),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 30,),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
