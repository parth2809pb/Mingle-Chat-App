import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mingle/helper/helperfunctions.dart';




class DatabaseMethods{
 Future<QuerySnapshot> getUserByUsername(String username)async{
    return await FirebaseFirestore.instance.collection("users").where("user", isGreaterThanOrEqualTo: username).get();
  }

 Future<QuerySnapshot> getAllUsers()async{
   return await FirebaseFirestore.instance.collection("users").get();
 }

  getUserByUserEmail(String userEmail)async{
    return await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: userEmail).get();
  }

  Future updateUserInfo(String userId, userMap) async{
   String username = await HelperFunctions.getuserNameSharedPreference();
    FirebaseFirestore.instance.collection("users").doc(userId).update(userMap);
  }

  createChatRoom(String chatRoomId, chatRoomMap){
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).set(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap){
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).collection("chats").add(messageMap).catchError((e){
      print(e.toString());
    });
  }

  Future<Stream<QuerySnapshot>> getConversationMessages(String chatRoomId)async{

    return FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).collection("chats").orderBy("ts",descending: true).snapshots();

  }

  Future addUserInfotoDB(String userId, Map<String,dynamic> userInfoMap )async{
    return await FirebaseFirestore.instance.collection("users").doc(userId).set(userInfoMap);
  }
  
  Future<Stream<QuerySnapshot>> getChatRooms()async{
   String myname = await HelperFunctions.getuserNameSharedPreference();
   return FirebaseFirestore.instance.collection("ChatRoom").where("users",arrayContains: myname).snapshots();
  }
  
// Future LastMessage(String ChatRoomId, String messageId, Map messageInfoMap)async{
//    return FirebaseFirestore.instance.collection("ChatRoom").doc(ChatRoomId).collection("chats").doc(messageId).set(messageInfoMap);
// }

Future UploadUserImage(String destination, File imagefile)async{
   final ref = await FirebaseStorage.instance.ref(destination);
   return ref.putFile(imagefile);
}



}