import 'dart:convert';

import 'package:bhartiye_parivar/Views/LiveVideoDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Prefer.dart';
import '../ApiResponses/VideoTrendingListResponse.dart';
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
import '../ApiResponses/LiveDataResponse.dart';
import '../ApiResponses/BookMarkSaveResponse.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bhartiye_parivar/Utils/constants.dart';
import '../Interfaces/OnLangChange.dart';
String videoCategory="live";

class LivePage extends StatefulWidget {
  @override
  LivePageState createState() {
    return LivePageState();
  }
}

class LivePageState extends State<LivePage> {
  ScrollController _sc = new ScrollController();
  List mainData = new List();
  int page = 1;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  bool isLoading = false;
  String USER_ID;
  String user_Token;
  //bool isBookMarked = false;
  // bool isSubscribed= false;
  bool _isInAsyncCall = false;
  @override
  void dispose() {

    _sc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    eventBusLC.on<OnLangChange>().listen((event) {
      setState(() {
        isLoading = false;

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
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        apiCall();
      }
    });

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

      getVideosList(user_Token,videoCategory,locale).then((value) => {

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

  Future<AddToCartResponse> subscribeChannelAPI(String channelId,String xyz,bool is_subscribed) async {
    //  final String requestBody = json.encoder.convert(order_items);
    String status = "0";
    if (is_subscribed) {
      status = "0";

    } else {

      status = "1";
    }

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
    String status = "0";
    if (isBookMarked) {
      status = "0";

    } else {

      status = "1";
    }
    print('my_token'+token);
    var body =json.encode({"content_type": content_type, "content_id": content_id,"bookmark_type": status});
    MainRepository repository=new MainRepository();
    return repository.fetchAddBookMark(body,token);

  }


  Future<LiveDataResponse> getVideosList(String user_Token,String videoCategory, String locale) async {

    /*String pageIndex = page.toString();
    String perPage = "10";
    print(locale.toString());
    var body ={'video_category':videoCategory,'lang_code':locale, 'page': pageIndex,
      'per_page': perPage,};
    MainRepository repository=new MainRepository();
    return repository.fetchVideoData(body,user_Token);*/

    String pageIndex = page.toString();
    var body =json.encode({"appcode":Constants.AppCode, "token": user_Token,"userid": USER_ID,"video_category":videoCategory,"page":pageIndex});
    MainRepository repository=new MainRepository();
    return repository.fetchVideoListLiveJAVA(body);

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
                SizedBox(height: 2,),
                Expanded(
                  child: _buildList(),

                )

              ]) ,)

    );
  }
  subscribeAPI(String channel_id,bool is_subscribed,int index){

    subscribeChannelAPI(channel_id.toString(),"1",is_subscribed).then((res) async {
      String msg;
      if(is_subscribed){

        mainData[index].is_subscribed=false;
        msg="Unsubscribe channel successfully";
      }
      else{
        mainData[index].is_subscribed=true;
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
  Widget _buildBoxVideo(BuildContext context,int index,Live liveData){


  //  final DateFormat formatter = DateFormat('dd-MM-yyyy');
   // final String formatted = formatter.format(DateTime.parse(liveData.liv));

  //  channel=channel==null?"My Channel":channel;
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


                  liveData.liveVideoImage!=null? AspectRatio(
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

                      )):Container(width: 0,height: 0,),

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
                  // Positioned.fill(
                  //     child:Align(
                  //         alignment: Alignment.bottomRight,
                  //         child: Container(
                  //             padding: EdgeInsets.fromLTRB(10,3,10,5),
                  //             margin: EdgeInsets.fromLTRB(0,0,0,0.7),
                  //             color:  Color(0xFF5a5a5a),
                  //             child: Text(duration,  style: GoogleFonts.roboto(
                  //               fontSize:14.0,
                  //
                  //               color: Colors.white,
                  //               fontWeight: FontWeight.w500,
                  //
                  //             ),))
                  //
                  //
                  //     )),
                ],
              ),

              Container(
                  margin:  EdgeInsets.fromLTRB(10,5,10,0),
                  child:Row(

                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        liveData.liveChannelImage!=null? new Container(
                            width: 44.0,
                            height: 44.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: new NetworkImage(
                                        liveData.liveChannelImage)
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
                                                liveData.liveChannel!=null? Text(liveData.liveChannel,   overflow: TextOverflow.ellipsis,
                                                  maxLines: 1, style: GoogleFonts.roboto(
                                                    fontSize:12.0,
                                                    color: Color(0xFF5a5a5a),

                                                  ),):Container(width: 0,height: 0,),
                                                SizedBox(width: 10),

                                                // Container(
                                                //   width: 8,
                                                //   height: 8,
                                                //
                                                //   decoration: BoxDecoration(
                                                //       shape: BoxShape.circle,
                                                //       color: Color(0xFF5a5a5a)),
                                                // ),

                                              ])),



                                    ]))),



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
      mainData.clear();
      page = 1;

    });

    apiCall();

  }

  Widget _buildList() {
    return
      RefreshIndicator(
        key: refreshKey,
        child:
        ListView.builder(
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
                              return LiveVideoDetailPage(content: mainData[index]);
                            }
                        ))
                  },
                  child:
                  _buildBoxVideo(
                    context,
                    index,
                    mainData[index],



                  )


              );
            }
          },
          controller: _sc,
        ),
        onRefresh: _getData,
      );
  }

}