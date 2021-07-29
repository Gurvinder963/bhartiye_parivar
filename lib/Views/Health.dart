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
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../localization/locale_constant.dart';
String videoCategory="health";

class HealthPage extends StatefulWidget {
  @override
  HealthPageState createState() {
    return HealthPageState();
  }
}

class HealthPageState extends State<HealthPage> {
  List mainData = new List();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      var user_Token=prefs.getString(Prefs.KEY_TOKEN);

      if (!isLoading) {
        setState(() {
          isLoading = true;
        });}

      getLocaleContentLang().then((locale) {

       var array=locale.split(",");

        getVideosList(user_Token,videoCategory,array).then((value) => {

          setState(() {
            isLoading = false;
            mainData.addAll(value.data);

          })

        });


      });





      return (prefs.getString('token'));
    });

  }

  Future<VideoListResponse> getVideosList(String user_Token,String videoCategory, List<String> array) async {
  print(array.toString());
    var body ={'video_category':videoCategory,'lang_code':array.toString()};
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

  Widget _buildBoxVideo(BuildContext context,int id,String title,String thumbnail,String lang,String createdAt,String publisher,String duration,String videoUrl,String videoSourceType){

    String url="";
    if(videoSourceType=='facebook'){

    }
    else if(videoSourceType=='dailymotion'){
      String videoId=videoUrl.substring(videoUrl.lastIndexOf("/") + 1);
      url="https://www.dailymotion.com/thumbnail/video/"+videoId;
    }
    else {
      var videoIdd;
      try {
        videoIdd = YoutubePlayer.convertUrlToId(videoUrl);
        print('this is ' + videoIdd);
      } on Exception catch (exception) {
        // only executed if error is of type Exception
        print('exception');
      } catch (error) {
        // executed for errors of all types other than Exception
        print('catch error');
        //  videoIdd="error";

      }
     // mqdefault
      url = "https://img.youtube.com/vi/" + videoIdd + "/maxresdefault.jpg";
    }
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(DateTime.parse(createdAt));

    publisher=publisher==null?"My Channel":publisher;
    duration=duration==null?"4:50":duration;
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
                        image: NetworkImage(url),
                      ),
                    ),

                  ),

                /*  Positioned.fill(
                      child:Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                              padding: EdgeInsets.fromLTRB(10,3,10,3),
                              margin: EdgeInsets.fromLTRB(0,0,0,0.7),
                              color: Color(0xFF5a5a5a),
                              child: Text(lang,  style: GoogleFonts.roboto(
                                fontSize:16.0,

                                color: Colors.white,
                                fontWeight: FontWeight.w500,

                              ),))


                      )),*/
                  Positioned.fill(
                      child:Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                              padding: EdgeInsets.fromLTRB(10,3,10,5),
                              margin: EdgeInsets.fromLTRB(0,0,0,0.7),
                              color:  Color(0xFF5a5a5a),
                              child: Text(duration,  style: GoogleFonts.roboto(
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

                                          color: Color(0xFF000000),
                                          fontWeight: FontWeight.w500,

                                        ),),
                                      Container(
                                          margin:  EdgeInsets.fromLTRB(0,5,10,0),
                                          child:Row(

                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(publisher,   overflow: TextOverflow.ellipsis,
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
                                                Text(formatted,   overflow: TextOverflow.ellipsis,
                                                  maxLines: 1, style: GoogleFonts.roboto(
                                                    fontSize:12.0,
                                                    color: Color(0xFF5a5a5a),

                                                  ),),
                                                SizedBox(width: 10),
                                              ])),



                                    ]))),
                          new Expanded(
              flex: 1,

              child:Icon(Icons.more_vert)
          )


                      ]))

            ]));}
  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
  Widget _buildList() {
    return ListView.builder(
        itemCount: mainData.length+ 1 , // Add one more item for progress indicator

        itemBuilder: (BuildContext context, int index) {
      if (index == mainData.length) {
        return _buildProgressIndicator();
      } else {
        return GestureDetector(
          onTap: () =>
          {

            Navigator.of(context, rootNavigator: true)
                .push( // ensures fullscreen
                MaterialPageRoute(
                    builder: (BuildContext context) {
                      return VideoDetailNewPage(content: mainData[index]);
                    }
                ))
          },
          child:
          _buildBoxVideo(
              context,
              mainData[index].id,
              mainData[index].title,
              mainData[index].videoImage,
              mainData[index].lang,
              mainData[index].createdAt,
              mainData[index].publisher,
              mainData[index].video_duration,
              mainData[index].videoUrl,
              mainData[index].videoSourceType

          )


        );
      }
      },

    );
  }

}