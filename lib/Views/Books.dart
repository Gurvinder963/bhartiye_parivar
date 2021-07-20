import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'MyBooksTab.dart';
import 'BooksByLanguage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BooksPage extends StatefulWidget {
  @override
  BooksPageState createState() {
    return BooksPageState();
  }
}

class BooksPageState extends State<BooksPage> {
  String userName="";



  @override
  void initState() {
    super.initState();

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      userName=prefs.getString(Prefs.USER_NAME);




      return (prefs.getString('token'));
    });
  }


  @override
  Widget build(BuildContext context) {
    List<String> images = [
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
          "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
      "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png"
    ];
    return Scaffold(

        body: Container(
          padding:  EdgeInsets.symmetric(vertical: 10,horizontal: 5),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [




          Row(

             // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                Expanded(
                  child:   GestureDetector(
                  onTap: () {

                    Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                        MaterialPageRoute(
                            builder: (BuildContext context) {
                              return MyBooksTabPage();
                            }
                        ) );

                  },

    child:Stack(
                      alignment: Alignment.center,
        children: <Widget>[

                  new Image(
                    image: new AssetImage("assets/collage.png"),
                    width: 150,
                    height:  150,
                    color: null,
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                  ),

          Container(

            padding:  EdgeInsets.symmetric(vertical: 7,horizontal: 8),
              decoration: BoxDecoration(
                color:Colors.black ,

                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child:Text("MY BOOKS"
                ,style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(17), color: Colors.white),),
          ),

        ])),
                ),
            
                Expanded(
                  child:  GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                      MaterialPageRoute(
                          builder: (BuildContext context) {
                            return BooksByLanguagePage();
                          }
                      ) );
                },

                child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[

                        new Image(
                          image: new AssetImage("assets/languages.png"),
                          width: 150,
                          height:  150,

                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                        ),

                        Container(
                          padding:  EdgeInsets.symmetric(vertical: 7,horizontal: 8),
                          decoration: BoxDecoration(
                              color:Colors.black ,

                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          child:Text("BY LANGUAGE",style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(17), color: Colors.white),),
                        ),

                      ])),
                ),


              ]

          ),
    Padding(
    padding: EdgeInsets.fromLTRB(15,10,10,10),
          child:
          Text("All Books",style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(17), color: Colors.black,fontWeight: FontWeight.bold),)
    )
,Expanded(

              child: GridView.builder(
                itemCount: images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0
                ),
                itemBuilder: (BuildContext context, int index){
                  return Image.network(images[index]);
                },
              ))
        ])


        ),

    );
  }


}