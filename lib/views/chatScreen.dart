import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mingle/helper/helperfunctions.dart';
import 'package:mingle/services/auth.dart';
import 'package:mingle/services/database.dart';
import 'package:mingle/services/navigation_bloc.dart';
import 'package:mingle/views/profileWindow.dart';


import 'conversations.dart';

class ChatWindow extends StatefulWidget with NavigationState{
  @override
  _ChatWindowState createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {

  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;
  bool isSearching =false;

  TextEditingController searchTextEditingController = new TextEditingController();

  DatabaseMethods databaseMethods = new DatabaseMethods();

  QuerySnapshot searchSnapshot;

  //Stream usersStream;
  Stream chatRoomStream;

  AuthMethods authMethods = new AuthMethods();

  String _myName = "";
  String _myImage = "";


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


  onSearchBtnClk()async{
    setState(() {
      isSearching=true;

    });
    //usersStream = await DatabaseMethods().getUserByUsername(searchTextEditingController.text);
    initiateSearch();
    setState(() {

    });
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

  getChatRooms()async {
    chatRoomStream = await DatabaseMethods().getChatRooms();
    setState(() {

    });
  }

  onScreenLoaded()async{
    await getUserInfo();
    getChatRooms();
  }


  initiateSearch()async{
    await databaseMethods.getUserByUsername(searchTextEditingController.text).then((val){
      setState(() {
        searchSnapshot = val;
      });
    });
  }




  Widget ChatRoomsList(){
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context,snapshot){
        return snapshot.hasData ? ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index){
            DocumentSnapshot ds = snapshot.data.docs[index];
              return ChatTile(ds.id,_myName);
            }) : Center(child: CircularProgressIndicator(backgroundColor: Colors.black,));
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
        isDrawerOpen ? setState(() {
          xOffset = 0;
          yOffset = 0;
          scaleFactor = 1;
          isDrawerOpen = false;
        }) : null ;
      },
      child: AnimatedContainer(

        transform: Matrix4.translationValues(xOffset, yOffset,0)..scale(scaleFactor),
        duration: Duration(milliseconds: 250),
        decoration: BoxDecoration(
            color: Colors.green,
          borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0)
        ),



        child: Column(
          children: [
            SizedBox(height: 50),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isDrawerOpen ? IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.black,
                      onPressed: (){
                        setState(() {
                          xOffset = 0;
                          yOffset = 0;
                          scaleFactor = 1;
                          isDrawerOpen = false;
                        });
                      }
                  ):IconButton(
                    icon: Icon(Icons.menu),
                    iconSize: 30.0,
                    color: Colors.black,
                    onPressed: (){

                      setState(() {
                        xOffset = 230;
                        yOffset = 150;
                        scaleFactor=0.6;
                        isDrawerOpen =true;
                      });
                    },
                  ),
                  Column(
                    children: [
                      Text(
                        'Mingle',
                        style: TextStyle(
                          fontFamily: 'Circular',
                          fontSize: 25,
                          fontWeight: FontWeight.w600,

                        ),
                      ),
                      // Text('Chat',
                      //   style: TextStyle(
                      //     fontSize: 16
                      //   ),
                      // ),
                    ],
                  ),
                  GestureDetector(
                    onTap: (){
                      //Navigator.pushReplacement(
                         // context, MaterialPageRoute(builder: (context) => ProfileWindow()));
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(_myImage),

                    ),
                  ),
                ],
              ),
            ),



            Row(
              children: [

                isSearching ? GestureDetector(
                  onTap: (){
                    setState(() {
                      isSearching = false;
                      searchTextEditingController.text = "";
                      FocusScope.of(context).unfocus();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left:15.0),
                    child: Icon(Icons.arrow_back,size: 35,color: Colors.black,),
                  ),
                ):Container(),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 30),

                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            // width:350,
                            // height: 50,

                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: searchTextEditingController,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(

                                      border : InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                      hintText: 'Search Users.',
                                      hintStyle: TextStyle(

                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                    icon : Icon(Icons.search,color: Colors.white,),
                                    padding: EdgeInsets.all(5),
                                    onPressed: (){
                                      //initiateSearch();
                                      if(searchTextEditingController.text != ""){
                                        onSearchBtnClk();
                                      }

                                    }
                                ),
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),

            isSearching ? Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft : isDrawerOpen ? Radius.circular(40) : Radius.circular(0),
                    ),
                  ),
                  child: searchList()),
            ) : Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft : isDrawerOpen ? Radius.circular(40) : Radius.circular(0),
                  ),
                ),
                child: ChatRoomsList(),
              ),
            ),
          ],
        ),
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

class ChatTile extends StatefulWidget {

  final String chatRoomId,myUsername;
  ChatTile(this.chatRoomId,this.myUsername);
  @override
  _ChatTileState createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  String ToProfileUrl, ToName,ToUsername;

  getThisUserInfo()async{
    ToUsername = widget.chatRoomId.replaceAll(widget.myUsername, "").replaceAll("_", "");
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserByUsername(ToUsername);
    ToName = querySnapshot.docs[0]["displayname"];
    ToProfileUrl = querySnapshot.docs[0]["profile"];
    setState(() {});
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ToProfileUrl != null ? GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Conversation(
            chatRoomId : widget.chatRoomId,
            userName: widget.myUsername
        )));
      },
      child: Container(

        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(ToProfileUrl),radius: 25,),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ToName,style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Circular",
                  fontWeight: FontWeight.w600
                ),),
                Text(ToUsername,style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Circular",
                    fontWeight: FontWeight.w600
                ),),
              ],
            ),
          ],
        ),
      ),
    ) : Container();
  }
}
