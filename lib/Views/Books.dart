import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'MyBooksTab.dart';
import 'BooksByLanguage.dart';



class BooksPage extends StatefulWidget {
  @override
  BooksPageState createState() {
    return BooksPageState();
  }
}

class BooksPageState extends State<BooksPage> {


  @override
  Widget build(BuildContext context) {
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
              child:Text("MY BOOKS",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Color(0xFFffffff)),),
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
                          child:Text("BY LANGUAGE",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Color(0xFFffffff)),),
                        ),

                      ])),
                ),


              ]

          ),
    Padding(
    padding: EdgeInsets.fromLTRB(10,10,10,10),
          child:
          Text("All Books",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Color(0xFF000000)),)
    )

        ])


        ),

    );
  }


}