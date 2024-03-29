import 'dart:convert';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import '../ApiResponses/VideoTrendingListResponse.dart';
import '../ApiResponses/VideoDetailJAVAResponse.dart';
import '../Views/JoinUs.dart';
import '../Views/JoinDonateWhom.dart';
import 'DonateUs.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../Repository/MainRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
//import '../ApiResponses/VideoData.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../ApiResponses/VideoDetailResponse.dart';
import '../ApiResponses/AddToCartResponse.dart';
import '../ApiResponses/BookMarkSaveResponse.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share/share.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../localization/locale_constant.dart';
import 'package:bhartiye_parivar/Utils/constants.dart';
import '../ApiResponses/LiveDataResponse.dart';
String videoCategory="live";
class LiveVideoDetailPage extends StatefulWidget {
  final Live content;


  LiveVideoDetailPage({Key key,@required this.content}) : super(key: key);
  @override
  LiveVideoDetailPageState createState() {

    //videoCategory=content.videoCategory;
    return LiveVideoDetailPageState(content);
  }
}
class ReportList {
  String name;
  int index;
  ReportList({this.name, this.index});
}
class LiveVideoDetailPageState extends State<LiveVideoDetailPage> {
  ScrollController _sc = new ScrollController();
  String radioItem = '';

  // Group Value for Radio Button.
  int radioid = -1;


  bool _isInAsyncCall = false;
  var marginPixel=0;
  List mainData = new List();
  bool isLoading = false;
  bool isBookMarked = false;
  bool isSubscribed= false;
  var likeStatus=0;
  int page = 1;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  Live mContent;
  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;

  final List<String> _ids = [

  ];

  String user_Token;
  String USER_ID;
  LiveVideoDetailPageState(Live content){
    mContent=content;
    var videoIdd="A0pmI3FhoO4";
    if(mContent.liveVideoSourceType=='youtube'){
      try {
        videoIdd = YoutubePlayer.convertUrlToId(mContent.liveVideoUrl);
        print('this is ' + videoIdd);
      } on Exception catch (exception) {
        // only executed if error is of type Exception
        print('exception');
      } catch (error) {
        // executed for errors of all types other than Exception
        print('catch error');
        //  videoIdd="error";

      }
    }
    _ids.add(videoIdd);
  }
  @override
  dispose(){
    if (_controller.value.isFullScreen) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
          .then((_) {
        Navigator.pop(context);
      });
    } else {
      _sc.dispose();
      _controller.dispose();
      _idController.dispose();
      _seekToController.dispose();
      super.dispose();
    }

    super.dispose();
  }
  Future<ShortDynamicLink> getShortLink() async {
    setState(() {
      _isInAsyncCall = true;
    });
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://bhartiyeparivar.page.link',
        link: Uri.parse('https://bhartiyeparivar.page.link/content?contentId=' +
            mContent.liveId.toString() +
            '&contentType=videos'),
        //  link: Uri.parse('https://play.google.com/store/apps/details?id=com.nispl.studyshot&invitedby='+referral_code),
        androidParameters: AndroidParameters(
          packageName: 'com.bhartiyeparivar',
        ),
        iosParameters: IosParameters(
          bundleId: 'com.example',
          minimumVersion: '1.0.1',
          appStoreId: '1405860595',
        ));

    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    return shortDynamicLink;
  }
  Future<AddToCartResponse> subscribeChannelAPI(String channelId,String is_subscribed) async {
    //  final String requestBody = json.encoder.convert(order_items);
    String status = "0";
    if (isSubscribed) {
      status = "0";

    } else {

      status = "1";
    }

    var body =json.encode({"channel_id":channelId,"is_subscribed":status});
    MainRepository repository=new MainRepository();

    return repository.fetchSubscribeChannel(body,user_Token);


  }
  @override
  void initState() {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);


    print("video init call");
    super.initState();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      user_Token=prefs.getString(Prefs.KEY_TOKEN);
      USER_ID=prefs.getString(Prefs.USER_ID);

      if (!isLoading) {
        setState(() {
          isLoading = true;
        });}

      // getVideoDetail(user_Token,mContent.id.toString()).then((value) => {
      //
      //   setState(() {
      //     mContent=value.data[0];
      //     isBookMarked=mContent.bookmark;
      //     isSubscribed=mContent.is_subscribed==1?true:false;
      //     likeStatus=mContent.is_like;
      //     //   isLoading = false;
      //     // mainData.addAll(value.data);
      //
      //   })
      //
      // });
    //   postSaveVideoInput(user_Token,"1","","",mContent.id.toString())
    //       .then((res) async {});
    //
    //
       apiCall();
    //
       return (prefs.getString('token'));
     });
    _controller = YoutubePlayerController(
      initialVideoId: _ids.first,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,

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



    _sc.addListener(() {



      if (_sc.position.pixels == _sc.position.maxScrollExtent) {

        apiCall();
      }
    });

  }
  void listener() {
    if (_isPlayerReady && mounted) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;


      });
    }
  }
  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();


    Duration position=_controller.value.position;
    int sec=position.inSeconds;
    //
    // postSaveVideoInput(user_Token,"",sec.toString(),"",mContent.id.toString())
    //     .then((res) async {});
    super.deactivate();
  }


  Future<AddToCartResponse> postSaveVideoInput(String token,String clickedStatus,String videoPlayTime,String share,String content_id) async {

    var body =json.encode({"video_clicked_status": clickedStatus, "video_watch_time": videoPlayTime,"shared_link_click_number": share,"video_unique_id":content_id});
    MainRepository repository=new MainRepository();
    return repository.fetchSaveVideoInput(body,token);

  }


  Future<BookMarkSaveResponse> postAddBookMark(String content_type,String token,String content_id) async {
    String status = "0";
    if (isBookMarked) {
      status = "0";

    } else {

      status = "1";
    }

    var body =json.encode({"content_type": content_type, "content_id": content_id,"bookmark_type": status});
    MainRepository repository=new MainRepository();
    return repository.fetchAddBookMark(body,token);

  }

  Future<AddToCartResponse> postAddLike(String content_type,String token,String content_id) async {


    var body =json.encode({"content_type": content_type, "content_id": content_id,"like_status": likeStatus});
    MainRepository repository=new MainRepository();
    return repository.fetchSaveLikeStatus(body,token);

  }

  Future<VideoDetailJAVAResponse> getVideoDetail(String user_Token,String id) async {

    // var body ={'lang_code':''};
    // MainRepository repository=new MainRepository();
    // return repository.fetchVideoDetailData(id,body,user_Token);

    var body =json.encode({"userid": USER_ID, "video_category": videoCategory,"video_id": id,"appcode":Constants.AppCode,"token":user_Token});
    MainRepository repository=new MainRepository();
    return repository.fetchVideoDetailDataJAVA(body);
  }


  void apiCall(){
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });}
    getLocaleContentLang().then((locale) {

      if(locale==null){
        locale="";
      }

      getVideosListSuggestion(user_Token,videoCategory,mContent.liveId.toString()).then((value) => {

        setState(() {
          isLoading = false;
          mainData.addAll(value.live);

          if (!mainData.isEmpty) {
            page++;
          }
        })

      });



    });

  }

/*
  Future<VideoListResponse> getVideosList(String user_Token,String videoCategory,String videoId) async {

    var body ={'video_category':videoCategory,"video_id":videoId};
    MainRepository repository=new MainRepository();
    return repository.fetchVideoData(body,user_Token);

  }*/


  Future<LiveDataResponse> getVideosListSuggestion(String user_Token,String videoCategory,String videoId) async {
    MainRepository repository=new MainRepository();
    String pageIndex = page.toString();
    var body =json.encode({"appcode":Constants.AppCode, "token": user_Token,"userid": USER_ID,"video_category":videoCategory,"page":pageIndex,"video_id":videoId});


      return repository.fetchLiveVideoSuggestListJAVA(body);


  }



  subscribeAPI(){

    subscribeChannelAPI(mContent.liveChannelId.toString(),"1").then((res) async {
      String msg;
      if(isSubscribed){
        setState(() {
          isSubscribed = false;
        });

        msg="Unsubscribe channel successfully";
      }
      else{
        setState(() {
          isSubscribed = true;
        });
        msg="Subscribe channel successfully";
      }

      if(res.status==1){

        Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);


      }

    }
    );

  }

  _onShare(BuildContext context,String title,String thumbnail) async {

    var url = thumbnail;
    var response = await get(url);
    final documentDirectory = (await getExternalStorageDirectory()).path;
    File imgFile = new File('$documentDirectory/flutter.png');
    imgFile.writeAsBytesSync(response.bodyBytes);
    List<String> imagePaths = [];
    imagePaths.add('$documentDirectory/flutter.png');

    if (imagePaths.isNotEmpty) {
      await Share.shareFiles(imagePaths,
        text: title,

      );
    } else {
      await Share.share(title,

      );
    }
  }

  Widget mainWidget(Widget player){
    var channel=mContent.liveChannel;
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    final height = MediaQuery.of(context).size.height;
   // final DateFormat formatter = DateFormat('dd-MM-yyyy');
    //final String formatted = formatter.format(DateTime.parse(mContent.created_at));

    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
           backgroundColor:
              orientation == Orientation.portrait ? null : Colors.black,
          appBar:isPortrait?AppBar(
            toolbarHeight: 50,
            backgroundColor: Color(AppColors.BaseColor),
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => {
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.portraitUp])
                      .then((_) {
                    Navigator.of(context, rootNavigator: true).pop(context);
                  })
                }
            ),
            title: Text(AppStrings.PlayingVideo),
          ):null,

          body: ModalProgressHUD(
              inAsyncCall: _isInAsyncCall,
              // demo of some additional parameters
              opacity: 0.01,
              progressIndicator: CircularProgressIndicator(),
              child: Container(

                  child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,


                      children: <Widget>[
                        mContent.liveVideoSourceType=='facebook' || mContent.liveVideoSourceType=='brighteon'?
                        _buildBoxVideo(context,mContent,orientation):player,
                        Expanded(
                            child:
                            ListView(
                                controller: _sc,
                                children: <Widget>[
                                  Container(
                                      margin:  EdgeInsets.fromLTRB(10,10,10,0),
                                      child:Row(

                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[

                                            new Container(
                                                width: 44.0,
                                                height: 44.0,
                                                decoration: new BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: new DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: new NetworkImage(
                                                            mContent.liveChannelImage)
                                                    )
                                                )),
                                            SizedBox(height: 5,width: 8,),

                                            new Expanded(
                                                flex: 7,
                                                child:Container(

                                                    child:Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          SizedBox(height: 5),
                                                          Text(mContent.liveTitle,

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


                                                                  ])),



                                                        ]))),

                                            IconButton(
                                                icon:Image(
                                                  image: new AssetImage("assets/share.png"),
                                                  width: 23,
                                                  height:  23,
                                                  color:Colors.black,
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.center,
                                                ),
                                                onPressed: () {

                                                  // postSaveVideoInput(user_Token,"","","1",mContent.id.toString())
                                                  //     .then((res) async {
                                                  //
                                                  //
                                                    getShortLink().then((res) {
                                                       setState(() {
                                                         _isInAsyncCall = false;
                                                      });
                                                       var url = res.shortUrl
                                                           .toString();

                                                       _onShare(
                                                           context, mContent.liveTitle +
                                                           ' ' +
                                                           url, mContent.liveVideoImage);
                                                     });


                                                  // });

                                                }),
                                          ])),

                                  Container(
                                      margin:  EdgeInsets.fromLTRB(10,15,10,0),
                                      child:Row(

                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(width: 2,),



                                            //
                                            // SizedBox(width: 2,),

                                            //  Icon(Icons.bookmark_outline_outlined,size: 28,color: Color(0xFF666666),),
                                            // Expanded( child:Align(
                                            //     alignment: Alignment.centerRight,
                                            //     child: GestureDetector(
                                            //         onTap: () {
                                            //
                                            //           if(isSubscribed){
                                            //             Widget okButton = FlatButton(
                                            //               child: Text("UNSUBSCRIBE"),
                                            //               onPressed: () {
                                            //                 Navigator.of(context, rootNavigator: true).pop('dialog');
                                            //                 subscribeAPI();
                                            //
                                            //               },
                                            //             );
                                            //             Widget CANCELButton = FlatButton(
                                            //               child: Text("CANCEL"),
                                            //               onPressed: () {
                                            //                 Navigator.of(context, rootNavigator: true).pop('dialog');
                                            //
                                            //               },
                                            //             );
                                            //             // set up the AlertDialog
                                            //             AlertDialog alert = AlertDialog(
                                            //
                                            //               content: Text("Unsubscribe from "+mContent.liveChannel),
                                            //               actions: [
                                            //                 CANCELButton,
                                            //                 okButton,
                                            //
                                            //               ],
                                            //             );
                                            //
                                            //             // show the dialog
                                            //             showDialog(
                                            //               context: context,
                                            //               builder: (BuildContext context) {
                                            //                 return alert;
                                            //               },
                                            //             );
                                            //           }
                                            //           else{
                                            //             subscribeAPI();
                                            //
                                            //           }
                                            //
                                            //
                                            //
                                            //
                                            //         },child:isSubscribed?Text("SUBSCRIBED",
                                            //       textAlign: TextAlign.center,
                                            //
                                            //
                                            //       style: GoogleFonts.roboto(
                                            //         fontSize:16.0,
                                            //
                                            //         color: Color(0xFF000000),
                                            //         fontWeight: FontWeight.w600,
                                            //
                                            //       ),):Text("SUBSCRIBE \nNOTIFICATIONS",
                                            //       textAlign: TextAlign.center,
                                            //
                                            //
                                            //       style: GoogleFonts.roboto(
                                            //         fontSize:14.0,
                                            //
                                            //         color: Color(AppColors.BaseColor),
                                            //         fontWeight: FontWeight.w600,
                                            //
                                            //       ),)))),  SizedBox(width: 5,),
                                          ]))
                                  ,  Padding(
                                      padding: EdgeInsets.fromLTRB(10,7,10,3),
                                      child:
                                      Divider(
                                        color: Colors.grey,
                                      )),

                                  Container(
                                      margin:  EdgeInsets.fromLTRB(20,0,20,0),
                                      child:Row(

                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[

                                            _joinButton(),
                                          Spacer(),
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

              )),

        );});
  }

  @override
  Widget build(BuildContext context) {

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),

        orientation: Orientation.portrait);
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    if(!isPortrait){

      // marginPixel=0;
      // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
      SystemChrome.setEnabledSystemUIOverlays([]);

    }
    else{
      //marginPixel=0;
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    }

  //  var channel=mContent.channel==null?"My Channel":mContent.channel;

    final height = MediaQuery.of(context).size.height;
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
   // final String formatted = formatter.format(DateTime.parse(mContent.created_at));

    if(mContent.liveVideoSourceType=='facebook' || mContent.liveVideoSourceType=='brighteon'){

      return mainWidget(null);

    }
    else {
      return YoutubePlayerBuilder(

          onEnterFullScreen: () {
            Future.delayed(const Duration(milliseconds: 2000), () {
              _controller.play();
            });
          },
          onExitFullScreen: () {
            if (_controller.value.isFullScreen) {
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp])
                  .then((_) {
                Navigator.pop(context);
              });
            }
          },
          player: YoutubePlayer(
            controller: _controller,
            aspectRatio: 16 / 9,
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

            },
          ),
          builder: (context, player) => mainWidget(player));
    }
  }
  Widget _buildBoxVideoList(BuildContext context,int id,String title,String thumbnail,String channel,String channel_image,String videoUrl,String videoSourceType){


    // final DateFormat formatter = DateFormat('dd-MM-yyyy');
    // final String formatted = formatter.format(DateTime.parse(createdAt));
    //
    // channel=channel==null?"My Channel":channel;
    // duration=duration==null?"4:50":duration;
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



                  thumbnail!=null? AspectRatio(
                      aspectRatio: 16 / 9,
                      child:   Container(
                        margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),

                        alignment: Alignment.center,
                        // height: ScreenUtil().setHeight(175),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(thumbnail),
                          ),
                        ),

                      )):Container(height: 0,width: 0,),


                ],
              ),

              Container(
                  margin:  EdgeInsets.fromLTRB(10,5,10,0),
                  child:Row(

                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        channel_image!=null? new Container(
                            width: 44.0,
                            height: 44.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: new NetworkImage(
                                        channel_image)
                                )
                            )):Container(width: 0,height: 0,),
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
                                                channel!=null? Text(channel,   overflow: TextOverflow.ellipsis,
                                                  maxLines: 1, style: GoogleFonts.roboto(
                                                    fontSize:12.0,
                                                    color: Color(0xFF5a5a5a),

                                                  ),):Container(width: 0,height: 0,),
                                                

                                                SizedBox(width: 10),
                                              ])),



                                    ]))),
                        // new Expanded(
                        //     flex: 1,
                        //
                        //     child:PopupMenuButton(
                        //         icon: Icon(Icons.more_vert),
                        //         itemBuilder: (context) => [
                        //           PopupMenuItem(
                        //             child: Text("Share"),
                        //             value: 1,
                        //           ),
                        //           PopupMenuItem(
                        //             child: Text("Report"),
                        //             value: 2,
                        //           ),
                        //           PopupMenuItem(
                        //             child: Text("Bookmark"),
                        //             value: 3,
                        //           ),
                        //           PopupMenuItem(
                        //             child: Text("Subscribe Notifications"),
                        //             value: 4,
                        //           )
                        //         ]
                        //     )
                        // )


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
                          return LiveVideoDetailPage(content: mainData[index]);
                        }
                    ))
              },
              child:
              _buildBoxVideoList(
                  context,
                  mainData[index].liveId,

                  mainData[index].liveTitle,
                  mainData[index].liveVideoImage,


                  mainData[index].liveChannel,
                  mainData[index].liveChannelImage,

                  mainData[index].liveVideoUrl,
                  mainData[index].liveVideoSourceType

              )


          );
        }
      },

    );
  }


  Widget _joinButton() {
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
            MaterialPageRoute(
                builder: (BuildContext context) {

               return JoinDonateWhomPage(from:"Join",fromScreen:"Detail",channel_id:mContent.liveChannelId);
                }
            ) );
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
        Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
            MaterialPageRoute(
                builder: (BuildContext context) {
                   return JoinDonateWhomPage(from:"Donate",fromScreen:"Detail",channel_id:mContent.liveChannelId);
                }
            ) );
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
  Widget _buildBoxVideo(BuildContext context,Live content, Orientation orientation){
   // var channel=content.channel==null?"My Channel":content.channel;
    final width = MediaQuery.of(context).size.width;

    String html;
    // content.videoUrl="https://www.facebook.com/facebook/videos/10153231379946729/";

    //<iframe src="http://instagram.com/p/a1wDZKopa2/embed" width="400" height="480" frameborder="0" scrolling="no" allowtransparency="true"></iframe>

    if(content.liveVideoSourceType=='instagram'){
      html = '''
          <iframe src="http://instagram.com/p/CSgceH8nTFxjUMBDYnzT97db-ei_KY7fErctX40/embed" width="100%" height="100%" frameborder="0" scrolling="no" allowtransparency="true"></iframe>
     ''';

    }


   else if (content.liveVideoSourceType == 'facebook') {
      html = '''
          <div autoplay muted loop id="myVideo">
  <iframe style="width:100%;height:100%;position:absolute;left:0px;top:100px;overflow:visible;"
            src="https://www.facebook.com/v2.3/plugins/video.php? 
            &autoplay=false&href=${content.liveVideoUrl}" allowfullscreen</iframe></div>
     ''';
    }

    else if(content.liveVideoSourceType=='dailymotion'){


      html = '''
           <iframe src='${content.liveVideoUrl}?quality=240&info=0&logo=0' allowFullScreen></iframe>

     ''';


    }

    else if(content.liveVideoSourceType=='brighteon'){


      html = '''
           <iframe width="600" height="337" src='${content.liveVideoUrl}' frameborder="0" allow="autoplay; encrypted-media"></iframe>

     ''';


    }

    else {
      var videoIdd;
      try {
        videoIdd = YoutubePlayer.convertUrlToId(content.liveVideoUrl);
        print('this is ' + videoIdd);
      } on Exception catch (exception) {
        // only executed if error is of type Exception
        print('exception');
      } catch (error) {
        // executed for errors of all types other than Exception
        print('catch error');
        //  videoIdd="error";

      }
      html = '''<iframe id="player" width="100%" height="100%" style ="padding: 0px;position: relative; padding-top: 0px;height: 0;
            overflow: hidden;" type="text/html"
  src="https://www.youtube.com/embed/${videoIdd}?autoplay=true"
  frameborder="1"></iframe>
     ''';

      /*   html = """<!DOCTYPE html>
          <html>
            <head>
            <style>
            body {
              overflow: hidden;
            }
        .embed-youtube {
            position: relative;
            padding-bottom: 56px;
            padding-top: 20px;
            height: 0;
            overflow: hidden;
        }


        .embed-youtube iframe {
            border: 0;
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }

        </style>

        <meta charset="UTF-8">
         <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
          <meta http-equiv="X-UA-Compatible" content="ie=edge">
           </head>
          <body bgcolor="#121212">
        <div class="embed-youtube">
     <iframe id="ytplayer" type="text/html" style ="padding-bottom: 65px;position: relative; padding-top: 0px;height: 0;
            overflow: hidden;";
  src="https://www.youtube.com/embed/${videoIdd}?autoplay=1&enablejsapi=1"
  frameborder="1" allow="autoplay; encrypted-media" allowfullscreen></iframe></div>
          </body>
        </html>
  """;*/
    }

    return    Container(
        margin:EdgeInsets.fromLTRB(0.0,0.0,0.0,12.0) ,

        child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
             
                      Row(
                children: [
                  
                  Flexible(
                    flex: orientation == Orientation.portrait ? 0 : 1,
                    child: Container(),
                  ),

                  Flexible(
                    flex: 15,
                    child: HtmlWidget(
                      html,
                      // ignore: deprecated_member_use
                      webView: true,
                      // ignore: deprecated_member_use
                    ),
                  ),
                
                  Flexible(
                    flex: orientation == Orientation.portrait ? 0 : 1,
                    child: Container(),
                  ),


                ] ) 




            ]));}
}