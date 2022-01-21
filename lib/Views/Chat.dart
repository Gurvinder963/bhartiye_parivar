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
import 'package:url_launcher/url_launcher.dart';


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

        Container(color:Color(0xFFA5D6A7),
            width:MediaQuery.of(context).size.width ,
            padding: EdgeInsets.fromLTRB(10,15,10,15),
            child:
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: new AssetImage("assets/telegram.png"),
                    width: 28,
                    height:  28,
                    color: null,
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                  ),

            Text("   Telegram groups to chat with other people",

                    style: GoogleFonts.roboto(
                      fontSize:15.0,

                      color: Color(0xFF000000),
                      fontWeight: FontWeight.bold,

                    ))
        ])
        ),



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
                launch(
                    mainData[index].chatGroupLink,
                    forceSafariVC: false)

              },
              child:Container(
                color: Color(0xFFfffff),
                  child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(10,10,10,0),

                          child:
                          Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 24.0,
                                  backgroundImage:
                                  NetworkImage(mainData[index].chatGroupPic),
                                  backgroundColor: Colors.transparent,
                                ),
                                // Container(
                                //   margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                                //
                                //   alignment: Alignment.center,
                                //    height: 70,
                                //   width: 70,
                                //   decoration: BoxDecoration(
                                //     image: DecorationImage(
                                //       fit: BoxFit.fill,
                                //       image: NetworkImage(mainData[index].chatGroupPic),
                                //     ),
                                //   ),
                                //
                                // ),
                                 SizedBox(width: 15,),
                          new Expanded(
                              flex: 3, child:Container(

                              child:Column(

                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                               Text(mainData[index].chatGroupTitle,

                                        style: GoogleFonts.roboto(
                                          fontSize:14.0,

                                          color: Color(0xFF000000),
                                          fontWeight: FontWeight.bold,

                                        )),
                                SizedBox(height: 5,),
                                Text(mainData[index].chatGroupDis,

                                    style: GoogleFonts.roboto(
                                      fontSize:14.0,

                                      color: Color(0xFF000000),
                                      fontWeight: FontWeight.w500,

                                    ))

                              ]))),

                                new Expanded(
                                    flex: 2, child:Container(

                                    child:Column(

                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(mainData[index].appName,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.roboto(
                                                fontSize:13.0,

                                                color: Color(0xFF000000),
                                                fontWeight: FontWeight.bold,

                                              )),
                                          SizedBox(height: 5,),
                                          Text("("+mainData[index].chatGroupLanguage+")",

                                              style: GoogleFonts.roboto(
                                                fontSize:12.0,

                                                color: Color(0xFF000000),
                                                fontWeight: FontWeight.w500,

                                              ))

                                        ]))),

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