import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mingle/services/auth.dart';
import 'package:mingle/services/navigation_bloc.dart';
import 'package:mingle/views/chatScreen.dart';
import 'package:mingle/views/drawerScreen.dart';
import 'package:mingle/views/search.dart';

import 'package:mingle/widgets/catagory_selector.dart';



class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}
String _myName;
class _ChatRoomState extends State<ChatRoom> {

  AuthMethods authMethods = new AuthMethods();



  @override
  void initState() {

    super.initState();
  }

  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<NavigationBloc>(
        create: (context)=> NavigationBloc(ChatWindow()),


      child:Stack(
        children: [
          DrawerWindow(),
          BlocBuilder<NavigationBloc,NavigationState>(
              builder: (context, navigationState){
                return navigationState as Widget;
              }
          )

        ],
      ),),
    );
  }
}

