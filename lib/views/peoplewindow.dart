import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mingle/helper/helperfunctions.dart';
import 'package:mingle/services/database.dart';
import 'package:mingle/services/navigation_bloc.dart';

import 'conversations.dart';

class PeopleWindow extends StatefulWidget with NavigationState {
  @override
  _PeopleWindowState createState() => _PeopleWindowState();
}

class _PeopleWindowState extends State<PeopleWindow> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;

  Stream chatRoomStream;

  String _myName = "";
  String _myImage = "";

  QuerySnapshot searchSnapshot;

  @override
  void initState() {
    onScreenLoaded();
    super.initState();
  }

  getUserInfo()async{
    _myName = await HelperFunctions.getuserNameSharedPreference();
    _myImage = await HelperFunctions.getuserProfileSharedPreference();


    setState(() {

    });
  }


  onScreenLoaded()async{
    await getUserInfo();
    await initiateSearch();
  }

  initiateSearch()async{
    await DatabaseMethods().getAllUsers().then((val){
      setState(() {
        searchSnapshot = val;
      });
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
                  width: 90,
                ),
                Column(
                  children: [
                    Text(
                      'People',
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
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft : isDrawerOpen ? Radius.circular(40) : Radius.circular(0),
                ),
              ),
              child: searchList(),
            ),
          ),
        ]),
      ),
    );
  }


  Widget searchTile({String userName, String userEmail, String userImage}){
    return GestureDetector(
      onTap: (){
        createChatroomAndStartConversation(
            userName: userName
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: userImage == null
                  ? null
                  : NetworkImage(userImage),
              radius: 25,
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    fontFamily: "Circular",
                    fontWeight: FontWeight.w600,
                    fontSize: 17.0,
                    color: Colors.black,
                  ),
                ),
                Text(
                  userEmail,
                  style: TextStyle(
                    fontFamily: "Circular",
                    fontWeight: FontWeight.w600,
                    fontSize: 17.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Spacer(),

          ],
        ),
      ),
    );
  }


  createChatroomAndStartConversation({String userName}){

    if(userName != _myName){
      print(_myName);
      String chatRoomId = getChatRoomId(_myName,userName);

      print(chatRoomId);
      List<String> users = [_myName,userName];

      Map<String,dynamic> chatRoomMap ={
        "users" : users,
        "chatroomId" : chatRoomId
      };

      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Conversation(
          chatRoomId : chatRoomId,
          userName: userName
      )));
    }
    else{
      print("Cannot send message");
    }
  }

  getChatRoomId(String a, String b) {
    if (a.compareTo(b)>0) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }


  Widget searchList(){
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return searchTile(
            userName: searchSnapshot.docs[index].data()["user"],
            userEmail: searchSnapshot.docs[index].data()["email"],
            userImage: searchSnapshot.docs[index].data()["profile"],
          );
        }
    ): Container();
  }


}
