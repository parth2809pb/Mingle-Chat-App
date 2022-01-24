import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:mingle/helper/helperfunctions.dart';
import 'package:mingle/models/Config.dart';
import 'package:mingle/services/auth.dart';
import 'package:mingle/services/navigation_bloc.dart';
import 'package:mingle/views/signin.dart';

class DrawerWindow extends StatefulWidget {
  @override
  _DrawerWindowState createState() => _DrawerWindowState();
}

class _DrawerWindowState extends State<DrawerWindow> {

  String _myName = "";
  String _myImage = "";

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo()async{
    _myName = await HelperFunctions.getuserDisplaySharedPreference();
    _myImage = await HelperFunctions.getuserProfileSharedPreference();


    setState(() {

    });
  }



  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(top: 0,bottom: 40,left: 0),
      color: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 60,left: 15,bottom: 20
            ),
            color: Colors.green,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(_myImage),
                  radius: 25,
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_myName,
                      style: TextStyle(
                        fontFamily: 'Circular',
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                    Text("Online",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily:'Circular',
                        fontWeight: FontWeight.w600,

                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),


          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    BlocProvider.of<NavigationBloc>(context).add(NavigationEvent.ChatWindowClickedEvent);

                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(Icons.mail,
                          size: 30,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text("Messages",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Circular',
                              fontWeight: FontWeight.bold,
                              fontSize: 20

                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: (){
                    BlocProvider.of<NavigationBloc>(context).add(NavigationEvent.PeopleClickedEvent);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(Icons.people,
                          size: 30,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text("People",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Circular',
                              fontWeight: FontWeight.bold,
                              fontSize: 20

                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                GestureDetector(
                  onTap: (){
                    BlocProvider.of<NavigationBloc>(context).add(NavigationEvent.ProfileClickedEvent);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.userAlt,
                          size: 25,
                          color: Colors.white,
                        ),
                        SizedBox(width: 15),
                        Text("My Profile",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Circular',
                              fontWeight: FontWeight.bold,
                              fontSize: 20

                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]
            ),
          ),



          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                Icon(Icons.settings,color: Colors.white,),
                SizedBox(width: 10),
                Text('Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,

                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 2,
                  height: 20,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: (){
                    AuthMethods().signOut().then((value){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignIn() ));
                    });
                  },
                  child: Text('Log out',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
