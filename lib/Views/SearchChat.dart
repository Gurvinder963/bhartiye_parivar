import 'dart:convert';
import 'package:bhartiye_parivar/ApiResponses/ChatGroupResponse.dart';

import '../Utils/AppColors.dart';
import 'package:bhartiye_parivar/ApiResponses/VideoData.dart';
import 'package:bhartiye_parivar/Views/VideoSearchResult.dart';
import 'package:bhartiye_parivar/Views/ChatSearchResult.dart';
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
//String videoCategory="main";

class SearchChatPage extends StatefulWidget {
  final String video_category;

  SearchChatPage({Key key, @required this.video_category})
      : super(key: key);

  @override
 SearchChatPageState createState() {
    return SearchChatPageState(video_category);
  }
}

class SearchChatPageState extends State<SearchChatPage> {
  String video_category;

  SearchChatPageState(video_category) {
    this.video_category = video_category;
  }

  ScrollController _sc = new ScrollController();
  bool _isApiCalled = false;
  Widget appBarTitle = new Text(
    "",
    style: new TextStyle(color: Colors.black),
  );
  List mainData = new List();
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.black,
  );
  TextEditingController _searchQuery = new TextEditingController();
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
    _searchQuery.dispose();

    super.dispose();
  }

  void setSearchBar() {
    this.actionIcon = new Icon(
      Icons.close,
      color: Colors.black,
    );
    this.appBarTitle = new Container(
        margin: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
        height: 38,
        child: TextField(
          autofocus: true,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            if (mainData != null && mainData.length > 0) {
              var item = mainData[0];
              Navigator.of(context, rootNavigator: true)
                  .push(// ensures fullscreen
                      MaterialPageRoute(builder: (BuildContext context) {
                return ChatSearchResultPage(
                    video_id: item.chatGroupId.toString());
              }));
            }
          },
          onChanged: (value) {
            if (value.length > 1 && !_isApiCalled) {
              mainData.clear();
              setState(() {
                _isApiCalled = true;
              });
              getSearchList(user_Token, value).then((value) => {
                    addData(value.chat),
                    setState(() {
                      _isApiCalled = false;
                    })
                  });
            }
          },
          controller: _searchQuery,
          style: new TextStyle(color: Colors.black, fontSize: 15),
          decoration: new InputDecoration(
              contentPadding:
                  EdgeInsets.only(left: 15, bottom: 0, top: 10, right: 0),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8),
              ),

              //  prefixIcon: new Icon(Icons.search, color: Colors.black),
              hintText: "Search in " + video_category,
              // prefixIcon: IconButton(
              //   icon: Icon(Icons.search),
              // ),
              suffixIcon: IconButton(
                onPressed: () => {
                  setState(() {
                    _searchQuery.clear();

                    mainData.clear();
                  }),
                },
                icon: Icon(Icons.clear),
              ),
              hintStyle: new TextStyle(color: Colors.black),
            fillColor: Color(0xFFf1f1f1),
              filled: true),
        ));
    // _handleSearchStart();
  }

  void addData(List<Chat> videoData) {
    setState(() {
      _isInAsyncCall = false;
      isLoading = false;
      mainData.addAll(videoData);
    });
  }

  Future<ChatGroupResponse> getSearchList(
      String user_Token, String keyword) async {
    var body = json.encode({
      "appcode": Constants.AppCode,
      "token": user_Token,
      "userid": USER_ID,
      "page_category": video_category,
      "search": keyword
    });
    //  var body ={'keyword':'India'};
    MainRepository repository = new MainRepository();
    return repository.fetchChatSearchQueryListJAVA(body);
  }

  @override
  void initState() {
    super.initState();

    setSearchBar();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Future<String> token;
    token = _prefs.then((SharedPreferences prefs) {
      user_Token = prefs.getString(Prefs.KEY_TOKEN);

      USER_ID = prefs.getString(Prefs.USER_ID);

      // apiCall();

      return (prefs.getString('token'));
    });
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        // apiCall();
      }
    });
  }

  void apiCall() {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }

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

  Future<VideoTrendingListResponse> getVideosList(String user_Token) async {
    String pageIndex = page.toString();
    var body = json.encode({
      "appcode": Constants.AppCode,
      "token": user_Token,
      "userid": USER_ID,
      "page": pageIndex
    });
    MainRepository repository = new MainRepository();
    return repository.fetchVideoSearchQueryListJAVA(body);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    print("device_height" + height.toString());

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          toolbarHeight: 50,
          backgroundColor: Color(0xFFffffff),
          title: appBarTitle,
          elevation: 0,
        ),
        body: Container(
          height: (MediaQuery.of(context).size.height),
          color: Color(0xFFffffff),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: _buildList(),
                )
              ]),
        ));
  }

  Widget _buildBoxVideo(BuildContext context, int index, int id, String title,
      String thumbnail) {
    return Container(
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 5,
                        ),
                      
                       Image(
                                image:
                                    new AssetImage("assets/ic_search_new.png"),
                                width: 18,
                                height: 18,
                                color: null,
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.center,
                              ),
                               SizedBox(
                          width: 10,
                        ),
                      
                        new Expanded(
                            flex: 7,
                            child: Container(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
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
                                ]))),
                        SizedBox(
                          width: 10,
                        ),
                        thumbnail != null
                            ? Container(
                                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                alignment: Alignment.center,
                                height: 54,
                                width: 96,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(thumbnail),
                                  ),
                                ),
                              )
                            : Container(
                                height: 54,
                                width: 96,
                              ),
                        SizedBox(
                          width: 10,
                        ),
                        Image(
                          image: new AssetImage("assets/ic_arrow_top_left.png"),
                          width: 14,
                          height: 14,
                          color: null,
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                        ),
                        SizedBox(
                          width: 2,
                        ),
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
    return RefreshIndicator(
      key: refreshKey,
      child: ListView.builder(
        itemCount:
            mainData.length + 1, // Add one more item for progress indicator

        itemBuilder: (BuildContext context, int index) {
          if (index == mainData.length) {
            return _buildProgressIndicator();
          } else {
            return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => {
                      Navigator.of(context, rootNavigator: true).push(
                          // ensures fullscreen
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ChatSearchResultPage(
                            video_id: mainData[index].chatGroupId.toString());
                      }))
                    },
                child: _buildBoxVideo(
                  context,
                  index,
                  mainData[index].chatGroupId,
                  mainData[index].chatGroupTitle,
                  mainData[index].chatGroupPic,
               
                ));
          }
        },
        controller: _sc,
      ),
      onRefresh: _getData,
    );
  }
}
