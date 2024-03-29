import 'dart:convert';

import 'package:bhartiye_parivar/Utils/constants.dart';
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
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../localization/locale_constant.dart';
import '../ApiResponses/AddToCartResponse.dart';
import '../ApiResponses/BookMarkSaveResponse.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../Interfaces/OnAnyDrawerItemOpen.dart';
import '../Interfaces/OnLangChange.dart';
import '../Interfaces/OnLandScape.dart';
String videoCategory="main";
YoutubePlayerController _controller=null;
TextEditingController _idController;
TextEditingController _seekToController;

PlayerState _playerState;
YoutubeMetaData _videoMetaData;

final List<String> _ids = [

];
class MainPage extends StatefulWidget {
  @override
  MainPageState createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  ScrollController _sc = new ScrollController();
  List mainData = new List();
  Live liveData;
  int page = 1;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
 // var refreshLiveKey = GlobalKey<RefreshIndicatorState>();
  bool isLoading = false;

  String user_Token;
  //bool isBookMarked = false;
 // bool isSubscribed= false;
  bool _isInAsyncCall = false;
  bool _isPlayerReady = false;
  String USER_ID;

  @override
  dispose(){
print("main page dispose called");


    if (_controller!=null && _controller.value.isFullScreen) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
          .then((_) {
        Navigator.pop(context);
      });
    } else {
      _sc.dispose();
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      if (_controller!=null){
        _controller.dispose();
        _idController.dispose();
        _seekToController.dispose();
      }

    
    }

    super.dispose();
  }


  @override
  void deactivate() {
    // Pauses video while navigating to next page.
  if(_controller!=null) {
    _controller.pause();
  }

    super.deactivate();
  }

  @override
  void initState() {
    super.initState();
    // liveData=new Live();
    // liveData.liveTitle="chaldi kudi";
    // liveData.liveChannelImage="xyx";
    // liveData.liveVideoSourceType="youtube";
    // liveData.liveChannel="BP";
    // liveData.liveStatus="1";
    // liveData.liveVideoImage="1";



    eventBusDO.on<OnAnyDrawerItemOpen>().listen((event) {
      // All events are of type UserLoggedInEvent (or subtypes of it).
      // print("my_cart_count"+event.count);

     print("-------on pause call-------");

     if(_controller!=null) {
       _controller.pause();
     }
    });

    eventBusLC.on<OnLangChange>().listen((event) {
      setState(() {
        isLoading = false;
        liveData=null;
        mainData.clear();
        page = 1;

      });

      apiCall();
    });

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {

      user_Token=prefs.getString(Prefs.KEY_TOKEN);
      USER_ID=prefs.getString(Prefs.USER_ID);





      apiCall();




      return (prefs.getString('token'));
    });


    _sc.addListener(() {

      print(_sc.position.pixels);
      print(_sc.position.maxScrollExtent);

      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        print("on more load");
        apiCall();
      }
    });

  }
  void listener() {
    // if (_isPlayerReady && mounted) {
    //   setState(() {
    //     _playerState = _controller.value.playerState;
    //     _videoMetaData = _controller.metadata;
    //     print(_videoMetaData);
    //
    //   });
    // }
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

      getVideosList(user_Token,videoCategory,locale).then((
          value) async {

        setState(() {
          isLoading = false;
          mainData.addAll(value.data);

          if(liveData==null && value.live.liveStatus!="0") {
            liveData = value.live;
            if (liveData != null && liveData.liveVideoSourceType=='youtube' && value.live.liveStatus=="1") {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeRight,
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]);
              print(liveData.liveStatus);
              var videoIdd;
              try {
                videoIdd = YoutubePlayer.convertUrlToId(liveData.liveVideoUrl);
              } on Exception catch (exception) {
                // only executed if error is of type Exception
                print('exception');
              } catch (error) {
                // executed for errors of all types other than Exception
                print('catch error');
                //  videoIdd="error";

              }


              _controller = YoutubePlayerController(
                initialVideoId: videoIdd,
                flags: const YoutubePlayerFlags(
                  mute: false,
                  autoPlay: true,
                  //  controlsVisibleAtStart: true,
                  disableDragSeek: false,
                  //  hideControls: false,
                  loop: false,
                  isLive: true,
                  forceHD: false,
                  enableCaption: true,
                ),
              )
                ..addListener(listener);
              _idController = TextEditingController();
              _seekToController = TextEditingController();
              _videoMetaData = const YoutubeMetaData();
              _playerState = PlayerState.unknown;
            }
        else if (liveData != null && liveData.liveVideoSourceType=='facebook' && value.live.liveStatus=="1") {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeRight,
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]);
            }
       else {
              SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
            }



          }

          else {
            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          }



          if (!mainData.isEmpty) {
            page++;
          }
        });



      });


    });

  }
  Future<ShortDynamicLink> getShortLink(String id) async {
    setState(() {
      _isInAsyncCall = true;
    });
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://bhartiyeparivar.page.link',
        link: Uri.parse('https://bhartiyeparivar.page.link/content?contentId=' +
            id.toString() +
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
  Future _asyncInputDialog(BuildContext context,String id) async {
    String teamName = '';
    return showDialog(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Report Video"),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            reverse: true,
            child: SizedBox(
              height: 250,
              width: 400,
              child: new TextField(
                autofocus: false,
                maxLines: 500,
                onChanged: (value) {
                  teamName = value;
                },
                decoration: new InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                  ),

                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  hintText: 'Enter your report reason here',
                ),
              ),
            ),
          ),

          actions: [
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {

                Navigator.of(context).pop(teamName);
              },
            ),

            FlatButton(
              child: Text('REPORT'),
              onPressed: () {
                setState(() {
                  _isInAsyncCall = true;
                });
                Navigator.of(context).pop(teamName);
                saveReportAPI(id,teamName).then((res) async {
                  String msg;
                  setState(() {
                    _isInAsyncCall = false;
                  });
                  Fluttertoast.showToast(
                      msg: "Report save successfully",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0);

                });
              },
            ),
          ],
        );
      },
    );
  }
  Future<AddToCartResponse> saveReportAPI(String id,message) async {
    //  final String requestBody = json.encoder.convert(order_items);


    var body =json.encode({"content_id":id.toString(),"content_type":"1","message":message});
    MainRepository repository=new MainRepository();

    return repository.fetchReportSave(body,user_Token);


  }

  Future<AddToCartResponse> subscribeChannelAPI(String channelId,String xyz,int is_subscribed) async {
    //  final String requestBody = json.encoder.convert(order_items);
    String status = "1";
  /*  if (is_subscribed==1) {
      status = "0";

    } else {

      status = "1";
    }*/

    var body =json.encode({"channel_id":channelId,"is_subscribed":status});
    MainRepository repository=new MainRepository();

    return repository.fetchSubscribeChannel(body,user_Token);


  }
  Future<AddToCartResponse> postSaveVideoInput(String token,String clickedStatus,String videoPlayTime,String share,String content_id) async {

    var body =json.encode({"video_clicked_status": clickedStatus, "video_watch_time": videoPlayTime,"shared_link_click_number": share,"video_unique_id":content_id});
    MainRepository repository=new MainRepository();
    return repository.fetchSaveVideoInput(body,token);

  }


  Future<BookMarkSaveResponse> postAddBookMark(String content_type,String token,String content_id, bool isBookMarked) async {
    String status = "1";
  /*  if (isBookMarked) {
      status = "0";

    } else {

      status = "1";
    }*/
    print('my_token'+token);
    var body =json.encode({"content_type": content_type, "content_id": content_id,"bookmark_type": status});
    MainRepository repository=new MainRepository();
    return repository.fetchAddBookMark(body,token);

  }


  Future<VideoListResponse> getVideosList(String user_Token,String videoCategory, String locale) async {

    // String pageIndex = page.toString();
    // String perPage = "10";
    // print(locale.toString());
    // var body ={'video_category':videoCategory,'lang_code':locale, 'page': pageIndex,
    //   'per_page': perPage,};
    // MainRepository repository=new MainRepository();
    // return repository.fetchVideoData(body,user_Token);

 String pageIndex = page.toString();
 var body =json.encode({"appcode":Constants.AppCode, "token": user_Token,"userid": USER_ID,"video_category":videoCategory,"page":pageIndex});
 MainRepository repository=new MainRepository();
     return repository.fetchVideoListJAVA(body);


    // var body ={'video_category':videoCategory,'lang_code':locale, 'page': pageIndex,
    //   'per_page': perPage,};
    // MainRepository repository=new MainRepository();
    // return repository.fetchVideoData(body,user_Token);




  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery
                .of(context)
                .size
                .width,
            maxHeight: MediaQuery
                .of(context)
                .size
                .height),
        designSize: Size(360, 690),

        orientation: Orientation.portrait);
    var isPortrait = MediaQuery
        .of(context)
        .orientation == Orientation.portrait;

    if(liveData!=null &&
        liveData.liveStatus=="1") {
      if (!isPortrait) {
        // marginPixel=0;
        // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
        SystemChrome.setEnabledSystemUIOverlays([]);
        eventBusLSP.fire(OnLandScape("Land"));
      }
      else {
        //marginPixel=0;
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        eventBusLSP.fire(OnLandScape("Port"));
      }
      }
    print("live data");



    if (liveData != null && liveData.liveVideoSourceType=='youtube') {
      return YoutubePlayerBuilder(

          onEnterFullScreen: () {
            Future.delayed(const Duration(milliseconds: 2000), () {
              _controller.play();
            });
          },
          onExitFullScreen: () {

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
          builder: (context, player) => mainWidget(player,Orientation.portrait));
    }
    else if(liveData != null && liveData.liveVideoSourceType=='facebook'){
return OrientationBuilder(
      builder: (context, orientation) {
      return Scaffold(
        backgroundColor:
              orientation == Orientation.portrait ? null : Colors.black,
        body: mainWidget(null,orientation)

      );
      });
   
    }

    else if (mainData.length > 0) {

      return Scaffold(

        body: Container(
            margin: EdgeInsets.fromLTRB(0.0,2.0,0.0,0.0),
            child:_buildList()),

      );


    }
    else {
      return Scaffold(

        body: Center(child: Text('Loading data...')),

      );
      //mainWidget(null);
    }

  }

void scheduleAlarm(String title
      ) async {

DateTime scheduleAlarmDateTime;
   
      scheduleAlarmDateTime = DateTime.now().add(Duration(minutes:1));
   

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
     
      sound: RawResourceAndroidNotificationSound('simple_ring'),
    
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'simple_ring.mp3',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android:androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);
 FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.schedule(0, Constants.AppName ,title,
        scheduleAlarmDateTime, platformChannelSpecifics);
  }



  Widget mainWidget(Widget player, Orientation orientation){


    String html;
    if(liveData!=null && liveData.liveVideoSourceType=='facebook'){
      html = '''
          <div autoplay muted loop id="myVideo">
  <iframe style="width:100%;height:100%;position:absolute;left:0px;top:100px;overflow:visible;"
            src="https://www.facebook.com/v2.3/plugins/video.php? 
            &autoplay=false&href=${liveData.liveVideoUrl}" allowfullscreen</iframe></div>
     ''';


    }


    return 
   Scaffold(

          body: ModalProgressHUD(
              inAsyncCall: _isInAsyncCall,
              // demo of some additional parameters
              opacity: 0.01,
              progressIndicator: CircularProgressIndicator(),
              child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,


                      children: <Widget>[
                        // liveData.liveVideoSourceType=='facebook' ?
                        SizedBox(height: 2,),

                        liveData!=null?(

                        liveData.liveStatus=="1"?
                        liveData.liveVideoSourceType=='facebook' ?
                       
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


                ] ): player:
                       Container(width: 0,height: 0,)
                        ):Container(width: 0.0, height: 0.0),


                    Expanded(
                        child:
                    RefreshIndicator(
                    key: refreshKey,
                        onRefresh: _getData,
                    child:
                        ListView(

                            controller: _sc,
                          // parent ListView
                            children: <Widget>[

                              liveData!=null?(
                        liveData.liveStatus=="2"?
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
                                        image: NetworkImage(liveData.liveVideoImage),
                                      ),
                                    ),

                                  )
                              ):
                        Container(width: 0,height: 0,)
                              ):Container(width: 0.0, height: 0.0),


                            liveData!=null?
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
                                                        liveData.liveChannelImage)
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
                                                      Text(liveData.liveTitle,

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
                                                                Text(liveData.liveChannel,   overflow: TextOverflow.ellipsis,
                                                                  maxLines: 1, style: GoogleFonts.roboto(
                                                                    fontSize:12.0,
                                                                    color: Color(0xFF5a5a5a),

                                                                  ),),



                                                                SizedBox(width: 10),
                                                              ])),



                                                    ]))),
                                  liveData!=null &&
                                      liveData.liveStatus=="2"?  new Expanded(
                                            flex: 1,
                                            child:PopupMenuButton(
                                                child:new Image(
                                                  image: new AssetImage("assets/bell_new.png"),
                                                  width: 44,
                                                  height: 44,
                                                  color: null,
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.center,
                                                ),
                                                onSelected: (newValue) { // add this property
                                                  if(newValue==1){
                                                  // scheduleNotification(1,liveData.liveTitle);
                                                 scheduleAlarm(liveData.liveTitle+" is Live now");
                                                 
                                                 }

                                                 else {
                                                    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
                                                     flutterLocalNotificationsPlugin.cancel(0);
                                                 }

                                                },
                                                itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                    child: Container(child:
                                                    Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                 Icon(
                                  Icons.notifications_rounded,
                                  color: Colors.black,
                                  size: 25,
                                ),
                                SizedBox(width: 10),

                                                          Text("  RING  ", style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 16)),
                                                    ])),
                                                
                                                    value: 1,
                                                  ),
                                                  PopupMenuItem(
                                                    child: Container(child:
                                                    Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                 Icon(
                                  Icons.notifications_none,
                                  color: Colors.black,
                                  size: 25,
                                ),
                                SizedBox(width: 10),

                                                          Text("  NONE  ", style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 16)),
                                                    ])),
                                                    value: 2,
                                                  ),

                                                ]
                                            )
                                        ):Container(width: 0.0, height: 0.0),

                                        liveData!=null &&
                                            liveData.liveStatus=="1"?  new Expanded(
                                            flex: 3,
                                            child:Container(
                                                color:  Color(0xFFff0000),
                                                padding:EdgeInsets.fromLTRB(1,3,1,3),
                                                child:
                                            Center(child:Text(liveData.liveScheduledAt,



                                              style: GoogleFonts.roboto(
                                                fontSize:13.0,


                                                color: Color(0xFFffffff),
                                                fontWeight: FontWeight.w500,

                                              )),))
                                        ):Container(width: 0.0, height: 0.0)
                                      ])):Container(width: 0.0, height: 0.0),

                           liveData!=null && liveData.liveStatus=="2"?Padding(
                                  padding: EdgeInsets.fromLTRB(15,10,15,10),
                                  child:
                                  Divider(
                                    height: 1,
                                    thickness: 1,

                                  )):Container(width: 0.0, height: 0.0),
                              liveData!=null && liveData.liveStatus=="2"?Center(child:Text(liveData.liveScheduledAt,

                                overflow: TextOverflow.ellipsis,

                                style: GoogleFonts.roboto(
                                  fontSize:15.0,

                                  color: Color(0xFFff0000),
                                  fontWeight: FontWeight.w500,

                                ),)):Container(width: 0.0, height: 0.0),
                              liveData!=null && liveData.liveStatus=="2"?Padding(
                                  padding: EdgeInsets.fromLTRB(15,10,15,10),
                                  child:
                                  Divider(
                                    height: 1,
                                    thickness: 1,

                                  )):Container(width: 0.0, height: 0.0),

                              SizedBox(height: 10,),
                              _buildList()
                              ]
                        ))
                    )

                                 // _buildList(),



                              ]

              )),

        );
  }

  Future<void> scheduleNotification(int count,String title) async {
    tz.initializeDatabase([]);
    var scheduledNotificationDateTime =
    DateTime(2021,10,11,1,17,0); //Here you can set your custom Date&Time


    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    print("formateed--"+formatted);
    BigTextStyleInformation bigTextStyleInformation =
    BigTextStyleInformation(
      'scheduled body',
      htmlFormatBigText: true,
      contentTitle: 'scheduled title',
      htmlFormatContentTitle: true,

    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();



    DateTime newDate = new DateTime(now.year, now.month, now.day,now.hour,now.minute+2);

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('big text channel id',
        'big text channel name', 'big text channel description', importance: Importance.max,
        priority: Priority.high,
        when: newDate.millisecondsSinceEpoch);
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.show(
        0, 'Live Video Reminder', title+' Video is Live now', platformChannelSpecifics,
        payload: 'item x');



    Fluttertoast.showToast(
        msg: "Live video Reminder set successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);


  }



  subscribeAPI(String channel_id,int is_subscribed,int index){

    subscribeChannelAPI(channel_id.toString(),"1",is_subscribed).then((res) async {
      String msg;
      // if(is_subscribed==1){
      //
      //   mainData[index].is_subscribed=false;
      //   msg="Unsubscribe channel successfully";
      // }
      // else{
        mainData[index].is_subscribed=1;
        msg="Subscribe channel successfully";
      //}

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


  Widget _buildBoxVideo(BuildContext context,int index,int id,String title,String thumbnail,String createdAt,String channel_id,String channel,String channel_image,String duration,String videoUrl,String videoSourceType,int is_subscribed,bool bookmark,int watched_percent){


    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(DateTime.parse(createdAt));

    channel=channel==null?"My Channel":channel;
   // duration=channel==null?"4:50":duration;
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

                  watched_percent>0?Positioned.fill(
            child:Align(
              alignment: Alignment.bottomLeft,
              child:
                  SliderTheme(
                    child: Container(
                        height: 1,
                        child:Slider(
                      value: watched_percent.toDouble(),

                      max: 100,
                      min: 0,
                      activeColor: Colors.red,
                      inactiveColor: Colors.grey,
                      onChanged: (double value) {},
                    )),
                    data: SliderTheme.of(context).copyWith(
                        trackHeight: 1,
                        trackShape: CustomTrackShape(),
                        thumbColor: Colors.transparent,

                        thumbShape: SliderComponentShape.noThumb),
                  ))):Container(height: 0,width: 0,),

                ],
              ),


              Container(
                  margin:  EdgeInsets.fromLTRB(10,5,10,0),
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
                                        channel_image)
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
                        new Expanded(
                            flex: 1,

                            child:PopupMenuButton(
                                icon: Icon(Icons.more_vert),
                                onSelected: (newValue) { // add this property

                                  if(newValue==1){

                                    postSaveVideoInput(user_Token,"","","1",id.toString())
                                        .then((res) async {


                                      getShortLink(id.toString()).then((res) {
                                        setState(() {
                                          _isInAsyncCall = false;
                                        });
                                        var url = res.shortUrl
                                            .toString();

                                        _onShare(
                                            context, title +
                                            ' ' +
                                            url, thumbnail);
                                      });


                                    });


                                  }

                                  else if(newValue==2){

                                    _asyncInputDialog(context,id.toString());

                                  }
                                  else if(newValue==3){

                                  /*  setState(() {
                                      _isInAsyncCall = true;
                                    });*/

                                    postAddBookMark("1",user_Token,id.toString(),bookmark)
                                        .then((res) async {
                                    /*  setState(() {
                                        _isInAsyncCall = false;
                                      });*/


                                      String mmsg="";
                                      if (res.bookmarkType == 1) {

                                        mmsg="Bookmark added!";
                                        mainData[index].bookmark=true;



                                      }
                                      else {
                                        mmsg="Bookmark removed!";
                                        mainData[index].bookmark=false;

                                      }


                                      Fluttertoast.showToast(
                                          msg: mmsg,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white,
                                          fontSize: 16.0);

                                    });

                                  }
                                  else if(newValue==4){

                                      subscribeAPI(channel_id.toString(),is_subscribed,index);

                                  }

                                },
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

  Future<void> _getData() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      isLoading = false;
      liveData=null;
      mainData.clear();
      page = 1;

    });

    apiCall();

  }

  Widget _buildList() {
    return
      RefreshIndicator(
        key: liveData==null?refreshKey:null,
        child:
        ListView.builder(
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
                  if(_controller!=null) {
                  _controller.pause(),
                   },
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
                      index,
                      mainData[index].id,
                      mainData[index].title,
                      mainData[index].videoImage,

                      mainData[index].created_at,
                      mainData[index].channel_id,
                      mainData[index].channel,
                      mainData[index].channel_image,
                      mainData[index].video_duration,
                      mainData[index].videoUrl,
                      mainData[index].videoSourceType,
                      mainData[index].is_subscribed,
                      mainData[index].bookmark,
                      mainData[index].watched_percent,


                  )


              );
            }
          },
          controller: liveData==null?_sc:null,
        ),
        onRefresh: _getData,
      );
  }

}
class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}