import 'dart:convert';
import 'package:bhartiye_parivar/ApiResponses/SocialMediaResponse.dart';
import 'package:bhartiye_parivar/Utils/constants.dart';
import 'package:bhartiye_parivar/Views/Facebook.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../ApiResponses/AppChannelResponse.dart';
import '../Repository/MainRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';

import 'package:google_fonts/google_fonts.dart';
class SocialMediaPage extends StatefulWidget {
  @override
  SocialMediaPageState createState() {
    return SocialMediaPageState();
  }
}

class SocialMediaPageState extends State<SocialMediaPage> {
  // WebViewController _controller;
  String fileUrl="";
  // InAppWebViewController webView;
  String url = "";
  double progress = 0;
  String user_Token;

  String USER_ID;

  // String facebook_url="";
  // String twitter_url="";
  // String youtube_url="";
  // String telegram_url="";
  // String koo_url="";
  // String instagram_url="";


  SocialMediaResponse socialMediaObject;

  Future<SocialMediaResponse> getSocialMediaAPI() async {



    var body =json.encode({"appcode":Constants.AppCode, "token": user_Token,"userid": USER_ID,"page":"1"});
    MainRepository repository=new MainRepository();
    return repository.fetchSocialMediaJAVA(body);


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      user_Token=prefs.getString(Prefs.KEY_TOKEN);
      USER_ID=prefs.getString(Prefs.USER_ID);

      getSocialMediaAPI().then((
          value) async {

        setState(() {
          // isLoading = false;
          socialMediaObject=value;

        });



      });




      return (prefs.getString('token'));
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          SizedBox(height: 20,),
    Row(

    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[

      Container(
    width:MediaQuery.of(context).size.width/2-2,
        child:  GestureDetector( onTap: () {
        Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
            MaterialPageRoute(
                builder: (BuildContext context) {
                  return FacebookPage(link:socialMediaObject.facebook,name:"Facebook");
                }
            ) );

      }, child: Container(width:MediaQuery.of(context).size.width/2, child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[

            Image(
              image: new AssetImage("assets/facebook.png"),
              width: 37,
              height:  37,
              color: null,
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
            ),
            SizedBox(width: 15,),
            Text("Facebook",

                style: GoogleFonts.roboto(
                  fontSize:15.0,

                  color: Color(0xFF000000),
                  fontWeight: FontWeight.bold,

                ))
          ]))),),



      Container(
        width:MediaQuery.of(context).size.width/2-2 ,
        child:  GestureDetector( onTap: () {
        Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
            MaterialPageRoute(
                builder: (BuildContext context) {
                  return FacebookPage(link:socialMediaObject.twitter,name:"Twitter");
                }
            ) );

      }, child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 10,),
            Image(
              image: new AssetImage("assets/twitter.png"),
              width: 40,
              height:  40,
              color: null,
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
            ),
            SizedBox(width: 15,),
            Text("Twitter",

                style: GoogleFonts.roboto(
                  fontSize:15.0,

                  color: Color(0xFF000000),
                  fontWeight: FontWeight.bold,

                ))
          ])),),
    ]),
          SizedBox(height: 5,),
          Divider(
            color: Colors.grey,
          ),
          SizedBox(height: 5,),
          Row(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

          Container(
          width:MediaQuery.of(context).size.width/2-2,
          child: GestureDetector( onTap: () {
            Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                MaterialPageRoute(
                    builder: (BuildContext context) {
                      return FacebookPage(link:socialMediaObject.youtube,name:"Youtube");
                    }
                ) );

          }, child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 10,),
                Image(
                  image: new AssetImage("assets/ic_youtube.png"),
                  width: 40,
                  height:  40,
                  color: null,
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                ),
                SizedBox(width: 15,),
                Text("Youtube",

                    style: GoogleFonts.roboto(
                      fontSize:15.0,

                      color: Color(0xFF000000),
                      fontWeight: FontWeight.bold,

                    ))
              ])),
          ),
                Container(
                  width:MediaQuery.of(context).size.width/2-2 ,
                  child:GestureDetector( onTap: () {
                  Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                      MaterialPageRoute(
                          builder: (BuildContext context) {
                            return FacebookPage(link:socialMediaObject.telegram,name:"Telegram");
                          }
                      ) );

                }, child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 10,),
                      Image(
                        image: new AssetImage("assets/telegram.png"),
                        width: 37,
                        height:  37,
                        color: null,
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                      ),
                      SizedBox(width: 15,),
                      Text("Telegram",

                          style: GoogleFonts.roboto(
                            fontSize:15.0,

                            color: Color(0xFF000000),
                            fontWeight: FontWeight.bold,

                          ))
                    ])),)



              ])




          ,
          SizedBox(height: 5,),
          Divider(
            color: Colors.grey,
          ),
          SizedBox(height: 5,),

          Row(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

          Container(
          width:MediaQuery.of(context).size.width/2-2,
          child:  GestureDetector( onTap: () {
            Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                MaterialPageRoute(
                    builder: (BuildContext context) {
                      return FacebookPage(link:socialMediaObject.koo,name:"Koo");
                    }
                ) );

          }, child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Image(
                  image: new AssetImage("assets/ic_koo.png"),
                  width: 40,
                  height:  40,
                  color: null,
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                ),
                SizedBox(width: 15,),
                Text("Koo",

                    style: GoogleFonts.roboto(
                      fontSize:15.0,

                      color: Color(0xFF000000),
                      fontWeight: FontWeight.bold,

                    ))
              ])),

          ),
                Container(
                  width:MediaQuery.of(context).size.width/2-2,
                  child:
                GestureDetector( onTap: () {
                  Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                      MaterialPageRoute(
                          builder: (BuildContext context) {
                            return FacebookPage(link:socialMediaObject.instagram);
                          }
                      ) );

                }, child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 10,),
                      Image(
                        image: new AssetImage("assets/ic_instagram.png"),
                        width: 40,
                        height:  40,
                        color: null,
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                      ),
                      SizedBox(width: 15,),
                      Text("Instagram",

                          style: GoogleFonts.roboto(
                            fontSize:15.0,

                            color: Color(0xFF000000),
                            fontWeight: FontWeight.bold,

                          ))
                    ])),
                )



              ])







        ]
      )

    );
  }


}