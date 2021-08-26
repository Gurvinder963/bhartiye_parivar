import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import '../ApiResponses/VideoListResponse.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../ApiResponses/VideoData.dart';


class VideoDetailPage extends StatefulWidget {
  final VideoData content;


  VideoDetailPage({Key key,@required this.content}) : super(key: key);
  @override
  VideoDetailPageState createState() {
    return VideoDetailPageState(content);
  }
}

class VideoDetailPageState extends State<VideoDetailPage> {
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
  VideoDetailPageState(VideoData content){
    mContent=content;
  }
  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    String fileName = (mContent.videoUrl.split('=').last);
    print("my_file_name"+fileName);
    _ids.add(fileName);
    // mainData.addAll(questionData);
    if (!_ids.isEmpty) {
      print("ids_data" + _ids.first);
      _controller = YoutubePlayerController(
        initialVideoId: _ids.first,
        flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: false,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ),
      )..addListener(listener);
      _idController = TextEditingController();
      _seekToController = TextEditingController();
      _videoMetaData = const YoutubeMetaData();
      _playerState = PlayerState.unknown;
    }

  }
  @override
  void dispose() {
    if (_controller.value.isFullScreen) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
          .then((_) {
        Navigator.pop(context);
      });
    } else {
      _controller.dispose();
      _idController.dispose();
      _seekToController.dispose();
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return YoutubePlayerBuilder(
        onExitFullScreen: () {
      // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
      // SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      if (_controller.value.isFullScreen) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
            .then((_) {
          Navigator.pop(context);
        });
      }
    },
    player: YoutubePlayer(
    controller: _controller,
    showVideoProgressIndicator: false,
    progressIndicatorColor: Colors.blueAccent,
    topActions: <Widget>[
    const SizedBox(width: 8.0),
    Expanded(
    child: _controller != null
    ? Text(
    _controller.metadata.title,
    style: const TextStyle(
    color: Colors.white,
    fontSize: 18.0,
    ),
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
    )
        : Container(),
    ),
    IconButton(
    icon: const Icon(
    Icons.settings,
    color: Colors.white,
    size: 25.0,
    ),
    onPressed: () {

    },
    ),
    ],
    onReady: () {
    _isPlayerReady = true;
    },
    onEnded: (data) {
    /*   _controller
              .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
          _showSnackBar('Next Video Started!');*/
    },
    ),
    builder: (context, player) => Scaffold(
      appBar: AppBar(
        backgroundColor: Color(AppColors.BaseColor),
        title: Text(AppStrings.PlayingVideo),
      ),

      body: Container(
          child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
        _buildBoxVideo(context,mContent,player),


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


              ])

      ),

    ));
  }

  Widget _buildBoxVideo(BuildContext context,VideoData content, Widget player){
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

                  player


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