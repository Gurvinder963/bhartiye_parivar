import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Utils/AppColors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import '../Repository/MainRepository.dart';
import '../Utils/AppColors.dart';
import 'package:bhartiye_parivar/Utils/constants.dart';
import '../ApiResponses/ChatGroupResponse.dart';
import 'package:google_fonts/google_fonts.dart';



class ChatPage extends StatefulWidget {
  @override
  ChatPageState createState() {
    return ChatPageState();
  }
}

class ChatPageState extends State<ChatPage> {
  String user_Token;
  //bool isBookMarked = false;
  // bool isSubscribed= false;
  bool _isInAsyncCall = false;
  bool _isPlayerReady = false;
  String USER_ID;
  List mainData=new List();
  @override
  void initState() {
    super.initState();


    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      user_Token=prefs.getString(Prefs.KEY_TOKEN);
      USER_ID=prefs.getString(Prefs.USER_ID);

      getChatList(user_Token).then((
          value) async {

        setState(() {
          // isLoading = false;
           mainData.addAll(value.chat);



        });



      });




      return (prefs.getString('token'));
    });



  }
  Future<ChatGroupResponse> getChatList(String user_Token) async {


    // String pageIndex = page.toString();
    var body =json.encode({"appcode":Constants.AppCode, "token": user_Token,"userid": USER_ID,"page":"1"});
    MainRepository repository=new MainRepository();
    return repository.fetchChatListJAVA(body);




  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
          child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

        Container(color:Color(0xFF00ff00),
            width:MediaQuery.of(context).size.width ,
            padding: EdgeInsets.fromLTRB(10,15,10,15),
            child: Text("Telegram group to chat with other people",

                    style: GoogleFonts.roboto(
                      fontSize:14.0,

                      color: Color(0xFFffffff),
                      fontWeight: FontWeight.w500,

                    ))),



       Expanded(child:
          _buildList())
              ])

      ),

    );
  }
  Widget _buildList() {


    return

      ListView.builder(
        itemCount: mainData.length , // Add one more item for progress indicator

        itemBuilder: (BuildContext context, int index) {

          return GestureDetector(
              onTap: () =>
              {


              },
              child:Container(
                  child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(10,10,10,10),

                          child:
                          Row(
                              children: <Widget>[
                                Expanded(

                                    child:Text(mainData[index].chatGroupTitle,

                                        style: GoogleFonts.roboto(
                                          fontSize:14.0,

                                          color: Color(0xFF000000),
                                          fontWeight: FontWeight.w500,

                                        ))),


                              ]

                          ),),

                        Container(
                          padding: EdgeInsets.fromLTRB(10,10,10,10),

                          child:
                          Row(
                              children: <Widget>[
                                Expanded(

                                    child:Text(mainData[index].chatGroupDis,

                                        style: GoogleFonts.roboto(
                                          fontSize:14.0,

                                          color: Color(0xFF000000),
                                          fontWeight: FontWeight.w500,

                                        ))),


                              ]

                          ),),



                        Divider(
                          color: Colors.grey,
                        ),
                      ])


              )



          );

        },



      );
  }



}