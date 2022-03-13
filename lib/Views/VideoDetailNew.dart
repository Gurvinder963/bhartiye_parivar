import 'dart:convert';
import 'package:bhartiye_parivar/Views/JoinDonateWhom.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Utils/AppColors.dart';
import '../Utils/AppStrings.dart';
import '../ApiResponses/VideoTrendingListResponse.dart';
import '../ApiResponses/VideoDetailJAVAResponse.dart';
import '../Views/JoinUs.dart';
import 'DonateUs.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../Repository/MainRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../ApiResponses/VideoData.dart';
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
import '../Interfaces/OnAnyDrawerItemOpen.dart';

String videoCategory;
int _start = 0;

class VideoDetailNewPage extends StatefulWidget {
  final VideoData content;

  VideoDetailNewPage({Key key, @required this.content}) : super(key: key);
  @override
  VideoDetailNewPageState createState() {
    videoCategory = content.videoCategory;
    return VideoDetailNewPageState(content);
  }
}

class ReportList {
  String name;
  int index;
  ReportList({this.name, this.index});
}

class VideoDetailNewPageState extends State<VideoDetailNewPage>
    with WidgetsBindingObserver {
  ScrollController _sc = new ScrollController();
  String radioItem = '';

  // Group Value for Radio Button.
  int radioid = -1;
  Timer _timer;

  bool _isInAsyncCall = false;
  var marginPixel = 0;
  List mainData = new List();
  bool isLoading = false;
  bool isBookMarked = false;
  int isSubscribed;
  var likeStatus = 0;
  int page = 1;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  VideoData mContent;
  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;

  final List<String> _ids = [];

  String user_Token;
  String USER_ID;
  VideoDetailNewPageState(VideoData content) {
    mContent = content;

    var videoIdd = "A0pmI3FhoO4";
    if (mContent.videoSourceType == 'youtube') {
      try {
        videoIdd = YoutubePlayer.convertUrlToId(mContent.videoUrl);
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
    if (state == AppLifecycleState.paused) {
      _controller.pause();
      _timer.cancel();
      postSaveVideoInput(user_Token, "", "", "", mContent.id.toString())
          .then((res) async {
        _start = 0;
      });
    }
    else if(state == AppLifecycleState.resumed){
   _start = 0;
    startTimer();
    }
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
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

  Future<ShortDynamicLink> getShortLinksingle(String contentID) async {
    setState(() {
      _isInAsyncCall = true;
    });
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://bhartiyeparivar.page.link',
        link: Uri.parse('https://bhartiyeparivar.page.link/content?contentId=' +
            contentID.toString() +
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

  Future<ShortDynamicLink> getShortLink() async {
    setState(() {
      _isInAsyncCall = true;
    });
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://bhartiyeparivar.page.link',
        link: Uri.parse('https://bhartiyeparivar.page.link/content?contentId=' +
            mContent.id.toString() +
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

  Future<AddToCartResponse> subscribeChannelAPISINGLE(
      String channelId, String is_subscribed) async {
    String status = "1";

    var body = json.encode({"channel_id": channelId, "is_subscribed": status});
    MainRepository repository = new MainRepository();

    return repository.fetchSubscribeChannel(body, user_Token);
  }

  Future<AddToCartResponse> subscribeChannelAPI(
      String channelId, String is_subscribed) async {
    //  final String requestBody = json.encoder.convert(order_items);
    String status = "0";
    if (isSubscribed == 1) {
      status = "0";
    } else {
      status = "1";
    }

    var body = json.encode({"channel_id": channelId, "is_subscribed": status});
    MainRepository repository = new MainRepository();

    return repository.fetchSubscribeChannel(body, user_Token);
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        _start = _start + 1;
      },
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
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
      user_Token = prefs.getString(Prefs.KEY_TOKEN);
      USER_ID = prefs.getString(Prefs.USER_ID);

      if (!isLoading) {
        setState(() {
          isLoading = true;
        });
      }

      getVideoDetail(user_Token, mContent.id.toString()).then((value) => {
            setState(() {
              mContent = value.data[0];
              isBookMarked = mContent.bookmark;
              isSubscribed = mContent.is_subscribed;
              likeStatus = mContent.is_like;
              //   isLoading = false;
              // mainData.addAll(value.data);
            })
          });
      postSaveVideoInput(user_Token, "1", "", "", mContent.id.toString())
          .then((res) async {});

      apiCall();

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
    _start = 0;
    startTimer();
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
  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();

    Duration position = _controller.value.position;
    int sec = position.inSeconds;

    postSaveVideoInput(
            user_Token, "", sec.toString(), "", mContent.id.toString())
        .then((res) async {});
    super.deactivate();
  }

  Future<AddToCartResponse> postSaveVideoInput(
      String token,
      String clickedStatus,
      String videoPlayTime,
      String share,
      String content_id) async {
    String watchTimeNow = _start.toString();

    var body = json.encode({
      "video_duration": convertTime(mContent.video_duration),
      "video_clicked_status": clickedStatus,
      "video_watch_time": watchTimeNow,
      "shared_link_click_number": share,
      "video_unique_id": content_id
    });
    MainRepository repository = new MainRepository();
    return repository.fetchSaveVideoInput(body, token);
  }

  int convertTime(String duration) {
    RegExp regex = new RegExp(r'(\d+)');
    List<String> a = regex.allMatches(duration).map((e) => e.group(0)).toList();

    if (duration.indexOf('M') >= 0 &&
        duration.indexOf('H') == -1 &&
        duration.indexOf('S') == -1) {
      a = ["0", a[0], "0"];
    }

    if (duration.indexOf('H') >= 0 && duration.indexOf('M') == -1) {
      a = [a[0], "0", a[1]];
    }
    if (duration.indexOf('H') >= 0 &&
        duration.indexOf('M') == -1 &&
        duration.indexOf('S') == -1) {
      a = [a[0], "0", "0"];
    }

    int seconds = 0;

    if (a.length == 3) {
      seconds = seconds + int.parse(a[0]) * 3600;
      seconds = seconds + int.parse(a[1]) * 60;
      seconds = seconds + int.parse(a[2]);
    }

    if (a.length == 2) {
      seconds = seconds + int.parse(a[0]) * 60;
      seconds = seconds + int.parse(a[1]);
    }

    if (a.length == 1) {
      seconds = seconds + int.parse(a[0]);
    }
    return seconds;
  }

  Future<BookMarkSaveResponse> postAddBookMarkSINGLE(
      String content_type, String token, String content_id) async {
    String status = "1";

    var body = json.encode({
      "content_type": content_type,
      "content_id": content_id,
      "bookmark_type": status
    });
    MainRepository repository = new MainRepository();
    return repository.fetchAddBookMark(body, token);
  }

  Future<BookMarkSaveResponse> postAddBookMark(
      String content_type, String token, String content_id) async {
    String status = "0";
    if (isBookMarked) {
      status = "0";
    } else {
      status = "1";
    }

    var body = json.encode({
      "content_type": content_type,
      "content_id": content_id,
      "bookmark_type": status
    });
    MainRepository repository = new MainRepository();
    return repository.fetchAddBookMark(body, token);
  }

  Future<AddToCartResponse> postAddLike(
      String content_type, String token, String content_id) async {
    var body = json.encode({
      "content_type": content_type,
      "content_id": content_id,
      "like_status": likeStatus
    });
    MainRepository repository = new MainRepository();
    return repository.fetchSaveLikeStatus(body, token);
  }

  Future<VideoDetailJAVAResponse> getVideoDetail(
      String user_Token, String id) async {
    // var body ={'lang_code':''};
    // MainRepository repository=new MainRepository();
    // return repository.fetchVideoDetailData(id,body,user_Token);

    var body = json.encode({
      "userid": USER_ID,
      "video_category": videoCategory,
      "video_id": id,
      "appcode": Constants.AppCode,
      "token": user_Token
    });
    MainRepository repository = new MainRepository();
    return repository.fetchVideoDetailDataJAVA(body);
  }

  void apiCall() {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }
    getLocaleContentLang().then((locale) {
      if (locale == null) {
        locale = "";
      }

      getVideosListSuggestion(user_Token, videoCategory, mContent.id.toString())
          .then((value) => {
                setState(() {
                  isLoading = false;
                  mainData.addAll(value.data);

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

  Future<VideoTrendingListResponse> getVideosListSuggestion(
      String user_Token, String videoCategory, String videoId) async {
    MainRepository repository = new MainRepository();
    String pageIndex = page.toString();
    var body = json.encode({
      "appcode": Constants.AppCode,
      "token": user_Token,
      "userid": USER_ID,
      "video_category": videoCategory,
      "page": pageIndex,
      "video_id": videoId
    });

    if (videoCategory == 'main') {
      return repository.fetchVideoListHomeSuggestJAVA(body);
    } else if (videoCategory == 'trending') {
      return repository.fetchVideoListTrendingSuggestJAVA(body);
    } else {
      return repository.fetchVideoListCategorySuggestJAVA(body);
    }
  }

  Future<AddToCartResponse> saveReportAPI(message,reason,status,channel_id) async {
    //  final String requestBody = json.encoder.convert(order_items);

    

    var body = json.encode({
      "content_id": mContent.id.toString(),
      "content_type": "1",
      "message": message,
      "report_reason":reason,
      "channel_id":channel_id,
      "app_code":Constants.AppCode,
      "block_status":status?1:0,
      "userid":USER_ID,
      "token":user_Token
    });
    MainRepository repository = new MainRepository();

    return repository.fetchReportSaveJAVA(body);
  }




   Future _asyncInputDialogReportNew(BuildContext context, String id,String channel_id) async {
  
    return showDialog(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
       
     
//SingingCharacter _character = SingingCharacter.lafayette;
 String val = "";
 String teamName="";
 bool checkedValue=false;
        return AlertDialog(
            content:  SingleChildScrollView(
            scrollDirection: Axis.vertical,
             reverse: true,
             
             child:SizedBox(
            height: 510,child:StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
              height: 580 ,
          child:Column(
            children: <Widget>[
              Text("Please enter valid reason for reporting", style: const TextStyle(
                         
                          fontSize: 14.0,fontWeight: FontWeight.bold,
                        ),),
           SizedBox(
              height: 15,),               
         LabeledRadio(
            label: 'Sexual content',
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            value: "Sexual content",
            groupValue: val,
            onChanged: (String newValue) {
              setState(() {
                val = newValue;
              });
            },
          ),
          LabeledRadio(
            label: 'Violent or repulsive content',
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            value: "Violent or repulsive content",
            groupValue: val,
            onChanged: (String newValue) {
              setState(() {
                val = newValue;
              });
            },
          ),
  LabeledRadio(
            label: 'Hateful or abusive content ',
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            value: "Hateful or abusive content ",
            groupValue: val,
            onChanged: (String newValue) {
              setState(() {
                val = newValue;
              });
            },
          ),
           LabeledRadio(
            label: 'Anti-national content',
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            value: "Anti-national content",
            groupValue: val,
            onChanged: (String newValue) {
              setState(() {
                val = newValue;
              });
            },
          ),
           LabeledRadio(
            label: 'Inappropriate content',
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            value: "Inappropriate content",
            groupValue: val,
            onChanged: (String newValue) {
              setState(() {
                val = newValue;
              });
            },
          ),
 LabeledRadio(
            label: 'Spam or wrong information',
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            value: "Spam or wrong information",
            groupValue: val,
            onChanged: (String newValue) {
              setState(() {
                val = newValue;
              });
            },
          ),
           LabeledRadio(
            label: 'Others',
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            value: "Others",
            groupValue: val,
            onChanged: (String newValue) {
              setState(() {
                val = newValue;
              });
            },
          ),
 SizedBox(
              height: 5,),
        SizedBox(
              height: 70,
              width: 400,
              child: new TextField(
                autofocus: false,
                maxLines: 200,
                onChanged: (value) {
                  teamName = value;
                },
                decoration: new InputDecoration(
                   labelStyle: TextStyle(fontSize: ScreenUtil().setSp(12),color: Colors.grey,fontWeight: FontWeight.w700),
              hintStyle: TextStyle(fontSize: ScreenUtil().setSp(12),),

                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  border: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  hintText: 'Enter your report reason here',
                ),
              ),
            ),
                     CheckboxListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 4.0,
                                            vertical:5),
                                        activeColor: Colors.orange,
                                        checkColor: Colors.white,
                                        title: Text("Do not recommend me any content from this channel", style: const TextStyle(
                         
                          fontSize: 13.0,
                        ),),

                                        value: checkedValue,
                                        onChanged: (newValue) {
                                          setState(() {
                                            checkedValue = newValue;
                                          });
                                        },
                                        controlAffinity: ListTileControlAffinity
                                            .leading, //  <-- leading Checkbox
                                      ),
            
           
           
           
            ]
          ));
        },
        ))), actions: [
          FlatButton(
            child: Text('CANCEL',style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 13.0,
                        ),),
            onPressed: () {
            


              Navigator.of(context).pop();
            },
          ),

          FlatButton(
            child: Text('REPORT',style: const TextStyle(
                        color: Colors.blue,
                          fontSize: 13.0,
                        ),),
            onPressed: () {
              Navigator.of(context).pop();
             print(val);
              saveReportAPI(teamName,val,checkedValue,channel_id).then((res) async {
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



  // Future _asyncInputDialog(BuildContext context, String id) async {
  //   String teamName = '';
  //   return showDialog(
  //     context: context,
  //     barrierDismissible:
  //         false, // dialog is dismissible with a tap on the barrier
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Report Video"),
  //         content: SingleChildScrollView(
  //           scrollDirection: Axis.vertical,
  //           reverse: true,
  //           child: SizedBox(
  //             height: 250,
  //             width: 400,
  //             child: new TextField(
  //               autofocus: false,
  //               maxLines: 500,
  //               onChanged: (value) {
  //                 teamName = value;
  //               },
  //               decoration: new InputDecoration(
  //                 enabledBorder: const OutlineInputBorder(
  //                   borderSide:
  //                       const BorderSide(color: Colors.grey, width: 0.0),
  //                 ),
  //                 focusedBorder: const OutlineInputBorder(
  //                   borderSide:
  //                       const BorderSide(color: Colors.grey, width: 0.0),
  //                 ),
  //                 border: const OutlineInputBorder(
  //                   borderSide:
  //                       const BorderSide(color: Colors.grey, width: 0.0),
  //                 ),
  //                 hintText: 'Enter your report reason here',
  //               ),
  //             ),
  //           ),
  //         ),
  //         actions: [
  //           FlatButton(
  //             child: Text('CANCEL'),
  //             onPressed: () {
  //               Navigator.of(context).pop(teamName);
  //             },
  //           ),
  //           FlatButton(
  //             child: Text('REPORT'),
  //             onPressed: () {
  //               setState(() {
  //                 _isInAsyncCall = true;
  //               });
  //               Navigator.of(context).pop(teamName);
  //               saveReportAPI(teamName,val,checkedValue).then((res) async {
  //                 String msg;
  //                 setState(() {
  //                   _isInAsyncCall = false;
  //                 });
  //                 Fluttertoast.showToast(
  //                     msg: "Report save successfully",
  //                     toastLength: Toast.LENGTH_SHORT,
  //                     gravity: ToastGravity.BOTTOM,
  //                     timeInSecForIosWeb: 1,
  //                     backgroundColor: Colors.black,
  //                     textColor: Colors.white,
  //                     fontSize: 16.0);
  //               });
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  subscribeAPISINGLE(String channel_id, int is_subscribed, int index) {
    subscribeChannelAPISINGLE(channel_id.toString(), is_subscribed.toString())
        .then((res) async {
      String msg;

      mainData[index].is_subscribed = 1;
      msg = "Subscribe channel successfully";

      if (res.status == 1) {
        Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  subscribeAPI() {
    subscribeChannelAPI(mContent.channel_id.toString(), "1").then((res) async {
      String msg;
      if (isSubscribed == 1) {
        setState(() {
          isSubscribed = 0;
        });

        msg = "Unsubscribe channel successfully";
      } else {
        setState(() {
          isSubscribed = 1;
        });
        msg = "Subscribe channel successfully";
      }

      if (res.status == 1) {
        Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  _onShare(BuildContext context, String title, String thumbnail) async {
    var url = thumbnail;
    var response = await get(url);
    final documentDirectory = (await getExternalStorageDirectory()).path;
    File imgFile = new File('$documentDirectory/flutter.png');
    imgFile.writeAsBytesSync(response.bodyBytes);
    List<String> imagePaths = [];
    imagePaths.add('$documentDirectory/flutter.png');

    if (imagePaths.isNotEmpty) {
      await Share.shareFiles(
        imagePaths,
        text: title,
      );
    } else {
      await Share.share(
        title,
      );
    }
  }

  Widget mainWidget(Widget player) {
    var channel = mContent.channel == null ? "My Channel" : mContent.channel;
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted =
        formatter.format(DateTime.parse(mContent.created_at));

    return WillPopScope(
        onWillPop: () {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
              .then((_) {
            Navigator.of(context, rootNavigator: true).pop(context);
          });

          return Future.value(false);
        },
        child: Scaffold(
          appBar: isPortrait
              ? AppBar(
                  toolbarHeight: 50,
                  backgroundColor: Color(AppColors.BaseColor),
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => {
                            SystemChrome.setPreferredOrientations(
                                [DeviceOrientation.portraitUp]).then((_) {
                              Navigator.of(context, rootNavigator: true)
                                  .pop(context);
                            })
                          }),
                  title: Text(AppStrings.PlayingVideo),
                )
              : null,
          body: ModalProgressHUD(
              inAsyncCall: _isInAsyncCall,
              // demo of some additional parameters
              opacity: 0.01,
              progressIndicator: CircularProgressIndicator(),
              child: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    mContent.videoSourceType == 'facebook' ||
                            mContent.videoSourceType == 'brighteon'
                        ? _buildBoxVideo(context, mContent)
                        : player,
                    Expanded(
                        child: ListView(controller: _sc, children: <Widget>[
                      Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Row(
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
                                                mContent.channel_image)))),
                                SizedBox(
                                  height: 5,
                                  width: 8,
                                ),
                                new Expanded(
                                    flex: 7,
                                    child: Container(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                          SizedBox(height: 5),
                                          Text(
                                            mContent.title,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: GoogleFonts.roboto(
                                              fontSize: 15.0,
                                              color: Color(0xFF000000),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 5, 10, 0),
                                              child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      channel,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: GoogleFonts.roboto(
                                                        fontSize: 12.0,
                                                        color:
                                                            Color(0xFF5a5a5a),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Container(
                                                      width: 8,
                                                      height: 8,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Color(
                                                              0xFF5a5a5a)),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      formatted,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: GoogleFonts.roboto(
                                                        fontSize: 12.0,
                                                        color:
                                                            Color(0xFF5a5a5a),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                  ])),
                                        ]))),
                              ])),
                      Container(
                          margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: 2,
                                ),
                                IconButton(
                                    icon: likeStatus == 1
                                        ? Image(
                                            image: new AssetImage(
                                                "assets/like_sel.png"),
                                            width: 24,
                                            height: 24,
                                            color: null,
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.center,
                                          )
                                        : Image(
                                            image: new AssetImage(
                                                "assets/like_unsel.png"),
                                            width: 24,
                                            height: 24,
                                            color: null,
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.center,
                                          ),
                                    onPressed: () {
                                      setState(() {
                                        if (likeStatus == 1) {
                                          likeStatus = 0;
                                        } else {
                                          likeStatus = 1;
                                        }
                                      });

                                      postAddLike("1", user_Token,
                                              mContent.id.toString())
                                          .then((res) async {
                                        String msg = "";
                                        if (likeStatus == 1) {
                                          msg = "Added to liked videos";
                                        } else {
                                          msg = "Removed from liked videos";
                                        }
                                        Fluttertoast.showToast(
                                            msg: msg,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      });
                                    }),
                                SizedBox(
                                  width: 2,
                                ),
                                IconButton(
                                    icon: likeStatus == 2
                                        ? Image(
                                            image: new AssetImage(
                                                "assets/dislike_sel.png"),
                                            width: 24,
                                            height: 24,
                                            color: null,
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.center,
                                          )
                                        : Image(
                                            image: new AssetImage(
                                                "assets/dislike_unsel.png"),
                                            width: 24,
                                            height: 24,
                                            color: null,
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.center,
                                          ),
                                    onPressed: () {
                                      setState(() {
                                        if (likeStatus == 2) {
                                          likeStatus = 0;
                                        } else {
                                          likeStatus = 2;
                                        }
                                      });

                                      postAddLike("1", user_Token,
                                              mContent.id.toString())
                                          .then((res) async {
                                        String msg = "";
                                        if (likeStatus == 2) {
                                          msg = "You Dislike this video";
                                        } else {
                                          msg = "Dislike Removed";
                                        }
                                        Fluttertoast.showToast(
                                            msg: msg,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      });
                                    }),
                                SizedBox(
                                  width: 2,
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.report_outlined,
                                      size: 28,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      _asyncInputDialogReportNew(
                                          context, mContent.id.toString(),mContent.channel_id.toString());
                                    }),
                                IconButton(
                                    icon: Image(
                                      image: new AssetImage("assets/share.png"),
                                      width: 23,
                                      height: 23,
                                      color: Colors.black,
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.center,
                                    ),
                                    onPressed: () {
                                      postSaveVideoInput(user_Token, "", "",
                                              "1", mContent.id.toString())
                                          .then((res) async {
                                        getShortLink().then((res) {
                                          setState(() {
                                            _isInAsyncCall = false;
                                          });
                                          var url = res.shortUrl.toString();

                                          _onShare(
                                              context,
                                              mContent.title + ' ' + url,
                                              mContent.videoImage);
                                        });
                                      });
                                    }),
                                SizedBox(
                                  width: 2,
                                ),
                                IconButton(
                                    icon: isBookMarked
                                        ? Image(
                                            image: new AssetImage(
                                                "assets/bookmark_sel.png"),
                                            width: 24,
                                            height: 24,
                                            color: null,
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.center,
                                          )
                                        : Image(
                                            image: new AssetImage(
                                                "assets/bookmark_unsel.png"),
                                            width: 24,
                                            height: 24,
                                            color: null,
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.center,
                                          ),
                                    onPressed: () {
                                      /*  setState(() {
                                                _isInAsyncCall = true;
                                              });*/

                                      postAddBookMark("1", user_Token,
                                              mContent.id.toString())
                                          .then((res) async {
                                        /* setState(() {
                                                  _isInAsyncCall = false;
                                                });
*/

                                        String mmsg = "";
                                        if (res.bookmarkType == 1) {
                                          mmsg = "Bookmark added!";

                                          setState(() {
                                            isBookMarked = true;
                                          });
                                        } else {
                                          mmsg = "Bookmark removed!";
                                          setState(() {
                                            isBookMarked = false;
                                          });
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

                                      //  submitFavourite("1",tok,MyContentId.toString(),false);
                                    }),

                                //  Icon(Icons.bookmark_outline_outlined,size: 28,color: Color(0xFF666666),),
                                Expanded(
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                            onTap: () {
                                              if (isSubscribed == 2) {
                                                Widget okButton = FlatButton(
                                                  child: Text("OK"),
                                                  onPressed: () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop('dialog');
                                                    subscribeAPI();
                                                  },
                                                );
                                                Widget CANCELButton =
                                                    FlatButton(
                                                  child: Text("CANCEL"),
                                                  onPressed: () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop('dialog');
                                                  },
                                                );
                                                // set up the AlertDialog
                                                AlertDialog alert = AlertDialog(
                                                  content: Text(
                                                      "Are you sure you want subscribe channel " +
                                                          mContent.channel),
                                                  actions: [
                                                    CANCELButton,
                                                    okButton,
                                                  ],
                                                );

                                                // show the dialog
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return alert;
                                                  },
                                                );
                                              } else if (isSubscribed == 1) {
                                                Widget okButton = FlatButton(
                                                  child: Text("UNSUBSCRIBE"),
                                                  onPressed: () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop('dialog');
                                                    subscribeAPI();
                                                  },
                                                );
                                                Widget CANCELButton =
                                                    FlatButton(
                                                  child: Text("CANCEL"),
                                                  onPressed: () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop('dialog');
                                                  },
                                                );
                                                // set up the AlertDialog
                                                AlertDialog alert = AlertDialog(
                                                  content: Text(
                                                      "Unsubscribe from " +
                                                          mContent.channel),
                                                  actions: [
                                                    CANCELButton,
                                                    okButton,
                                                  ],
                                                );

                                                // show the dialog
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return alert;
                                                  },
                                                );
                                              } else {
                                                subscribeAPI();
                                              }
                                            },
                                            child: isSubscribed == 1
                                                ? Text(
                                                    "SUBSCRIBED",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.roboto(
                                                      fontSize: 16.0,
                                                      color: Color(0xFF000000),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  )
                                                : isSubscribed == 2
                                                    ? Text(
                                                        "BLOCKED",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.roboto(
                                                          fontSize: 16.0,
                                                          color:
                                                              Color(0xFFFF0000),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )
                                                    : Text(
                                                        "SUBSCRIBE",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.roboto(
                                                          fontSize: 16.0,
                                                          color: Color(AppColors
                                                              .BaseColor),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )))),
                                SizedBox(
                                  width: 5,
                                ),
                              ])),
                      Padding(
                          padding: EdgeInsets.fromLTRB(10, 7, 10, 3),
                          child: Divider(
                            color: Colors.grey,
                          )),
                      Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Row(
                              
                              children: <Widget>[
                                
                                _joinButton(),
                               Spacer(),
                                _DonateButton()
                              ])),
                      Padding(
                          padding: EdgeInsets.fromLTRB(10, 3, 10, 7),
                          child: Divider(
                            color: Colors.grey,
                          )),
                      _buildList(),
                    ]))
                  ]))),
        ));
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

    if (!isPortrait) {
      // marginPixel=0;
      // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
      SystemChrome.setEnabledSystemUIOverlays([]);
    } else {
      //marginPixel=0;
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    }

    final DateFormat formatter = DateFormat('dd-MM-yyyy');

    if (mContent.videoSourceType == 'facebook' ||
        mContent.videoSourceType == 'brighteon') {
      return mainWidget(null);
    } else {
      return YoutubePlayerBuilder(
          onEnterFullScreen: () {
            Future.delayed(const Duration(milliseconds: 2000), () {
              _controller.play();
            });
          },
          onExitFullScreen: () {
            if (_controller.value.isFullScreen) {
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp]).then((_) {
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
                onPressed: () {},
              ),
            ],
            onReady: () {
              _isPlayerReady = true;
            },
            onEnded: (data) {},
          ),
          builder: (context, player) => mainWidget(player));
    }
  }

  Widget _buildBoxVideoList(
      BuildContext context,
      int index,
      int id,
      String title,
      String thumbnail,
      String createdAt,
      String channel_id,
      String channel,
      String channel_image,
      String duration,
      String videoUrl,
      String videoSourceType,
      int is_subscribed,
      bool bookmark,
      int watched_percent) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(DateTime.parse(createdAt));

    return Container(
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Stack(
            children: <Widget>[
              AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),

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
              thumbnail != null
                  ? AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),

                        alignment: Alignment.center,
                        // height: ScreenUtil().setHeight(175),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(thumbnail),
                          ),
                        ),
                      ))
                  : Container(
                      height: 0,
                      width: 0,
                    ),
              Positioned.fill(
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                          padding: EdgeInsets.fromLTRB(10, 3, 10, 5),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0.7),
                          color: Color(0xFF5a5a5a),
                          child: Text(
                            duration,
                            style: GoogleFonts.roboto(
                              fontSize: 14.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          )))),
              watched_percent > 0
                  ? Positioned.fill(
                      child: Align(
                          alignment: Alignment.bottomLeft,
                          child: SliderTheme(
                            child: Container(
                                height: 1,
                                child: Slider(
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
                          )))
                  : Container(
                      height: 0,
                      width: 0,
                    ),
            ],
          ),
          Container(
              margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: <
                      Widget>[
                new Container(
                    width: 44.0,
                    height: 44.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(channel_image)))),
                SizedBox(
                  height: 5,
                  width: 8,
                ),
                new Expanded(
                    flex: 7,
                    child: Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                          SizedBox(height: 5),
                          Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: GoogleFonts.roboto(
                              fontSize: 15.0,
                              color: Color(0xFF000000),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      channel,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: GoogleFonts.roboto(
                                        fontSize: 12.0,
                                        color: Color(0xFF5a5a5a),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF5a5a5a)),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      formatted,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: GoogleFonts.roboto(
                                        fontSize: 12.0,
                                        color: Color(0xFF5a5a5a),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                  ])),
                        ]))),
                new Expanded(
                    flex: 1,
                    child: PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        onSelected: (newValue) {
                          // add this property

                          if (newValue == 1) {
                            postSaveVideoInput(
                                    user_Token, "", "", "1", id.toString())
                                .then((res) async {
                              getShortLinksingle(id.toString()).then((res) {
                                setState(() {
                                  _isInAsyncCall = false;
                                });
                                var url = res.shortUrl.toString();

                                _onShare(context, title + ' ' + url, thumbnail);
                              });
                            });
                          } else if (newValue == 2) {
                            _asyncInputDialogReportNew(context, id.toString(),channel_id.toString());
                          } else if (newValue == 3) {
                            postAddBookMarkSINGLE(
                                    "1", user_Token, id.toString())
                                .then((res) async {
                              String mmsg = "";
                              if (res.bookmarkType == 1) {
                                mmsg = "Bookmark added!";
                                //  mainData[index].bookmark=true;

                              } else {
                                mmsg = "Bookmark removed!";
                                //mainData[index].bookmark=false;

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
                          } else if (newValue == 4) {
                            subscribeAPISINGLE(
                                channel_id.toString(), is_subscribed, index);
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
                            ]))
              ]))
        ]));
  }

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
      itemCount:
          mainData.length + 1, // Add one more item for progress indicator
      shrinkWrap: true,

      physics: ScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        if (index == mainData.length) {
          return _buildProgressIndicator();
        } else {
          return GestureDetector(
              onTap: () => {
                    _controller.pause(),
                    _timer.cancel(),
                    postSaveVideoInput(
                            user_Token, "", "", "", mContent.id.toString())
                        .then((res) async {
                      _start = 0;
                    }),
                    Navigator.of(context, rootNavigator: true)
                        .pushReplacement(// ensures fullscreen
                            MaterialPageRoute(builder: (BuildContext context) {
                      return VideoDetailNewPage(content: mainData[index]);
                    }))
                  },
              child: _buildBoxVideoList(
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
              ));
        }
      },
    );
  }

  Widget _joinButton() {
    return InkWell(
      onTap: () {
        _controller.pause();
        _timer.cancel();

        Duration position = _controller.value.position;
        int sec = position.inSeconds;

        postSaveVideoInput(
                user_Token, "", sec.toString(), "", mContent.id.toString())
            .then((res) async {
          _start = 0;
        });

        Navigator.of(context, rootNavigator: true).push(// ensures fullscreen
            MaterialPageRoute(builder: (BuildContext context) {
          return JoinDonateWhomPage(from: "Join",fromScreen:"Detail",channel_id:mContent.channel_id);
        }));
      },
      child: Container(
        width: 140,
        height: 45,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                colors: [
                  Color(AppColors.BaseColor),
                  Color(AppColors.BaseColor)
                ])),
        child: Text(
          'Join Us',
          style: GoogleFonts.roboto(
              fontSize: 17, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _DonateButton() {
    return InkWell(
      onTap: () {
        _controller.pause();
        _timer.cancel();

        Duration position = _controller.value.position;
        int sec = position.inSeconds;

        postSaveVideoInput(
                user_Token, "", sec.toString(), "", mContent.id.toString())
            .then((res) async {
          _start = 0;
        });

        Navigator.of(context, rootNavigator: true).push(// ensures fullscreen
            MaterialPageRoute(builder: (BuildContext context) {
          return JoinDonateWhomPage(from: "Donate",fromScreen:"Detail",channel_id:mContent.channel_id);
        }));
      },
      child: Container(
        width: 140,
        height: 45,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
          style: GoogleFonts.roboto(
              fontSize: 17, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildBoxVideo(BuildContext context, VideoData content) {
    var channel = content.channel == null ? "My Channel" : content.channel;
    final width = MediaQuery.of(context).size.width;

    String html;
    // content.videoUrl="https://www.facebook.com/facebook/videos/10153231379946729/";

    //<iframe src="http://instagram.com/p/a1wDZKopa2/embed" width="400" height="480" frameborder="0" scrolling="no" allowtransparency="true"></iframe>

    if (content.videoSourceType == 'instagram') {
      html = '''
          <iframe src="http://instagram.com/p/CSgceH8nTFxjUMBDYnzT97db-ei_KY7fErctX40/embed" width="100%" height="100%" frameborder="0" scrolling="no" allowtransparency="true"></iframe>
     ''';
    } else if (content.videoSourceType == 'facebook') {
      html = '''
          <div style="width:100%;height:0px;position:relative;padding-bottom:56.25%;"><iframe style="width:100%;height:100%;position:absolute;left:0px;top:0px;overflow:hidden;"
            src="https://www.facebook.com/v2.3/plugins/video.php? 
            &autoplay=false&href=${content.videoUrl}" </iframe></div>
     ''';
    } else if (content.videoSourceType == 'dailymotion') {
      html = '''
           <iframe src='${content.videoUrl}?quality=240&info=0&logo=0' allowFullScreen></iframe>

     ''';
    } else if (content.videoSourceType == 'brighteon') {
      html = '''
           <iframe width="600" height="337" src='${content.videoUrl}' frameborder="0" allow="autoplay; encrypted-media"></iframe>

     ''';
    } else {
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
      html =
          '''<iframe id="player" width="100%" height="100%" style ="padding: 0px;position: relative; padding-top: 0px;height: 0;
            overflow: hidden;" type="text/html"
  src="https://www.youtube.com/embed/${videoIdd}?autoplay=true"
  frameborder="1"></iframe>
     ''';
    }

    return Container(
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 12.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  AspectRatio(
                      aspectRatio: 16 / 9,
                      child: HtmlWidget(
                        html,
                        webView: true,
                      ))
                ],
              ),
            ]));
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
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
  
}
class LabeledRadio extends StatelessWidget {
  const LabeledRadio({
    Key key,@required this.label,@required this.padding,@required this.groupValue,@required this.value,@required this.onChanged,
  }) : super(key: key);

  final String label;
  final EdgeInsets padding;
  final String groupValue;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        }
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Radio<String>(
              groupValue: groupValue,
              value: value,
              onChanged: (String newValue) {
                onChanged(newValue);
              },
            ),
            Text(label,  style: GoogleFonts.roboto(
              fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
