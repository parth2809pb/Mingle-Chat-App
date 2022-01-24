import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mingle/helper/helperfunctions.dart';
import 'package:mingle/services/database.dart';
String _myName;
class Conversation extends StatefulWidget {
  String chatRoomId;
  String userName;
  Conversation({this.chatRoomId,this.userName});
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {


  DatabaseMethods databaseMethods = new DatabaseMethods();
  HelperFunctions helperFunctions = new HelperFunctions();
  TextEditingController messageController = new TextEditingController();
  Stream chatMessageStream;

  String myProfile, myUsername, myEmail,ToUsername;








  @override
  void initState() {
    doThisOnLaunch();
    super.initState();
  }


  doThisOnLaunch()async{
    await getUserInfo();
    getAndSetMessages();
  }



  getUserInfo()async{
    _myName = await HelperFunctions.getuserDisplaySharedPreference();
    myEmail = await HelperFunctions.getuserEmailSharedPreference();
    myProfile = await HelperFunctions.getuserProfileSharedPreference();
    myUsername = await HelperFunctions.getuserNameSharedPreference();
    ToUsername = widget.chatRoomId.replaceAll(myUsername, "").replaceAll("_", "");
    setState(() {

    });
  }


  sendMessage(){
    var lastMessagetime = DateTime.now().toString();
    if(messageController.text.isNotEmpty){
      Map<String,String> messageMap = {
        "message": messageController.text,
        "sendBy": myUsername,
        "ts": lastMessagetime,
        "image": myProfile
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      setState(() {
        messageController.text = "";
      });
    }
  }

  getAndSetMessages()async{
    chatMessageStream = await DatabaseMethods().getConversationMessages(widget.chatRoomId);
    setState(() {

    });
  }


  Widget ChatMessageTile(String message, bool sendByMe){
    return Row(
      mainAxisAlignment: sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(24),
              topLeft: Radius.circular(24),
              bottomRight: sendByMe ? Radius.circular(0) : Radius.circular(24),
              bottomLeft: sendByMe ? Radius.circular(24) : Radius.circular(0),
            ),
            color: sendByMe ? Colors.green: Colors.grey[800],
          ),
          padding: EdgeInsets.all(12),
          child: Text(
                message,
            // overflow: TextOverflow.clip,
            // maxLines: 5,
            // softWrap: false,
            style: TextStyle(
              fontSize: 16,
                color: sendByMe ? Colors.black : Colors.white,
            ),
            ),
        ),
      ],
    );
  }



  Widget ChatMessages (){
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context,snapshot){
        return snapshot.hasData ? ListView.builder(
          padding: EdgeInsets.only(bottom: 70, top: 16),
          reverse: true,
          itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index){
            DocumentSnapshot ds = snapshot.data.docs[index];
            return ChatMessageTile(ds["message"], myUsername == ds["sendBy"]);
            },
        ):Center(child: CircularProgressIndicator());
      },
    );
  }




  _buildMessageComposer(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.grey[800],
      child: Row(
        children: [
          SizedBox(width: 15),
          Expanded(child : TextField(
            cursorColor: Colors.white,
            controller: messageController,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (value){

            },
            style: TextStyle(
              color: Colors.white
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
                hintText: 'Send a message....',
              hintStyle: TextStyle(
                color: Colors.white
              ),

            ),
          )),
          IconButton(
              icon: Icon(Icons.send),
              iconSize: 25.0,
              color: Colors.white,
              onPressed: (){
                sendMessage();
              }
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        backgroundColor: Colors.green,

        elevation: 0,
        title: Center(
          child: Text(ToUsername,

            style: TextStyle(
              color: Colors.black,
              fontSize: 22.0,
              fontFamily: "Circular",
              fontWeight: FontWeight.bold,

            ),),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz),
            iconSize: 30.0,
            color: Colors.black,
            onPressed: (){

            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          child: Stack(
            children: [
              ChatMessages(),
              SizedBox(height: 5,),
              Container(
                alignment: Alignment.bottomCenter,
                child: _buildMessageComposer(),

              ),
            ],
          ),
        ),
      ),

    );
  }
}

