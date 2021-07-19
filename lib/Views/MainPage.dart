import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import '../ApiResponses/VideoListResponse.dart';
import '../Repository/MainRepository.dart';
import 'package:google_fonts/google_fonts.dart';
import 'VideoDetailNew.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'BooksDetail.dart';


String videoCategory="spiritual";

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


      getVideosList(user_Token,videoCategory).then((value) => {

      setState(() {
      mainData.addAll(value.data);

      })

      });


      return (prefs.getString('token'));
    });

  }

  Future<VideoListResponse> getVideosList(String user_Token,String videoCategory) async {

    var body ={'video_category':videoCategory};
    MainRepository repository=new MainRepository();
    return repository.fetchVideoData(body,user_Token);

  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    print("device_height"+height.toString());

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
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
      margin:EdgeInsets.fromLTRB(0.0,0.0,0.0,12.0) ,
      child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
        Stack(

      children: <Widget>[

        Container(
          margin: EdgeInsets.fromLTRB(0.0,5.0,0.0,0.0),

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


        Container(
            margin: EdgeInsets.fromLTRB(0.0,5.0,0.0,0.0),

            alignment: Alignment.center,
            height: ScreenUtil().setHeight(175),
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
              padding: EdgeInsets.fromLTRB(10,3,10,3),
              margin: EdgeInsets.fromLTRB(0,0,0,0.7),
              color: Color(0xFF5a5a5a),
              child: Text("English",  style: GoogleFonts.roboto(
            fontSize:16.0,

            color: Colors.white,
            fontWeight: FontWeight.w500,

          ),))


          )),
        Positioned.fill(
            child:Align(
                alignment: Alignment.bottomRight,
                child: Container(
                    padding: EdgeInsets.fromLTRB(10,3,10,5),
                    margin: EdgeInsets.fromLTRB(0,0,0,0.7),
                    color:  Color(0xFF5a5a5a),
                    child: Text("10:13",  style: GoogleFonts.roboto(
                      fontSize:14.0,

                      color: Colors.white,
                      fontWeight: FontWeight.w500,

                    ),))


            )),
      ],
    ),

      Container(
        margin:  EdgeInsets.fromLTRB(10,5,10,0),
      child:Row(

    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[

      new Image(
        image: new AssetImage("assets/avatar.png"),
        width: 42,
        height:  42,
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
        fontSize:15.0,

        color: Color(0xFF5a5a5a),
        fontWeight: FontWeight.w500,

      ),),
    Container(
        margin:  EdgeInsets.fromLTRB(0,5,10,0),
    child:Row(

    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Text("Banko ka mayajaal",   overflow: TextOverflow.ellipsis,
        maxLines: 1, style: GoogleFonts.roboto(
        fontSize:12.0,
        color: Color(0xFF5a5a5a),

      ),),
      SizedBox(width: 10),

      Container(
        width: 8,
        height: 8,

        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF5a5a5a)),
      ),
      SizedBox(width: 10),
      Text("23-03-2021",   overflow: TextOverflow.ellipsis,
        maxLines: 1, style: GoogleFonts.roboto(
          fontSize:12.0,
          color: Color(0xFF5a5a5a),

        ),),
      SizedBox(width: 10),
    ])),



    ]))),
       /*  new Expanded(
              flex: 1,

              child:Icon(Icons.more_vert)
          )
*/

    ]))

          ]));}
  Widget _buildList() {
    return ListView.builder(
      itemCount: mainData.length , // Add one more item for progress indicator

      itemBuilder: (BuildContext context, int index) {

        return GestureDetector(
          onTap: () => {

              Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                    MaterialPageRoute(
                        builder: (BuildContext context) {
                          return BooksDetailPage(content:mainData[index]);
                        }
                    ) )

          },
          child:
          _buildBoxVideo(context,mainData[index].id,mainData[index].title,mainData[index].videoImage)

          ,

        );

      },

    );
  }

}