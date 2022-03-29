import 'dart:convert';

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
import '../ApiResponses/BookMarkSaveResponse.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bhartiye_parivar/Utils/constants.dart';
import '../Interfaces/OnLangChange.dart';
import '../Utils/AppColors.dart';
String videoCategory="trending";

class VideoBookMarkListPage extends StatefulWidget {
  @override
  VideoBookMarkListPageState createState() {
    return VideoBookMarkListPageState();
  }
}

class VideoBookMarkListPageState extends State<VideoBookMarkListPage> {
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


      getVideosList(user_Token).then((value) => {

        setState(() {
          isLoading = false;
          mainData.addAll(value.data);
          if (!mainData.isEmpty) {
            page++;
          }
        })

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



  Future<AddToCartResponse> subscribeChannelAPI(String channelId,String xyz,int is_subscribed) async {

    String status = "1";


    var body =json.encode({"channel_id":channelId,"is_subscribed":status});
    MainRepository repository=new MainRepository();

    return repository.fetchSubscribeChannel(body,user_Token);


  }


  Future<VideoTrendingListResponse> getVideosList(String user_Token) async {


    String pageIndex = page.toString();
    var body =json.encode({"appcode":Constants.AppCode, "token": user_Token,"userid": USER_ID,"page":pageIndex});
    MainRepository repository=new MainRepository();
    return repository.fetchVideoBookmarkListJAVA(body);

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
        appBar: AppBar(
          toolbarHeight: 50,

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
          backgroundColor: Color(AppColors.BaseColor),
          title: Text("Video Bookmark"),

        ),
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

              Container(
                  margin:  EdgeInsets.fromLTRB(10,5,10,0),
                  child:Row(

                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                            thumbnail!=null?   Container(
                                  margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),

                                  alignment: Alignment.center,
                                  height: 63,
                                  width: 112,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(thumbnail),
                                    ),
                                  ),

                                ):Container(
                        margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                            height: 63,
                                  width: 112,
                        alignment: Alignment.center,
                        // height: ScreenUtil().setHeight(175),
                    
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: new AssetImage("assets/thumbnail.png"),

                            alignment: Alignment.center,
                          ),

                        ),

                      ),






                        SizedBox(height: 5,width:15,),

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

        ListView.builder(
          itemCount: mainData.length+ 1 , // Add one more item for progress indicator

          itemBuilder: (BuildContext context, int index) {
            if (index == mainData.length) {
              return _buildProgressIndicator();
            } else {
              return GestureDetector(
                  behavior: HitTestBehavior.opaque,
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
          controller: _sc,
        );

  }

}
