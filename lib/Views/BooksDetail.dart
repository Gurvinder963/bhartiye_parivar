import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import '../ApiResponses/VideoListResponse.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class BooksDetailPage extends StatefulWidget {
  final Data content;


  BooksDetailPage({Key key,@required this.content}) : super(key: key);
  @override
  BooksDetailPageState createState() {
    return BooksDetailPageState(content);
  }
}

class BooksDetailPageState extends State<BooksDetailPage> {
  YoutubePlayerController _controller;
  final List<String> _ids = [];
  TextEditingController _idController;
  TextEditingController _seekToController;
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  Data mContent;
  BooksDetailPageState(Data content){
    mContent=content;
  }

  @override
  void initState() {
    super.initState();

  }




  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(AppColors.BaseColor),
        title: Text(AppStrings.Details),
      ),

      body: Container(

          child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,

              children: <Widget>[

                Container(
                  margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),

                  alignment: Alignment.center,
                  height: ScreenUtil().setHeight(175),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: new AssetImage("assets/thumbnail.png"),

                      alignment: Alignment.center,
                    ),

                  ),

                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(15,20,0,0),
                    child:
                    Text(
                      'Bhartiya Bhashaye',
                      style: GoogleFonts.roboto(fontSize: 17, color: Colors.black,fontWeight: FontWeight.w500),
                    ),),



      Container(
          margin:  EdgeInsets.fromLTRB(20,10,20,0),
          child:Row(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Online Book',
                  style: GoogleFonts.roboto(fontSize: 14, color: Colors.black,fontWeight: FontWeight.w500),
                ),
                Spacer(),
                Text(
                  'Printed Book Price',
                  style: GoogleFonts.roboto(fontSize: 14, color: Colors.black,fontWeight: FontWeight.w500),
                ),
              ]))

                ,
                Container(
                    margin:  EdgeInsets.fromLTRB(20,0,20,0),
                    child:Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '',
                            style: GoogleFonts.roboto(fontSize: 14, color: Colors.black,fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          Text(
                            '100/-',
                            style: GoogleFonts.roboto(fontSize: 14, color: Colors.black,fontWeight: FontWeight.w500),
                          ),
                        ]))

                ,
                Container(
                    margin:  EdgeInsets.fromLTRB(20,20,10,0),
                    child:Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _DonateButton(),

                        Spacer(),
                          _joinButton(),


                        ]))
                ,
                Container(

                  padding:  EdgeInsets.fromLTRB(0,5,0,5),
                    margin:  EdgeInsets.fromLTRB(0,20,0,0),
                    color: Color(0xFF20d256),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                        Spacer(),
                          Container(

                              child:Column(

                                  children: <Widget>[
                                    Text("Description"),
                                    Divider(
                                      color: Colors.red,
                                    ),

                                  ])),Spacer()
                         , Container(
                              child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Photos"),
                                    Divider()

                                  ])),Spacer()
                          ,Container(
                              child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Offers"),
                                    Divider()

                                  ])),
                          Spacer()
                        ]))
                ,

                Padding(
                  padding: EdgeInsets.fromLTRB(15,20,0,0),
                  child:
                  Text(
                    'Bhartiya Bhashaye',
                    style: GoogleFonts.roboto(fontSize: 17, color: Colors.black,fontWeight: FontWeight.w500),
                  ),),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Text("ADD TO CART"),
                    ),
                  ),
                ),

              ])

      ),

    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        /*  Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder:
                (context) =>
                VerifyOTPPage()
            ), ModalRoute.withName("/VerifyOTP")
        );
*/

      },

      child: Container(
        width: 150,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(1, 1),
                  blurRadius: 0,
                  spreadRadius: 0)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(AppColors.BaseColor), Color(AppColors.BaseColor)])),
        child: Text(
          'Submit',
          style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
  Widget _joinButton() {
    return InkWell(
      onTap: () {

      },

      child: Container(
        width: 140,
        height: 45,
        margin: EdgeInsets.fromLTRB(0,0,0,10),
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(

            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(1, 1),
                  blurRadius: 0,
                  spreadRadius: 0)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.red, Colors.red])),
        child: Text(
          'BUY NOW',
          style: GoogleFonts.roboto(fontSize: 17, color: Colors.white,fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _DonateButton() {
    return InkWell(
      onTap: () {

      },

      child: Container(
        width: 140,
        height: 45,
        margin: EdgeInsets.fromLTRB(0,0,0,10),
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(

            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(1, 1),
                  blurRadius: 0,
                  spreadRadius: 0)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF20d256), Color(0xFF20d256)])),
        child: Text(
          'READ NOW',
          style: GoogleFonts.roboto(fontSize: 17, color: Colors.white,fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

}