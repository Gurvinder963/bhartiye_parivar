import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import '../ApiResponses/VideoListResponse.dart';
import '../Repository/MainRepository.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  List mainData = new List();
  @override
  void initState() {
    super.initState();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      var user_Token=prefs.getString(Prefs.KEY_TOKEN);


      getVideosList(user_Token).then((value) => {

      setState(() {
      mainData.addAll(value.data);

      })

      });


      return (prefs.getString('token'));
    });

  }

  Future<VideoListResponse> getVideosList(String user_Token) async {

    var body ={'name':'spiritual'};
    MainRepository repository=new MainRepository();
    return repository.fetchVideoData(body,user_Token);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:   Container(
        height: (MediaQuery.of(context).size.height),


    child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: _buildList(),

            )

          ]) ,)

    );
  }

  Widget _buildBoxVideo(BuildContext context,int id,String title,String thumbnail){
    return    Container(
      child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
        Stack(

      children: <Widget>[
        Container(
            margin: EdgeInsets.fromLTRB(0.0,5.0,0.0,0.0),

            alignment: Alignment.center,
            height: 170,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(thumbnail),
              ),
            ),

        ),

    Positioned.fill(
    child:Align(
          alignment: Alignment.bottomLeft,
          child: Container(
              padding: EdgeInsets.fromLTRB(5,3,5,3),
              margin: EdgeInsets.fromLTRB(0,0,0,0.7),
              color: Colors.white,
              child: Text("English",  style: GoogleFonts.roboto(
            fontSize:14.0,
            letterSpacing: 1.5,
            color: Colors.black,
            fontWeight: FontWeight.bold,

          ),))


          )),
        Positioned.fill(
            child:Align(
                alignment: Alignment.bottomRight,
                child: Container(
                    padding: EdgeInsets.fromLTRB(5,3,5,3),
                    margin: EdgeInsets.fromLTRB(0,0,0,0.7),
                    color: Colors.white,
                    child: Text("10:13",  style: GoogleFonts.roboto(
                      fontSize:14.0,
                      letterSpacing: 1.5,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,

                    ),))


            )),
      ],
    ),

      Container(
      child:Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      SizedBox(height: 5,width: 5,),
      new Image(
        image: new AssetImage("assets/avatar.png"),
        width: 40,
        height:  40,
        color: null,
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
      ),
      SizedBox(height: 5,width: 8,),

          new Expanded(
              flex: 7,
    child:Container(

    child:Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      SizedBox(height: 5),
      Text(title,
        textAlign: TextAlign.justify,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: GoogleFonts.roboto(
        fontSize:14.0,
        letterSpacing: 1.5,
        color: Colors.black,
        fontWeight: FontWeight.bold,

      ),),
      Text("Banko ka mayajaal",  style: GoogleFonts.roboto(
        fontSize:11.0,
        letterSpacing: 1.5,
        color: Colors.black,
        fontWeight: FontWeight.bold,

      ),)

    ]))),
          new Expanded(
              flex: 1,

              child:Icon(Icons.more_vert)
          )


    ]))

          ]));}
  Widget _buildList() {
    return ListView.builder(
      itemCount: mainData.length , // Add one more item for progress indicator

      itemBuilder: (BuildContext context, int index) {

        return GestureDetector(
          onTap: () => {




          },
          child:
          _buildBoxVideo(context,mainData[index].id,mainData[index].title,mainData[index].videoImage)

          ,

        );

      },

    );
  }

}