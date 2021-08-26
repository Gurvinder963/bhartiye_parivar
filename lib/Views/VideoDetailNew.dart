import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import '../ApiResponses/VideoListResponse.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../Repository/MainRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../ApiResponses/VideoData.dart';

import '../ApiResponses/VideoDetailResponse.dart';
String videoCategory;
class VideoDetailNewPage extends StatefulWidget {
  final VideoData content;


  VideoDetailNewPage({Key key,@required this.content}) : super(key: key);
  @override
  VideoDetailNewPageState createState() {

    videoCategory=content.videoCategory;
    return VideoDetailNewPageState(content);
  }
}

class VideoDetailNewPageState extends State<VideoDetailNewPage> {
  var marginPixel=0;
  List mainData = new List();
  bool isLoading = false;
  YoutubePlayerController _controller;
  final List<String> _ids = [];
  TextEditingController _idController;
  TextEditingController _seekToController;
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  VideoData mContent;
  VideoDetailNewPageState(VideoData content){
    mContent=content;
  }
  @override
  dispose(){
    SystemChrome.setPreferredOrientations([

      DeviceOrientation.portraitUp,

    ]);
    super.dispose();
  }
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      var user_Token=prefs.getString(Prefs.KEY_TOKEN);

      if (!isLoading) {
        setState(() {
          isLoading = true;
        });}

      getVideoDetail(user_Token,mContent.id.toString()).then((value) => {

        setState(() {
          mContent=value.data;
          //   isLoading = false;
          // mainData.addAll(value.data);

        })

      });


      getVideosList(user_Token,videoCategory,mContent.id.toString()).then((value) => {

        setState(() {
          isLoading = false;
          mainData.addAll(value.data);

        })

      });


      return (prefs.getString('token'));
    });

  }
  Future<VideoDetailResponse> getVideoDetail(String user_Token,String id) async {

    var body ={'lang_code':''};
    MainRepository repository=new MainRepository();
    return repository.fetchVideoDetailData(id,body,user_Token);

  }
  Future<VideoListResponse> getVideosList(String user_Token,String videoCategory,String videoId) async {

    var body ={'video_category':videoCategory,"video_id":videoId};
    MainRepository repository=new MainRepository();
    return repository.fetchVideoData(body,user_Token);

  }

  @override
  Widget build(BuildContext context) {
    var publisher=mContent.publisher==null?"My Channel":mContent.publisher;
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    if(!isPortrait){
      marginPixel=40;
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    }
    else{
      marginPixel=0;
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    }
    var channel=mContent.channel==null?"My Channel":mContent.channel;

    final height = MediaQuery.of(context).size.height;
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(DateTime.parse(mContent.createdAt));
    return  Scaffold(
          appBar: isPortrait?AppBar(
              toolbarHeight: 50,
            backgroundColor: Color(AppColors.BaseColor),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop(context),
            ),
            title: Text(AppStrings.PlayingVideo),
          ):null,

          body: Container(

              child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,


                  children: <Widget>[
                    _buildBoxVideo(context,mContent),
              Expanded(
                  child:
              ListView( // parent ListView
                  children: <Widget>[
                    Container(
                        margin:  EdgeInsets.fromLTRB(10,0,10,0),
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
                                            Text(mContent.title,

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
                                                      Text(channel,   overflow: TextOverflow.ellipsis,
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
                              /*  new Expanded(
              flex: 1,

              child:Icon(Icons.more_vert)
          )
*/

                            ])),

                    Container(
                        margin:  EdgeInsets.fromLTRB(20,15,10,0),
                        child:Row(

                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(width: 5,),
                              Image(
                                image: new AssetImage("assets/like_unsel.png"),
                                width: 24,
                                height:  24,
                                color: null,
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.center,
                              ),
                              SizedBox(width: 17,),
                              Image(
                                image: new AssetImage("assets/dislike_unsel.png"),
                                width: 24,
                                height:  24,
                                color: null,
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.center,
                              ),
                              SizedBox(width: 17,),
                              Icon(Icons.report_outlined,size: 28,color:Colors.black,),
                              SizedBox(width: 17,),
                              Image(
                                image: new AssetImage("assets/share.png"),
                                width: 23,
                                height:  23,
                                color:Colors.black,
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.center,
                              ),
                              SizedBox(width: 17,),
                              Image(
                                image: new AssetImage("assets/bookmark_unsel.png"),
                                width: 24,
                                height:  24,
                                color: null,
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.center,
                              ),
                            //  Icon(Icons.bookmark_outline_outlined,size: 28,color: Color(0xFF666666),),
                              Expanded( child:Align(
                                alignment: Alignment.centerRight,
                                child:Text("SUBSCRIBE \nNOTIFICATIONS",
                                textAlign: TextAlign.center,


                                style: GoogleFonts.roboto(
                                  fontSize:14.0,

                                  color: Color(AppColors.BaseColor),
                                  fontWeight: FontWeight.w600,

                                ),))),  SizedBox(width: 5,),
                            ]))
                    ,  Padding(
                        padding: EdgeInsets.fromLTRB(10,7,10,3),
                        child:
                        Divider(
                          color: Colors.grey,
                        )),

                          Container(
    margin:  EdgeInsets.fromLTRB(20,0,10,0),
    child:Row(

    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[

 _joinButton(),
      SizedBox(width: 30,),
      _DonateButton()


    ]))
,
               Padding(
          padding: EdgeInsets.fromLTRB(10,3,10,7),
        child:
        Divider(
          color: Colors.grey,
        )),

                    _buildList(),



                  ]))])

          ),

        );
  }
  Widget _buildBoxVideoList(BuildContext context,int id,String title,String thumbnail,String lang,String createdAt,String publisher,String duration,String videoUrl,String videoSourceType){




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

                  AspectRatio(
                      aspectRatio: 16 / 9,
                      child:
                      Container(
                        margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),

                        alignment: Alignment.center,
                        // height: ScreenUtil().setHeight(175),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: new AssetImage("assets/thumbnail.png"),

                            alignment: Alignment.center,
                          ),

                        ),

                      )),


                  AspectRatio(
                      aspectRatio: 16 / 9,
                      child:   Container(
                        margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),

                        alignment: Alignment.center,
                        // height: ScreenUtil().setHeight(175),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(url),
                          ),
                        ),

                      )),
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

                            child:PopupMenuButton(
                                icon: Icon(Icons.more_vert),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: Text("Share"),
                                    value: 1,
                                  ),
                                  PopupMenuItem(
                                    child: Text("Report"),
                                    value: 2,
                                  ),
                                  PopupMenuItem(
                                    child: Text("Bookmark"),
                                    value: 3,
                                  ),
                                  PopupMenuItem(
                                    child: Text("Subscribe Notifications"),
                                    value: 4,
                                  )
                                ]
                            )
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
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        if (index == mainData.length) {
          return _buildProgressIndicator();
        } else {
          return GestureDetector(
              onTap: () =>
              {

                Navigator.of(context, rootNavigator: true)
                    .pushReplacement( // ensures fullscreen
                    MaterialPageRoute(
                        builder: (BuildContext context) {
                          return VideoDetailNewPage(content: mainData[index]);
                        }
                    ))
              },
              child:
              _buildBoxVideoList(
                  context,
                  mainData[index].id,
                  mainData[index].title,
                  mainData[index].videoImage,
                  mainData[index].lang,
                  mainData[index].createdAt,
                  mainData[index].channel,
                  mainData[index].video_duration,
                  mainData[index].videoUrl,
                  mainData[index].videoSourceType

              )


          );
        }
      },

    );
  }


  Widget _joinButton() {
    return InkWell(
      onTap: () {

      },

      child: Container(
        width: 140,
        height: 45,
        margin: EdgeInsets.fromLTRB(0,0,0,0),
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
                colors: [Color(AppColors.BaseColor), Color(AppColors.BaseColor)])),
        child: Text(
          'Join Us',
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
        margin: EdgeInsets.fromLTRB(0,0,0,0),
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
          'Donate Us',
          style: GoogleFonts.roboto(fontSize: 17, color: Colors.white,fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
  Widget _buildBoxVideo(BuildContext context,VideoData content){
   var channel=content.channel==null?"My Channel":content.channel;
    final width = MediaQuery.of(context).size.width;

    String html;


    //<iframe src="http://instagram.com/p/a1wDZKopa2/embed" width="400" height="480" frameborder="0" scrolling="no" allowtransparency="true"></iframe>

   if(content.videoSourceType=='instagram'){
     html = '''
          <iframe src="http://instagram.com/p/CSgceH8nTFxjUMBDYnzT97db-ei_KY7fErctX40/embed" width="100%" height="100%" frameborder="0" scrolling="no" allowtransparency="true"></iframe>
     ''';

   }


    else if(content.videoSourceType=='facebook'){
      html = '''
           <iframe width="100%" height="100%"
            src="https://www.facebook.com/v2.3/plugins/video.php? 
            allowfullscreen=false&autoplay=true&href=${content.videoUrl}" </iframe>
     ''';

    }

    else if(content.videoSourceType=='dailymotion'){


       html = '''
           <iframe src='${content.videoUrl}?quality=240&info=0&logo=0' allowFullScreen></iframe>

     ''';


    }

   else {
      var videoIdd;
      try {
        videoIdd = YoutubePlayer.convertUrlToId(content.videoUrl);
        print('this is ' + videoIdd);
      } on Exception catch (exception) {
        // only executed if error is of type Exception
        print('exception');
      } catch (error) {
        // executed for errors of all types other than Exception
        print('catch error');
        //  videoIdd="error";

      }
       html = '''
          <iframe id="ytplayer" style="border-left: ${marginPixel}px solid black;border-right: ${marginPixel}px solid black;" type="text/html" width="100%" height="100%"
  src="https://www.youtube.com/embed/${videoIdd}?autoplay=1&enablejsapi=1"
  frameborder="1" allow="autoplay; encrypted-media" allowfullscreen></iframe>
     ''';

    }

    return    Container(
        margin:EdgeInsets.fromLTRB(0.0,0.0,0.0,12.0) ,

        child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(

                children: <Widget>[

                /*  Container(
                    margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),

                    alignment: Alignment.center,
                    height: (MediaQuery.of(context).size.height/2)-80,
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
                    margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),

                    alignment: Alignment.center,
                    height: (MediaQuery.of(context).size.height/2)-80,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(content.videoImage),
                      ),
                    ),

                  ),
*/
                  HtmlWidget(

                    html,
                    webView: true,
                  )


                ],
              ),









            ]));}
}