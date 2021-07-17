import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import '../ApiResponses/VideoListResponse.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class VideoDetailNewPage extends StatefulWidget {
  final Data content;


  VideoDetailNewPage({Key key,@required this.content}) : super(key: key);
  @override
  VideoDetailNewPageState createState() {
    return VideoDetailNewPageState(content);
  }
}

class VideoDetailNewPageState extends State<VideoDetailNewPage> {
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
  VideoDetailNewPageState(Data content){
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
          appBar: AppBar(
            backgroundColor: Color(AppColors.BaseColor),
            title: Text(AppStrings.PlayingVideo),
          ),

          body: Container(
              child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildBoxVideo(context,mContent),


                    Container(
                        margin:  EdgeInsets.fromLTRB(20,10,10,0),
                        child:Row(

                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.report,size: 30,),
                              SizedBox(width: 20,),
                              Image(
                                image: new AssetImage("assets/share.png"),
                                width: 25,
                                height:  25,
                                color: null,
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.center,
                              ),
                              SizedBox(width: 20,),
                              Image(
                                image: new AssetImage("assets/whatsapp.png"),
                                width: 25,
                                height:  25,
                                color: null,
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.center,
                              ),
                              SizedBox(width: 20,),
                              Icon(Icons.bookmark_outline_outlined,size: 30,),

                            ]))
                    ,  Padding(
                        padding: EdgeInsets.fromLTRB(20,7,20,7),
                        child:
                        Divider(
                          color: Colors.grey,
                        )),

                          Container(
    margin:  EdgeInsets.fromLTRB(20,0,10,0),
    child:Row(

    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[

 _joinButton(),
      SizedBox(width: 20,),
      _DonateButton()


    ]))


                  ])

          ),

        );
  }
  Widget _joinButton() {
    return InkWell(
      onTap: () {

      },

      child: Container(
        width: 150,
        height: 50,
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
                colors: [Color(AppColors.BaseColor), Color(AppColors.BaseColor)])),
        child: Text(
          'Join Us',
          style: GoogleFonts.roboto(fontSize: 17, color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _DonateButton() {
    return InkWell(
      onTap: () {

      },

      child: Container(
        width: 150,
        height: 50,
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
                colors: [Colors.green, Colors.green])),
        child: Text(
          'Donate Us',
          style: GoogleFonts.roboto(fontSize: 17, color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
  Widget _buildBoxVideo(BuildContext context,Data content){

    var videoIdd;
    try {

      videoIdd = YoutubePlayer.convertUrlToId(content.videoUrl);
      print('this is '+videoIdd);

    } on Exception catch (exception) {

      // only executed if error is of type Exception
      print('exception');

    } catch (error) {

      // executed for errors of all types other than Exception
      print('catch error');
      //  videoIdd="error";

    }
       String html = '''
          <iframe id="ytplayer" type="text/html" width="500" height="480"
  src="https://www.youtube.com/embed/${videoIdd}?autoplay=1&origin=http://example.com"
  frameborder="0"></iframe>
     ''';
    return    Container(
        margin:EdgeInsets.fromLTRB(0.0,0.0,0.0,12.0) ,

        child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(

                children: <Widget>[

                  Container(
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

                  HtmlWidget(
                    html,
                    webView: true,
                  )


                ],
              ),

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
                                      Text(content.title,
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

                                                /*   Container(
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
                                                SizedBox(width: 10),*/
                                              ])),



                                    ]))),
                        /*  new Expanded(
              flex: 1,

              child:Icon(Icons.more_vert)
          )
*/

                      ]))







            ]));}
}