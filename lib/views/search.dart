import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mingle/helper/constants.dart';
import 'package:mingle/helper/helperfunctions.dart';
import 'package:mingle/services/database.dart';

import 'package:mingle/views/conversations.dart';

String _myName;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchEditingController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  QuerySnapshot searchSnapshot;

  Widget searchList(){
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return searchTile(
            userName: searchSnapshot.docs[index].data()["user"],
            userEmail: searchSnapshot.docs[index].data()["email"],
          );
        }
    ): Container();
  }


  createChatroomAndStartConversation({String userName}){

    if(userName != _myName){
      String chatRoomId = getChatRoomId(_myName,userName);
      print(_myName);
      print(chatRoomId);
      List<String> users = [_myName,userName];

      Map<String,dynamic> chatRoomMap ={
        "users" : users,
        "chatroomId" : chatRoomId
      };

      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Conversation(
        chatRoomId : chatRoomId
      )));
    }
    else{
      print("Cannot send message");
    }
  }


  Widget searchTile({String userName, String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.black,
                ),
              ),
              Text(
                userEmail,
                style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatroomAndStartConversation(
                userName: userName
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
              child: Text(
                'Message',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  initiateSearch()async{
    await databaseMethods.getUserByUsername(searchEditingController.text).then((val){
      setState(() {
        searchSnapshot = val;
      });
    });
  }



  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo()async{
    _myName = await HelperFunctions.getuserNameSharedPreference();

    setState(() {

    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red,
        title: Text('Search',
          style: TextStyle(

            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),),
      ),
      body: Column(

        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    width:400,
                    height: 50,

                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchEditingController,
                            decoration: InputDecoration(
                              border : InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 15),
                              hintText: 'Search Users.',
                              hintStyle: TextStyle(

                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                            icon : Icon(Icons.search),
                            padding: EdgeInsets.all(5),
                            onPressed: (){
                              initiateSearch();

                            }
                        ),
                      ],
                    ),
                  ),
                  searchList(),
                ],
              ),
            ),
          ),


        ],
      ),

    );
  }
}

getChatRoomId(String a, String b) {
  if (a.compareTo(b)>0) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}

